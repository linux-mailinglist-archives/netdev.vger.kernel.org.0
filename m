Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372B6662E3B
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbjAISKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237085AbjAISIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:08:52 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BEB48CDE
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:08:00 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id cf42so14282200lfb.1
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pwsg4QVc9AyvyNu9ShsKmZaCH3R6KfUiTyoHwtNUPj8=;
        b=Sk3j1cE2BaagKjymBOM4mDrAFuwcRujRT6UC/25yRK8p7rUU3X5ldOvQO8YOrelBi9
         i7i1PRzAbXvaDqQdA6ybPr50tb4fmtYtD/BYSMJ/Yzq7SK5pGXmt9TBmm86Vl96uwG6D
         VEIJKrK/HfisPvSENBGA5jvR2aJhrsMMaluSDLi5QcMHocuWuAvDzMm5UFJiMa0u/0Ik
         ksWG5jGbmwl6C0FExq+YnVb5VjsQmhIg5GgilUN1RvNa+aaM5g+w6hcIXmTMwGzkpDsJ
         J0almEAulNAcfq1LpILoiT6ONnAam9geJcVJuQTe/j+8ijGgWMwGNxcoHR8dPSog8myh
         T0rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pwsg4QVc9AyvyNu9ShsKmZaCH3R6KfUiTyoHwtNUPj8=;
        b=nzFpdauCsCGbPyRMMofXYGrASyaVpxpCbdI7CFRIf9U+8BuXHiZU7LmoVl0wpgOKzY
         M3xHmKYpYKpkkpjl8b2uQGn5eueMLgNQzrArHka41zu0voaEVQYSecZHx3KF0BEZnu3n
         Ua5cjbpvc/PVx+1I3o3nUxa8u5LraUczChT2eehvdGw78zWTr3YwS+cEW3YZSq5h4TAC
         lJfLL2m11iOyVdcTqtLW5Pkl4efTmhaSZZkC6YMk+GDBrlwOboBMkMupWqSVWgpy1uOa
         u80zgS3OyZzPWr5qUUMx0Dh+KFs6dL/4fSFU1oUrCPegD2HzpwlMAnmrfRGIHA6Mtuy9
         WAkg==
X-Gm-Message-State: AFqh2koSTjCLMFi8AJEMCAE2ZWwhCItdTuggHeNivakWERBdT/wxGvvq
        tSUbYspLX/dJ7Dae2UPYnrVU0A==
X-Google-Smtp-Source: AMrXdXuOqASLvi4tiNiwXRjVo9ohj4BzZc8BTU/A1++4YyZdaVXbMn3Rt/+6PUzRm1p7oTk2jSX3tQ==
X-Received: by 2002:a19:4345:0:b0:4cc:7282:702b with SMTP id m5-20020a194345000000b004cc7282702bmr2372735lfj.2.1673287678457;
        Mon, 09 Jan 2023 10:07:58 -0800 (PST)
Received: from [192.168.1.101] (abxi45.neoplus.adsl.tpnet.pl. [83.9.2.45])
        by smtp.gmail.com with ESMTPSA id e15-20020a05651236cf00b00492e3c8a986sm1714931lfs.264.2023.01.09.10.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 10:07:57 -0800 (PST)
Message-ID: <55066676-e998-3654-5400-14ffb79800d8@linaro.org>
Date:   Mon, 9 Jan 2023 19:07:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 10/18] pinctrl: qcom: sa8775p: add the pinctrl driver for
 the sa8775p platform
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, Yadu MG <quic_ymg@quicinc.com>,
        Prasad Sodagudi <quic_psodagud@quicinc.com>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
 <20230109174511.1740856-11-brgl@bgdev.pl>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230109174511.1740856-11-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9.01.2023 18:45, Bartosz Golaszewski wrote:
> From: Yadu MG <quic_ymg@quicinc.com>
> 
> Add support for Lemans TLMM configuration and control via the pinctrl
> framework.
> 
> Signed-off-by: Yadu MG <quic_ymg@quicinc.com>
> Signed-off-by: Prasad Sodagudi <quic_psodagud@quicinc.com>
> [Bartosz: made the driver ready for upstream]
> Co-developed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---

