package com.poly.asm.controller;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.poly.asm.dao.BrandRepository;
import com.poly.asm.dao.CategoryRepository;
import com.poly.asm.dao.DetailedImageRepository;
import com.poly.asm.dao.DetailedInvoiceRepository;
import com.poly.asm.dao.InvoiceRepository;
import com.poly.asm.dao.ProductRepository;
import com.poly.asm.dao.StockReceiptRepository;
import com.poly.asm.dao.UserRepository;
import com.poly.asm.model.Brand;
import com.poly.asm.model.Category;
import com.poly.asm.model.DetailedImage;
import com.poly.asm.model.Invoice;
import com.poly.asm.model.MonthlySalesStatistics;
import com.poly.asm.model.Product;
import com.poly.asm.model.Report;
import com.poly.asm.model.StockReceipt;
import com.poly.asm.model.User;
import com.poly.asm.model.UserOderPayment;
import com.poly.asm.model.reportPieChart;
import com.poly.asm.service.SessionService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/shoeshop/admin")
public class IndexAdminController {

	@Autowired
	UserRepository daoUser;

	@Autowired
	CategoryRepository daoCategory;

	@Autowired
	ProductRepository daoProduct;

	@Autowired
	DetailedImageRepository daoDetailedImage; //

	@Autowired
	BrandRepository daoBrandRepository;

	@Autowired
	SessionService session;

	@Autowired
	StockReceiptRepository daoReceiptRepository;

	@Autowired
	DetailedInvoiceRepository daodetailedInvoiceRepository;

	@Autowired
	InvoiceRepository invoiceRepository;

	@Autowired
	StockReceiptRepository stockReceiptRepository;

	@Autowired
	private IndexController indexController;

	public void notification(Model model) {
		long quantityPending = invoiceRepository.countByStatus("pending");
		model.addAttribute("quantityPending", quantityPending);
	}

