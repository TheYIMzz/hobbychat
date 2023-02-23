package com.hobbychat.hobbychat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SignUpController {

    private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

    @RequestMapping("/viewSignUp")
    public String viewSignUp(Model model) {
        logger.info("회원가입 폼 이동");


        return "/viewHome";
    }
}