[...]

> +
> +static const char * const gpio_groups[] = {
> +	"gpio0", "gpio1", "gpio2", "gpio3", "gpio4", "gpio5", "gpio6", "gpio7",
> +	"gpio8", "gpio9", "gpio10", "gpio11", "gpio12", "gpio13", "gpio14",
> +	"gpio15", "gpio16", "gpio17", "gpio18", "gpio19", "gpio20", "gpio21",
> +	"gpio22", "gpio23", "gpio24", "gpio25", "gpio26", "gpio27", "gpio28",
> +	"gpio29", "gpio30", "gpio31", "gpio32", "gpio33", "gpio34", "gpio35",
> +	"gpio36", "gpio37", "gpio38", "gpio39", "gpio40", "gpio41", "gpio42",
> +	"gpio43", "gpio44", "gpio45", "gpio46", "gpio47", "gpio48", "gpio49",
> +	"gpio50", "gpio51", "gpio52", "gpio53", "gpio54", "gpio55", "gpio56",
> +	"gpio57", "gpio58", "gpio59", "gpio60", "gpio61", "gpio62", "gpio63",
> +	"gpio64", "gpio65", "gpio66", "gpio67", "gpio68", "gpio69", "gpio70",
> +	"gpio71", "gpio72", "gpio73", "gpio74", "gpio75", "gpio76", "gpio77",
> +	"gpio78", "gpio79", "gpio80", "gpio81", "gpio82", "gpio83", "gpio84",
> +	"gpio85", "gpio86", "gpio87", "gpio88", "gpio89", "gpio90", "gpio91",
> +	"gpio92", "gpio93", "gpio94", "gpio95", "gpio96", "gpio97", "gpio98",
> +	"gpio99", "gpio100", "gpio101", "gpio102", "gpio103", "gpio104",
> +	"gpio105", "gpio106", "gpio107", "gpio108", "gpio109", "gpio110",
> +	"gpio111", "gpio112", "gpio113", "gpio114", "gpio115", "gpio116",
> +	"gpio117", "gpio118", "gpio119", "gpio120", "gpio121", "gpio122",
> +	"gpio123", "gpio124", "gpio125", "gpio126", "gpio127", "gpio128",
> +	"gpio129", "gpio130", "gpio131", "gpio132", "gpio133", "gpio134",
> +	"gpio135", "gpio136", "gpio137", "gpio138", "gpio139", "gpio140",
> +	"gpio141", "gpio142", "gpio143", "gpio144", "gpio145", "gpio146",
> +	"gpio147", "gpio148",
> +};
> +static const char * const atest_char_groups[] = {
A newline after };-s would make this consistent with other drivers.

[...]