	@RequestMapping("/index")
	public String indexAdmin(Model model, @ModelAttribute("user") User user, @RequestParam(defaultValue = "0") int page,
			@RequestParam(name = "year", required = false) Integer selectedYear,
			@RequestParam(name = "invoiceStatus", required = false) String invoiceStatus,
			@RequestParam(name = "startDate", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date startDate,
			@RequestParam(name = "endDate", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date endDate

	) {
		model.addAttribute("index", "active");

		indexController.checkUser(model);

		notification(model);
		// tổng số lượng sản phẩm
		List<Report> reports = daoProduct.getTotalQuantity();
		model.addAttribute("rpIndex", reports);

		// tổng số lượng nhập kho
		List<Report> totalInventory = daoReceiptRepository.getTotalInventory();
		model.addAttribute("totalInventory", totalInventory);

		// tổng doanh thu
		List<Report> TotalRevenue = daoProduct.getTotalRevenue();
		model.addAttribute("TotalRevenue", TotalRevenue);

		// tổng oder
		List<Report> TotalODer = daodetailedInvoiceRepository.getTotalODer();
		model.addAttribute("TotalODer", TotalODer);

//		Biểu đồ sales
//		List<Integer> salesData = Arrays.asList(2115, 1562, 1584, 1892, 1587, 1923, 2566, 2448, 2805, 3438, 2917, 3327);
		List<Integer> yearIntegers = invoiceRepository.getAllYears();
		model.addAttribute("years", yearIntegers);
		List<MonthlySalesStatistics> ListSave = new ArrayList<>();

		if (selectedYear != null) {
			ListSave = invoiceRepository.getMonthlySalesStatistics(selectedYear);

		} else {
			ListSave = invoiceRepository.getMonthlySalesStatistics(2023);
		}
		// Kiểm tra và thêm các tháng không có dữ liệu
		for (int month = 1; month <= 12; month++) {
			boolean monthExists = false;
			for (MonthlySalesStatistics stats : ListSave) {
				if (stats.getMonth() == month) {
					monthExists = true;
					break;
				}
			}
			if (!monthExists) {
				MonthlySalesStatistics emptyMonthStats = new MonthlySalesStatistics(month, 0);
				ListSave.add(emptyMonthStats);
			}
		}

		model.addAttribute("yearUpdate", selectedYear);

		List<Integer> salesData = new ArrayList<>();

		for (MonthlySalesStatistics monthlySalesStatistics : ListSave) {
			salesData.add((int) monthlySalesStatistics.getCount());
			System.out.println(monthlySalesStatistics.getMonth() + "tháng");
			System.out.println(salesData + "Số đã bán");
		}
		model.addAttribute("salesData", salesData);

//		Biều đồ tròn
		reportPieChart rpPieChart = new reportPieChart();

		List<reportPieChart> itemGetAdiDas = daoBrandRepository.getAdiDas();
		List<reportPieChart> itemGetGucci = daoBrandRepository.getGucci();
		List<reportPieChart> itemGetNike = daoBrandRepository.getNike();

		model.addAttribute("itemGetAdiDas", itemGetAdiDas);
		model.addAttribute("itemGetGucci", itemGetGucci);
		model.addAttribute("itemGetNike", itemGetNike);

		List<Integer> pieData = new ArrayList<>();

		for (reportPieChart item : itemGetAdiDas) {
			pieData.add((int) item.getTotalQuantityAdidas());
		}

		for (reportPieChart item : itemGetGucci) {
			pieData.add((int) item.getTotalQuantityGucci());
		}

		for (reportPieChart item : itemGetNike) {
			pieData.add((int) item.getTotalQuantityNike());
		}

		model.addAttribute("pieData", pieData);

		
		List<MonthlySalesStatistics> stockIntegers = stockReceiptRepository.getMonthlyStockStatistics();
		List<Integer> barData = new ArrayList<>();
		List<MonthlySalesStatistics> updatedStockIntegers = new ArrayList<>();
		// Kiểm tra và thêm các tháng không có dữ liệu vào danh sách mới
		for (int month = 1; month <= 12; month++) {
			boolean monthExists = false;
			for (MonthlySalesStatistics stats : stockIntegers) {
				if (stats.getMonth() == month) {
					monthExists = true;
					updatedStockIntegers.add(stats);
					break;
				}
			}
			if (!monthExists) {
				MonthlySalesStatistics emptyMonthStats = new MonthlySalesStatistics(month, 0);
				updatedStockIntegers.add(emptyMonthStats);
			}
		}
		// Tạo danh sách barData từ danh sách updatedStockIntegers
		for (MonthlySalesStatistics monthlySalesStatistics : updatedStockIntegers) {
			barData.add((int) monthlySalesStatistics.getCount());
		}

		model.addAttribute("barData", barData);

		// đổ dữ liệu cho userOderPayment
		//sử lý không cho chọnn ngày đặt hàng sau hôm nay 
	    LocalDate PurchaseDate = LocalDate.now();
		 LocalDate selectedStartDate = startDate != null ? startDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate() : null;
		    if (selectedStartDate != null && selectedStartDate.isAfter(PurchaseDate)) {
		        model.addAttribute("errorMessageselectedStartDate", "Vui lòng chọn ngày mua trước ngày hôm nay");
		       // hoặc trả về view tương ứng
		    }  
		//sử lý không cho chọn ngày giao trước hôm nay 
		 LocalDate currentDate = LocalDate.now();
		 LocalDate selectedEndDate = endDate != null ? endDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate() : null;
		    if (selectedEndDate != null && selectedEndDate.isBefore(currentDate)) {
		        model.addAttribute("errorMessageselectedEndDate", "Vui lòng chọn ngày giao hàng sau hôm nay");
		     
		       // hoặc trả về view tương ứng
		    }
		 
		model.addAttribute("startDate", startDate);
		model.addAttribute("status", invoiceStatus);
		model.addAttribute("endDate", endDate);

		int pageSize = 100;
		Pageable pageable = PageRequest.of(page, pageSize);
		Page<UserOderPayment> userOrderPaymentPage;

		if (startDate != null && endDate != null) {
			userOrderPaymentPage = daodetailedInvoiceRepository.getUserOderPayWithDateRange(startDate, endDate,
					pageable);
			
		} else if (invoiceStatus != null && !invoiceStatus.isEmpty()) {
			userOrderPaymentPage = daodetailedInvoiceRepository.getUserOrderByStatus(invoiceStatus, pageable); 

		} else {
			userOrderPaymentPage = daodetailedInvoiceRepository.getUserOderPay(pageable);
		}

		model.addAttribute("userOrderPayment", userOrderPaymentPage.getContent());
		model.addAttribute("pageoder", page);
		model.addAttribute("userOrderPaymentPage", userOrderPaymentPage.getTotalPages());

		return "/admin/index";

	}

//Phần invoice Manager 
	@RequestMapping("/pending")
	public String invoicePending(Model model, @ModelAttribute("user") User user,
			@RequestParam("keywords") Optional<String> kw, @RequestParam("p") Optional<Integer> p,
			@RequestParam("field") Optional<String> field, HttpServletRequest request) {
		model.addAttribute("pending", "active");
		notification(model);

		indexController.checkUser(model);
		String order = request.getParameter("sortOrder");

		Sort sort = Sort.by(Direction.ASC, field.orElse("id"));
		if (order != null) {
			if (order.equals("desc")) {
				sort = Sort.by(Direction.DESC, field.orElse("id"));
			}
		}

		session.remove("keywords");
		String kwords = kw.orElse(session.get("keywords"));
		session.set("keywords", kwords, 30);
		model.addAttribute("keywords", session.get("keywords"));
		Pageable pageable = PageRequest.of(p.orElse(0), 5, sort);

		if (kw.isPresent()) {
			Page<Invoice> page = invoiceRepository.findByStatusAndIdContaining("pending", "%" + kwords + "%", pageable);
			model.addAttribute("invoices", page);
		} else {
			Page<Invoice> items = invoiceRepository.findByStatus("pending", pageable);
			model.addAttribute("invoices", items);
		}

		return "/admin/views/manager-invoice-pending";
	}

	@RequestMapping("/pending-update")
	public String iinvoicePending(Model model, @ModelAttribute("user") User user,
			@RequestParam("keywords") Optional<String> kw, @RequestParam("p") Optional<Integer> p,
			@RequestParam("field") Optional<String> field, HttpServletRequest request) {
		model.addAttribute("pending", "active");
		notification(model);
		indexController.checkUser(model);
		String order = request.getParameter("sortOrder");

		Sort sort = Sort.by(Direction.ASC, field.orElse("id"));
		if (order != null) {
			if (order.equals("desc")) {
				sort = Sort.by(Direction.DESC, field.orElse("id"));
			}
		}

		session.remove("keywords");
		String kwords = kw.orElse(session.get("keywords"));
		session.set("keywords", kwords, 30);
		model.addAttribute("keywords", session.get("keywords"));
		Pageable pageable = PageRequest.of(p.orElse(0), 5, sort);

		if (kw.isPresent()) {
			Page<Invoice> page = invoiceRepository.findByStatusAndIdContaining("pending", "%" + kwords + "%", pageable);
			model.addAttribute("invoices", page);
		} else {
			Page<Invoice> items = invoiceRepository.findByStatus("pending", pageable);
			model.addAttribute("invoices", items);
		}
		String successMessage = "Đơn hàng đã được xác nhận!";
		model.addAttribute("successMessage", successMessage);
		return "/admin/views/manager-invoice-pending";
	}

	@RequestMapping("/delivered")
	public String invoicedelivered(Model model, @ModelAttribute("user") User user,
			@RequestParam("keywords") Optional<String> kw, @RequestParam("p") Optional<Integer> p,
			@RequestParam("field") Optional<String> field, HttpServletRequest request) {
		model.addAttribute("delivered", "active");
		notification(model);
		indexController.checkUser(model);
		String order = request.getParameter("sortOrder");

		Sort sort = Sort.by(Direction.ASC, field.orElse("id"));
		if (order != null) {
			if (order.equals("desc")) {
				sort = Sort.by(Direction.DESC, field.orElse("id"));
			}
		}

		session.remove("keywords");
		String kwords = kw.orElse(session.get("keywords"));
		session.set("keywords", kwords, 30);
		model.addAttribute("keywords", session.get("keywords"));
		Pageable pageable = PageRequest.of(p.orElse(0), 5, sort);

		if (kw.isPresent()) {
			Page<Invoice> page = invoiceRepository.findByStatusAndIdContaining("delivered", "%" + kwords + "%",
					pageable);
			model.addAttribute("invoices", page);
		} else {
			Page<Invoice> items = invoiceRepository.findByStatus("delivered", pageable);
			model.addAttribute("invoices", items);
		}

		indexController.checkUser(model);
		return "/admin/views/manager-invoice-delivered";
	}

	@RequestMapping("/delivered-update")
	public String invoicedeliveredg(Model model, @ModelAttribute("user") User user,
			@RequestParam("keywords") Optional<String> kw, @RequestParam("p") Optional<Integer> p,
			@RequestParam("field") Optional<String> field, HttpServletRequest request) {
		model.addAttribute("delivered", "active");
		notification(model);
		indexController.checkUser(model);
		String order = request.getParameter("sortOrder");

		Sort sort = Sort.by(Direction.ASC, field.orElse("id"));
		if (order != null) {
			if (order.equals("desc")) {
				sort = Sort.by(Direction.DESC, field.orElse("id"));
			}
		}

		session.remove("keywords");
		String kwords = kw.orElse(session.get("keywords"));
		session.set("keywords", kwords, 30);
		model.addAttribute("keywords", session.get("keywords"));
		Pageable pageable = PageRequest.of(p.orElse(0), 5, sort);

		if (kw.isPresent()) {
			Page<Invoice> page = invoiceRepository.findByStatusAndIdContaining("delivered", "%" + kwords + "%",
					pageable);
			model.addAttribute("invoices", page);
		} else {
			Page<Invoice> items = invoiceRepository.findByStatus("delivered", pageable);
			model.addAttribute("invoices", items);
		}
		String successMessage = "Hoàn thành đơn hàng!";
		model.addAttribute("successMessage", successMessage);

		indexController.checkUser(model);
		return "/admin/views/manager-invoice-delivered";
	}

	@RequestMapping("/cancelled")
	public String invoiceCancelled(Model model, @ModelAttribute("user") User user,
			@RequestParam("keywords") Optional<String> kw, @RequestParam("p") Optional<Integer> p,
			@RequestParam("field") Optional<String> field, HttpServletRequest request) {
		notification(model);
		model.addAttribute("cancelled", "active");

		indexController.checkUser(model);
		String order = request.getParameter("sortOrder");

		Sort sort = Sort.by(Direction.ASC, field.orElse("id"));
		if (order != null) {
			if (order.equals("desc")) {
				sort = Sort.by(Direction.DESC, field.orElse("id"));
			}
		}

		session.remove("keywords");
		String kwords = kw.orElse(session.get("keywords"));
		session.set("keywords", kwords, 30);
		model.addAttribute("keywords", session.get("keywords"));
		Pageable pageable = PageRequest.of(p.orElse(0), 5, sort);

		if (kw.isPresent()) {
			Page<Invoice> page = invoiceRepository.findByStatusAndIdContaining("cancelled", "%" + kwords + "%",
					pageable);
			model.addAttribute("invoices", page);
		} else {
			Page<Invoice> items = invoiceRepository.findByStatus("cancelled", pageable);
			model.addAttribute("invoices", items);
		}
		return "/admin/views/manager-invoice-cancelled";
	}



	@RequestMapping("/list-brand")
	public String listBardAdmin(Model model, @ModelAttribute("user") User user,
			@RequestParam("keywords") Optional<String> kw, @RequestParam("p") Optional<Integer> p,
			@RequestParam("field") Optional<String> field, HttpServletRequest request) {
		model.addAttribute("list_brand", "active");
		notification(model);
		indexController.checkUser(model);

		String order = request.getParameter("sortOrder");

		Sort sort = Sort.by(Direction.ASC, field.orElse("name"));
		if (order != null) {
			if (order.equals("desc")) {
				sort = Sort.by(Direction.DESC, field.orElse("name"));
			}
		}

		session.remove("keywords");
		String kwords = kw.orElse(session.get("keywords"));
		session.set("keywords", kwords, 30);
		model.addAttribute("keywords", session.get("keywords"));
		Pageable pageable = PageRequest.of(p.orElse(0), 5, sort);

		if (kw.isPresent()) {
			Page<Brand> page = daoBrandRepository.findAllByNameLike("%" + kwords + "%", pageable);
			model.addAttribute("brands", page);
		} else {
			Page<Brand> items = daoBrandRepository.findAll(pageable);
			model.addAttribute("brands", items);
		}

		return "/admin/views/list-brand";
	}

	@RequestMapping("/list-category")
	public String listCategoryAdmin(Model model, @ModelAttribute("user") User user,
			@RequestParam("keywords") Optional<String> kw, @RequestParam("p") Optional<Integer> p,
			@RequestParam("field") Optional<String> field, HttpServletRequest request) {

		model.addAttribute("list_category", "active");

		indexController.checkUser(model);
		notification(model);
		String order = request.getParameter("sortOrder");

		Sort sort = Sort.by(Direction.ASC, field.orElse("name"));
		if (order != null) {
			if (order.equals("desc")) {
				sort = Sort.by(Direction.DESC, field.orElse("name"));
			}
		}

		session.remove("keywords");
		String kwords = kw.orElse(session.get("keywords"));
		session.set("keywords", kwords, 30);
		model.addAttribute("keywords", session.get("keywords"));
		Pageable pageable = PageRequest.of(p.orElse(0), 5, sort);

		if (kw.isPresent()) {
			Page<Category> page = daoCategory.findAllByNameLike("%" + kwords + "%", pageable);
			model.addAttribute("categories", page);
		} else {
			Page<Category> items = daoCategory.findAll(pageable);
			model.addAttribute("categories", items);
		}

		return "/admin/views/list-category";
	}

	@RequestMapping("/list-product")
	public String listProductAdmin(Model model, @ModelAttribute("user") User user,
			@RequestParam("keywords") Optional<String> kw, @RequestParam("p") Optional<Integer> p,
			@RequestParam("field") Optional<String> field, HttpServletRequest request) {
		model.addAttribute("list_product", "active");
		notification(model);
		indexController.checkUser(model);
		String order = request.getParameter("sortOrder");

		Sort sort = Sort.by(Direction.ASC, field.orElse("price"));
		if (order != null) {
			if (order.equals("desc")) {
				sort = Sort.by(Direction.DESC, field.orElse("price"));
			}
		}

		session.remove("keywords");
		String kwords = kw.orElse(session.get("keywords"));
		session.set("keywords", kwords, 30);
		model.addAttribute("keywords", session.get("keywords"));
		Pageable pageable = PageRequest.of(p.orElse(0), 5, sort);
		if (kw.isPresent()) {
			Page<Product> page = daoProduct.findAllByNameLike("%" + kwords + "%", pageable);
			model.addAttribute("products", page);
		} else {
			Page<Product> items = daoProduct.findAll(pageable);
			model.addAttribute("products", items);
		}
		return "/admin/views/list-product";
	}

	@RequestMapping("/list-user")
	public String listUserAdmin(Model model, @ModelAttribute("user") User user,
			@RequestParam("keywords") Optional<String> kw, @RequestParam("p") Optional<Integer> p,
			@RequestParam("field") Optional<String> field, HttpServletRequest request) {
		model.addAttribute("list_user", "active");

		indexController.checkUser(model);
		notification(model);
		String order = request.getParameter("sortOrder");

		Sort sort = Sort.by(Direction.ASC, field.orElse("name"));
		if (order != null) {
			if (order.equals("desc")) {
				sort = Sort.by(Direction.DESC, field.orElse("name"));
			}
		}

		session.remove("keywords");
		String kwords = kw.orElse(session.get("keywords"));
		session.set("keywords", kwords, 30);
		model.addAttribute("keywords", session.get("keywords"));
		Pageable pageable = PageRequest.of(p.orElse(0), 5, sort);
		if (kw.isPresent()) {
			Page<User> page = daoUser.findAllByNameLike("%" + kwords + "%", pageable);
			model.addAttribute("users", page);
		} else {
			Page<User> items = daoUser.findAll(pageable);
			model.addAttribute("users", items);
		}

		return "/admin/views/list-user";
	}


}
