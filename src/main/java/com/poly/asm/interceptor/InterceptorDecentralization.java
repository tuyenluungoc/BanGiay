package com.poly.asm.interceptor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.poly.asm.config.short_method.History;
import com.poly.asm.dao.UserHistoryRepository;
import com.poly.asm.model.User;
import com.poly.asm.service.SessionService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Service
public class InterceptorDecentralization implements HandlerInterceptor {
	@Autowired
	SessionService session;

	@Autowired
	private History historyShort;

	@Autowired
	private UserHistoryRepository historyRepository;

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		String uri = request.getRequestURI();
		User user = session.get("user");

		if (user != null && modelAndView != null) {
			if (user.isStatus() == false) {
				modelAndView.setViewName("redirect:/shoeshop/band");
			} else {
				String noteString = "Đăng nhập";
				historyShort.setHistory(noteString, user);
				if (user.isAdmin()) {
					modelAndView.setViewName("redirect:/shoeshop/admin/index");
				} else {
					modelAndView.setViewName("redirect:/shoeshop/index");
				}
			}

		}
	}

}