> +
> +/* Every pin is maintained as a single group, and missing or non-existing pin
/*
 * Every pin

With these nits:

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
> + * would be maintained as dummy group to synchronize pin group index with
> + * pin descriptor registered with pinctrl core.
> + * Clients would not be able to request these dummy pin groups.
> + */
> +static const struct msm_pingroup sa8775p_groups[] = {
> +	[0] = PINGROUP(0, _, _, _, _, _, _, _, _, _),
> +	[1] = PINGROUP(1, pcie0_clkreq, _, _, _, _, _, _, _, _),
> +	[2] = PINGROUP(2, _, _, _, _, _, _, _, _, _),
> +	[3] = PINGROUP(3, pcie1_clkreq, _, _, _, _, _, _, _, _),
> +	[4] = PINGROUP(4, _, _, _, _, _, _, _, _, _),
> +	[5] = PINGROUP(5, _, _, _, _, _, _, _, _, _),
> +	[6] = PINGROUP(6, emac0_ptp, emac0_ptp, emac1_ptp, emac1_ptp, _, _, _, _, _),
> +	[7] = PINGROUP(7, sgmii_phy, _, _, _, _, _, _, _, _),
> +	[8] = PINGROUP(8, emac0_mdc, _, _, _, _, _, _, _, _),
> +	[9] = PINGROUP(9, emac0_mdio, _, _, _, _, _, _, _, _),
> +	[10] = PINGROUP(10, usb2phy_ac, emac0_ptp, emac0_ptp, emac1_ptp, emac1_ptp, _, _, _, _),
> +	[11] = PINGROUP(11, usb2phy_ac, emac0_ptp, emac0_ptp, emac1_ptp, emac1_ptp, _, _, _, _),
> +	[12] = PINGROUP(12, usb2phy_ac, emac0_ptp, emac0_ptp, emac1_ptp, emac1_ptp,
> +			emac0_mcg0, _, _, _),
> +	[13] = PINGROUP(13, qup3_se0, emac0_mcg1, _, _, sail_top, _, _, _, _),
> +	[14] = PINGROUP(14, qup3_se0, emac0_mcg2, _, _, sail_top, _, _, _, _),
> +	[15] = PINGROUP(15, qup3_se0, emac0_mcg3, _, _, sail_top, _, _, _, _),
> +	[16] = PINGROUP(16, qup3_se0, emac1_mcg0, _, _, sail_top, _, _, _, _),
> +	[17] = PINGROUP(17, qup3_se0, tb_trig, tb_trig, emac1_mcg1, _, _, _, _, _),
> +	[18] = PINGROUP(18, qup3_se0, emac1_mcg2, _, _, sailss_ospi, sailss_emac0, _, _, _),
> +	[19] = PINGROUP(19, qup3_se0, emac1_mcg3, _, _, sailss_ospi, sailss_emac0, _, _, _),
> +	[20] = PINGROUP(20, qup0_se0, emac1_mdc, qdss_gpio, _, _, _, _, _, _),
> +	[21] = PINGROUP(21, qup0_se0, emac1_mdio, qdss_gpio, _, _, _, _, _, _),
> +	[22] = PINGROUP(22, qup0_se0, qdss_gpio15, _, _, _, _, _, _, _),
> +	[23] = PINGROUP(23, qup0_se0, qdss_gpio14, _, _, _, _, _, _, _),
> +	[24] = PINGROUP(24, qup0_se1, qdss_gpio13, _, _, _, _, _, _, _),
> +	[25] = PINGROUP(25, qup0_se1, phase_flag31, _, qdss_gpio12, _, _, _, _, _),
> +	[26] = PINGROUP(26, sgmii_phy, qup0_se1, qdss_cti, phase_flag30, _, _, _, _, _),
> +	[27] = PINGROUP(27, qup0_se1, qdss_cti, phase_flag29, _, atest_char, _, _, _, _),
> +	[28] = PINGROUP(28, qup0_se3, phase_flag28, _, qdss_gpio11, _, _, _, _, _),
> +	[29] = PINGROUP(29, qup0_se3, phase_flag27, _, qdss_gpio10, _, _, _, _, _),
> +	[30] = PINGROUP(30, qup0_se3, phase_flag26, _, qdss_gpio9, _, _, _, _, _),
> +	[31] = PINGROUP(31, qup0_se3, phase_flag25, _, qdss_gpio8, _, _, _, _, _),
> +	[32] = PINGROUP(32, qup0_se4, phase_flag24, _, _, _, _, _, _, _),
> +	[33] = PINGROUP(33, qup0_se4, gcc_gp4, _, ddr_pxi0, _, _, _, _,	_),
> +	[34] = PINGROUP(34, qup0_se4, gcc_gp5, _, ddr_pxi0, _, _, _, _,	_),
> +	[35] = PINGROUP(35, qup0_se4, phase_flag23, _, _, _, _, _, _, _),
> +	[36] = PINGROUP(36, qup0_se2, qup0_se5, phase_flag22, tgu_ch2, _, _, _, _, _),
> +	[37] = PINGROUP(37, qup0_se2, qup0_se5, phase_flag21, tgu_ch3, _, _, _, _, _),
> +	[38] = PINGROUP(38, qup0_se5, qup0_se2, qdss_cti, phase_flag20, tgu_ch4, _, _, _, _),
> +	[39] = PINGROUP(39, qup0_se5, qup0_se2, qdss_cti, phase_flag19, tgu_ch5, _, _, _, _),
> +	[40] = PINGROUP(40, qup1_se0, qup1_se1, ibi_i3c, mdp1_vsync0, _, _, _, _, _),
> +	[41] = PINGROUP(41, qup1_se0, qup1_se1, ibi_i3c, mdp1_vsync1, _, _, _, _, _),
> +	[42] = PINGROUP(42, qup1_se1, qup1_se0, ibi_i3c, mdp1_vsync2, gcc_gp5, _, _, _, _),
> +	[43] = PINGROUP(43, qup1_se1, qup1_se0, ibi_i3c, mdp1_vsync3, _, _, _, _, _),
> +	[44] = PINGROUP(44, qup1_se2, qup1_se3, edp0_lcd, _, _, _, _, _, _),
> +	[45] = PINGROUP(45, qup1_se2, qup1_se3, edp1_lcd, _, _, _, _, _, _),
> +	[46] = PINGROUP(46, qup1_se3, qup1_se2, mdp1_vsync4, tgu_ch0, _, _, _, _, _),
> +	[47] = PINGROUP(47, qup1_se3, qup1_se2, mdp1_vsync5, tgu_ch1, _, _, _, _, _),
> +	[48] = PINGROUP(48, qup1_se4, qdss_cti, edp2_lcd, _, _, _, _, _, _),
> +	[49] = PINGROUP(49, qup1_se4, qdss_cti, edp3_lcd, _, _, _, _, _, _),
> +	[50] = PINGROUP(50, qup1_se4, cci_async, qdss_cti, mdp1_vsync8, _, _, _, _, _),
> +	[51] = PINGROUP(51, qup1_se4, qdss_cti, mdp1_vsync6, gcc_gp1, _, _, _, _, _),
> +	[52] = PINGROUP(52, qup1_se5, cci_timer4, cci_i2c, mdp1_vsync7,	gcc_gp2, _, ddr_pxi1, _, _),
> +	[53] = PINGROUP(53, qup1_se5, cci_timer5, cci_i2c, gcc_gp3, _, ddr_pxi1, _, _, _),
> +	[54] = PINGROUP(54, qup1_se5, cci_timer6, cci_i2c, _, _, _, _, _, _),
> +	[55] = PINGROUP(55, qup1_se5, cci_timer7, cci_i2c, gcc_gp4, _, ddr_pxi2, _, _, _),
> +	[56] = PINGROUP(56, qup1_se6, qup1_se6, cci_timer8, cci_i2c, phase_flag18,
> +			ddr_bist, _, _, _),
> +	[57] = PINGROUP(57, qup1_se6, qup1_se6, cci_timer9, cci_i2c, mdp0_vsync0,
> +			phase_flag17, ddr_bist, _, _),
> +	[58] = PINGROUP(58, cci_i2c, mdp0_vsync1, ddr_bist, _, atest_usb2, atest_char1, _, _, _),
> +	[59] = PINGROUP(59, cci_i2c, mdp0_vsync2, ddr_bist, _, atest_usb2, atest_char0, _, _, _),
> +	[60] = PINGROUP(60, cci_i2c, qdss_gpio0, _, _, _, _, _, _, _),
> +	[61] = PINGROUP(61, cci_i2c, qdss_gpio1, _, _, _, _, _, _, _),
> +	[62] = PINGROUP(62, cci_i2c, qdss_gpio2, _, _, _, _, _, _, _),
> +	[63] = PINGROUP(63, cci_i2c, qdss_gpio3, _, _, _, _, _, _, _),
> +	[64] = PINGROUP(64, cci_i2c, qdss_gpio4, _, _, _, _, _, _, _),
> +	[65] = PINGROUP(65, cci_i2c, qdss_gpio5, _, _, _, _, _, _, _),
> +	[66] = PINGROUP(66, cci_i2c, cci_async, qdss_gpio6, _, _, _, _, _, _),
> +	[67] = PINGROUP(67, cci_i2c, qdss_gpio7, _, _, _, _, _, _, _),
> +	[68] = PINGROUP(68, cci_timer0, cci_async, _, _, _, _, _, _, _),
> +	[69] = PINGROUP(69, cci_timer1, cci_async, _, _, _, _, _, _, _),
> +	[70] = PINGROUP(70, cci_timer2, cci_async, _, _, _, _, _, _, _),
> +	[71] = PINGROUP(71, cci_timer3, cci_async, _, _, _, _, _, _, _),
> +	[72] = PINGROUP(72, cam_mclk, _, _, _, _, _, _, _, _),
> +	[73] = PINGROUP(73, cam_mclk, _, _, _, _, _, _, _, _),
> +	[74] = PINGROUP(74, cam_mclk, _, _, _, _, _, _, _, _),
> +	[75] = PINGROUP(75, cam_mclk, _, _, _, _, _, _, _, _),
> +	[76] = PINGROUP(76, _, _, _, _, _, _, _, _, _),
> +	[77] = PINGROUP(77, _, _, _, _, _, _, _, _, _),
> +	[78] = PINGROUP(78, _, _, _, _, _, _, _, _, _),
> +	[79] = PINGROUP(79, _, _, _, _, _, _, _, _, _),
> +	[80] = PINGROUP(80, qup2_se0, ibi_i3c, mdp0_vsync3, _, _, _, _, _, _),
> +	[81] = PINGROUP(81, qup2_se0, ibi_i3c, mdp0_vsync4, _, _, _, _, _, _),
> +	[82] = PINGROUP(82, qup2_se0, mdp_vsync, gcc_gp1, _, _, _, _, _, _),
> +	[83] = PINGROUP(83, qup2_se0, mdp_vsync, gcc_gp2, _, _, _, _, _, _),
> +	[84] = PINGROUP(84, qup2_se1, qup2_se5, ibi_i3c, mdp_vsync, gcc_gp3, _, _, _, _),
> +	[85] = PINGROUP(85, qup2_se1, qup2_se5, ibi_i3c, _, _, _, _, _, _),
> +	[86] = PINGROUP(86, qup2_se2, jitter_bist, atest_usb2, ddr_pxi2, _, _, _, _, _),
> +	[87] = PINGROUP(87, qup2_se2, pll_clk, atest_usb20, ddr_pxi3, _, _, _, _, _),
> +	[88] = PINGROUP(88, qup2_se2, _, atest_usb21, ddr_pxi3, _, _, _, _, _),
> +	[89] = PINGROUP(89, qup2_se2, _, atest_usb22, ddr_pxi4, atest_char3, _, _, _, _),
> +	[90] = PINGROUP(90, qup2_se2, _, atest_usb23, ddr_pxi4, atest_char2, _, _, _, _),
> +	[91] = PINGROUP(91, qup2_se3, mdp0_vsync5, _, atest_usb20, _, _, _, _, _),
> +	[92] = PINGROUP(92, qup2_se3, mdp0_vsync6, _, atest_usb21, _, _, _, _, _),
> +	[93] = PINGROUP(93, qup2_se3, mdp0_vsync7, _, atest_usb22, _, _, _, _, _),
> +	[94] = PINGROUP(94, qup2_se3, mdp0_vsync8, _, atest_usb23, _, _, _, _, _),
> +	[95] = PINGROUP(95, qup2_se4, qup2_se6, _, atest_usb20, _, _, _, _, _),
> +	[96] = PINGROUP(96, qup2_se4, qup2_se6, _, atest_usb21, _, _, _, _, _),
> +	[97] = PINGROUP(97, qup2_se6, qup2_se4, cri_trng0, _, atest_usb22, _, _, _, _),
> +	[98] = PINGROUP(98, qup2_se6, qup2_se4, phase_flag16, cri_trng1, _, _, _, _, _),
> +	[99] = PINGROUP(99, qup2_se5, qup2_se1, phase_flag15, cri_trng, _, _, _, _, _),
> +	[100] = PINGROUP(100, qup2_se5, qup2_se1, _, _, _, _, _, _, _),
> +	[101] = PINGROUP(101, edp0_hot, prng_rosc0, tsense_pwm4, _, _, _, _, _, _),
> +	[102] = PINGROUP(102, edp1_hot, prng_rosc1, tsense_pwm3, _, _, _, _, _, _),
> +	[103] = PINGROUP(103, edp3_hot, prng_rosc2, tsense_pwm2, _, _, _, _, _, _),
> +	[104] = PINGROUP(104, edp2_hot, prng_rosc3, tsense_pwm1, _, _, _, _, _, _),
> +	[105] = PINGROUP(105, mi2s_mclk0, _, qdss_gpio, atest_usb23, _, _, _, _, _),
> +	[106] = PINGROUP(106, mi2s1_sck, phase_flag14, _, qdss_gpio8, _, _, _, _, _),
> +	[107] = PINGROUP(107, mi2s1_ws, phase_flag13, _, qdss_gpio9, _, _, _, _, _),
> +	[108] = PINGROUP(108, mi2s1_data0, phase_flag12, _, qdss_gpio10, _, _, _, _, _),
> +	[109] = PINGROUP(109, mi2s1_data1, phase_flag11, _, qdss_gpio11, _, _, _, _, _),
> +	[110] = PINGROUP(110, mi2s2_sck, phase_flag10, _, qdss_gpio12, _, _, _, _, _),
> +	[111] = PINGROUP(111, mi2s2_ws, phase_flag9, _, qdss_gpio13, vsense_trigger, _, _, _, _),
> +	[112] = PINGROUP(112, mi2s2_data0, phase_flag8, _, qdss_gpio14, _, _, _, _, _),
> +	[113] = PINGROUP(113, mi2s2_data1, audio_ref, phase_flag7, _, qdss_gpio15, _, _, _, _),
> +	[114] = PINGROUP(114, hs0_mi2s, pll_bist, phase_flag6, _, qdss_gpio, _, _, _, _),
> +	[115] = PINGROUP(115, hs0_mi2s, _, qdss_gpio0, _, _, _, _, _, _),
> +	[116] = PINGROUP(116, hs0_mi2s, _, qdss_gpio1, _, _, _, _, _, _),
> +	[117] = PINGROUP(117, hs0_mi2s, mi2s_mclk1, _, qdss_gpio2, _, _, _, _, _),
> +	[118] = PINGROUP(118, hs1_mi2s, _, qdss_gpio3, ddr_pxi5, _, _, _, _, _),
> +	[119] = PINGROUP(119, hs1_mi2s, _, qdss_gpio4, ddr_pxi5, _, _, _, _, _),
> +	[120] = PINGROUP(120, hs1_mi2s, phase_flag5, _, qdss_gpio5, _, _, _, _, _),
> +	[121] = PINGROUP(121, hs1_mi2s, phase_flag4, _, qdss_gpio6, _, _, _, _, _),
> +	[122] = PINGROUP(122, hs2_mi2s, phase_flag3, _, qdss_gpio7, _, _, _, _, _),
> +	[123] = PINGROUP(123, hs2_mi2s, phase_flag2, _, _, _, _, _, _, _),
> +	[124] = PINGROUP(124, hs2_mi2s, phase_flag1, _, _, _, _, _, _, _),
> +	[125] = PINGROUP(125, hs2_mi2s, phase_flag0, _, _, _, _, _, _, _),
> +	[126] = PINGROUP(126, _, _, _, _, _, _, _, _, _),
> +	[127] = PINGROUP(127, _, _, _, _, _, _, _, _, _),
> +	[128] = PINGROUP(128, _, _, _, _, _, _, _, _, _),
> +	[129] = PINGROUP(129, _, _, _, _, _, _, _, _, _),
> +	[130] = PINGROUP(130, _, _, _, _, _, _, _, _, _),
> +	[131] = PINGROUP(131, _, _, _, _, _, _, _, _, _),
> +	[132] = PINGROUP(132, _, _, _, _, _, _, _, _, _),
> +	[133] = PINGROUP(133, _, _, _, _, _, _, _, _, _),
> +	[134] = PINGROUP(134, _, _, _, _, _, _, _, _, _),
> +	[135] = PINGROUP(135, _, _, _, _, _, _, _, _, _),
> +	[136] = PINGROUP(136, _, _, _, _, _, _, _, _, _),
> +	[137] = PINGROUP(137, _, _, _, _, _, _, _, _, _),
> +	[138] = PINGROUP(138, _, _, _, _, _, _, _, _, _),
> +	[139] = PINGROUP(139, _, _, _, _, _, _, _, _, _),
> +	[140] = PINGROUP(140, _, _, _, _, _, _, _, _, _),
> +	[141] = PINGROUP(141, _, _, _, _, _, _, _, _, _),
> +	[142] = PINGROUP(142, _, _, _, _, _, _, _, _, _),
> +	[143] = PINGROUP(143, _, _, _, _, _, _, _, _, _),
> +	[144] = PINGROUP(144, dbg_out, _, _, _, _, _, _, _, _),
> +	[145] = PINGROUP(145, _, _, _, _, _, _, _, _, _),
> +	[146] = PINGROUP(146, _, _, _, _, _, _, _, _, _),
> +	[147] = PINGROUP(147, _, _, _, _, _, _, _, _, _),
> +	[148] = PINGROUP(148, _, _, _, _, _, _, _, _, _),
> +	[149] = UFS_RESET(ufs_reset, 0x1a2000),
> +	[150] = SDC_QDSD_PINGROUP(sdc1_rclk, 0x199000, 15, 0),
> +	[151] = SDC_QDSD_PINGROUP(sdc1_clk, 0x199000, 13, 6),
> +	[152] = SDC_QDSD_PINGROUP(sdc1_cmd, 0x199000, 11, 3),
> +	[153] = SDC_QDSD_PINGROUP(sdc1_data, 0x199000, 9, 0),
> +};
> +
> +static const struct msm_pinctrl_soc_data sa8775p_pinctrl = {
> +	.pins = sa8775p_pins,
> +	.npins = ARRAY_SIZE(sa8775p_pins),
> +	.functions = sa8775p_functions,
> +	.nfunctions = ARRAY_SIZE(sa8775p_functions),
> +	.groups = sa8775p_groups,
> +	.ngroups = ARRAY_SIZE(sa8775p_groups),
> +	.ngpios = 150,
> +};
> +
> +static int sa8775p_pinctrl_probe(struct platform_device *pdev)
> +{
> +	return msm_pinctrl_probe(pdev, &sa8775p_pinctrl);
> +}
> +
> +static const struct of_device_id sa8775p_pinctrl_of_match[] = {
> +	{ .compatible = "qcom,sa8775p-pinctrl", },
> +	{ },
> +};
> +
> +static struct platform_driver sa8775p_pinctrl_driver = {
> +	.driver = {
> +		.name = "sa8775p-pinctrl",
> +		.of_match_table = sa8775p_pinctrl_of_match,
> +	},
> +	.probe = sa8775p_pinctrl_probe,
> +	.remove = msm_pinctrl_remove,
> +};
> +
> +static int __init sa8775p_pinctrl_init(void)
> +{
> +	return platform_driver_register(&sa8775p_pinctrl_driver);
> +}
> +arch_initcall(sa8775p_pinctrl_init);
> +
> +static void __exit sa8775p_pinctrl_exit(void)
> +{
> +	platform_driver_unregister(&sa8775p_pinctrl_driver);
> +}
> +module_exit(sa8775p_pinctrl_exit);
> +
> +MODULE_DESCRIPTION("QTI SA8775P pinctrl driver");
> +MODULE_LICENSE("GPL");
> +MODULE_DEVICE_TABLE(of, sa8775p_pinctrl_of_match);
