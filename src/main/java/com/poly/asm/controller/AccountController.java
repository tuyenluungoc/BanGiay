package com.poly.asm.controller;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.poly.asm.config.short_method.History;
import com.poly.asm.config.short_method.Mail;
import com.poly.asm.dao.UserHistoryRepository;
import com.poly.asm.dao.UserRepository;
import com.poly.asm.model.MailInfo2;
import com.poly.asm.model.User;
import com.poly.asm.service.CookieService;
import com.poly.asm.service.MailerService2;
import com.poly.asm.service.ParamService;
import com.poly.asm.service.SessionService;

import jakarta.mail.MessagingException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;

@Controller
@RequestMapping("/shoeshop")
public class AccountController {

	@Value("${recaptcha.secretkey}")
	private String recaptchaSecretKey;

	@Autowired
	UserRepository dao; // dao của user

	@Autowired
	CookieService cookieService;

	@Autowired
	ParamService paramService;

	@Autowired
	SessionService sessionService;

	@Autowired
	HttpServletRequest request;

	@Autowired
	SessionService session;

	@Autowired
	private MailerService2 mailerService2;

	@Autowired
	private Mail mail;

	@Autowired
	private UserHistoryRepository historyRepository;

	@Autowired
	private History historyShort;

	@GetMapping("/login")
	public String login(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("failed", session.getString("mess"));
		user.setEmail(cookieService.getValue("email"));
		session.remove("mess");
		return "/account/login";
	}

	private boolean verifyRecaptcha(String recaptchaResponse) {
		// Gửi yêu cầu xác thực reCAPTCHA đến Google
		String url = "https://www.google.com/recaptcha/api/siteverify";
		RestTemplate restTemplate = new RestTemplate();

		MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
		body.add("secret", recaptchaSecretKey);
		body.add("response", recaptchaResponse);

		ResponseEntity<Map> recaptchaResponseEntity = restTemplate.postForEntity(url, body, Map.class);
		Map<String, Object> responseBody = recaptchaResponseEntity.getBody();

		int statusCode = recaptchaResponseEntity.getStatusCodeValue();
		System.out.println(responseBody);
		System.out.println("Mã trạng thái: " + statusCode);

		// Kiểm tra kết quả từ Google reCAPTCHA
		boolean success = (Boolean) responseBody.get("success");

		return success;
	}
	
	
	@GetMapping("/oauth2/authorization/google")
    public String googleLogin() {
        return "redirect:/oauth2/authorize/google"; // Redirect to Google Sign-In
    }
    
    @GetMapping("/oauth2/authorization/google/callback")
    public String googleCallback() {
        return "redirect:/shoeshop/index"; // Redirect to the login success URL
    }
	
	@PostMapping("/login")
	public String loginCheck(@Valid @ModelAttribute("user") User user, BindingResult rs, Model model,
			@RequestParam(name = "remember", defaultValue = "false") boolean remember,
			@RequestParam(name = "g-recaptcha-response") String recaptchaResponse) {
		List<User> users = dao.findAll();
		String input = recaptchaResponse;
		String searchTerm = ",your_test_value";
		String result = input.replace(searchTerm, "");


		if (result.equals("")) {
			String errorMessage = "Vui lòng xác nhận bạn không phải là robot.";
			System.out.println(errorMessage);
			model.addAttribute("failed", errorMessage);
			model.addAttribute("recaptchaError", errorMessage);
			return "/account/login";
		}

		if (remember) {
			cookieService.add("email", user.getEmail(), 10);
//			System.out.println(cookieService.getValue("email") + "cookie");
		} else {
			cookieService.remove("email");
		}
		for (User user2 : users) {
			if (user.getEmail().equalsIgnoreCase(user2.getEmail())) {
				if (user.getPassword().equalsIgnoreCase(user2.getPassword())) {
					session.set("user", user2, 30);

				} else {
					String successMessage = "Tài khoản hoặc mật khẩu không chính xác?";
					model.addAttribute("failed", successMessage);
				}
			}
		}

		return "/account/login";
	}

	// trang signUp
	@GetMapping("/signUp")
	public String signUp(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("dk_user", user);

//		List<User> lits_user = dao.findAll();
//		model.addAttribute("lits_user", lits_user);

		user.setPhone("SĐT NUll");
		return "/account/signUp";
	}

	// trang signUp
	public static String generateRandomNumber() {
		Random random = new Random();
		StringBuilder sb = new StringBuilder();

		for (int i = 0; i < 9; i++) {
			int digit = random.nextInt(10); // Sinh số ngẫu nhiên từ 0 đến 9
			sb.append(digit);
		}

		return sb.toString();
	}


	// trang logout
	@RequestMapping("/log-out")
	public String logOut() {
		session.remove("user");
		return "redirect:/shoeshop/index";
	}

	// trang kiểm tra password
	@RequestMapping("/ChangePass")
	public String ChangePass(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("ui_user", "active");

		return "/account/ChangePass";
	}

	// trang nhập mật khẩu mới confrimPassword
	@PostMapping("/ChangePass")
	public String ChangePassCheck(@Valid @ModelAttribute("user") User user, BindingResult rs, Model model,
			@RequestParam("password") String password) {
		User a = session.get("user");
		if (a.getPassword().equals(user.getPassword())) {

			System.out.println(user.getPassword());
			System.out.println("thành công");

			return "redirect:/shoeshop/ChangeRePass-Change";
		} else {
//			System.out.println("mật khẩu sai");
			String successMessage = "Mật khẩu không trùng nhau!";
			model.addAttribute("failed", successMessage);

		}

		return "/account/ChangePass";
	}

	// trang nhập mật khẩu mới
	@GetMapping("/ChangeRePass-Change")
	public String ChangeRePass(@ModelAttribute("user") User user, Model model) {
		User a = session.get("user");
		model.addAttribute("user", a);
		return "/account/ChangeRePass";
	}

	// phương thức thay đổi mật khẩu mới
	@PostMapping("/ChangeRePass-Change")
	public String PassCheck(@ModelAttribute("user") User user, Model model, BindingResult result,
			@RequestParam("confirmpassword") String confirmpassword) {

		if (result.hasErrors()) {
			System.out.println(result.toString());
			return "/account/ChangeRePass-Change";
		}
		if (!user.getPassword().equalsIgnoreCase(confirmpassword)) {
			String successMessage = "Mật khẩu không trùng nhau! hoặc mật khẩu đã để trống!!";
			model.addAttribute("failed", successMessage);
			return "/account/ChangeRePass";
		}

		User defaultUser = new User();
		model.addAttribute("user", defaultUser);
		User a = session.get("user");

		System.out.println(user.getPassword() + "old");

		a.setPassword(user.getPassword());
		System.out.println(a.getID());
		System.out.println(a.getEmail());
		System.out.println(a.getName());
		System.out.println(a.getPassword());
		System.out.println(a.getPhone());
		dao.save(a);
		Date currentDate = new Date();

		String noteString = "Đã đổi mật khẩu ";
		historyShort.setHistory(noteString, user);

		return "redirect:/shoeshop/index";
	}


}
