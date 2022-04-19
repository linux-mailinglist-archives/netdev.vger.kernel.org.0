Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353D3506B2C
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351864AbiDSLpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351730AbiDSLoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:44:54 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3F8286FB
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 04:41:58 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t25so20880493edt.9
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 04:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mz6256umYnJ6/XrXcKE+m1J6RVixvH/4RBMuyWcIJUE=;
        b=S4doEUnE6q0/vBhSuORLNPtL6SAOla7FEKdUb58Go419RsC6UGSn1Wcou09FwfKh0Y
         oYWfyCNw4bvbVbeZ0ZKzisRW93fvEGhEGC4gPGR+aF2If70tJtGHCbYjrfHjqCGW0oN6
         OH6o/URIeAbM8oGu8s7svV/Yw3XPrYbRLFJweo+agMHGv9M5L8J/xPn/b22k3nX8aYVD
         ljPMs1epziRXlLpINToZNJW3L1i1VmczO+FSkYbaxEbNcjBuAkVTk6iAplDBLm8beRRB
         Rn/xkp7L7m8qi43snZ29g1VqcdQFO94E2WvNUpnCvWu0VBOciz/cQ9iqaDo/u6P+jigh
         vzuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mz6256umYnJ6/XrXcKE+m1J6RVixvH/4RBMuyWcIJUE=;
        b=WSstLBuw1NV2XqIA8HHDxqxtWyXDPmaEnBoSxDHMHfislELyZkMcgzNHb9XmPS4eM2
         Fijwf007Qg877reVPgouP7MHS2Sl7FrNAniI5yDLdlUbOKHiSYXZ6EOTGCbBPTO0vn+0
         OyNI0hXeNugr3m/SeHuNMLqLVEJPnxiqr6Ya1FpFnxFk7VsGJ2EF1N4RCdR1Ef2Yhuot
         9XymmeZgqLTfuxtGXbz+6Z8gp97VVqXMa38StknLr5tkl15gwS6IMxCH1gM0NpULAbRX
         Tutv/KgOjN4tHaxyxQ+b8/VlOAYoT0sozaj+XEXUcT73JlY2jxe+kca42RWtlr8xFiZV
         YZ1Q==
X-Gm-Message-State: AOAM531afbqGwXeQUHFu2W9IMMVluW0oQv9KfKBUWSrV6o05blM16gpp
        ZlFA0qGmctWviZV30qF10A5IsA==
X-Google-Smtp-Source: ABdhPJxCwl7ZZc/DFYxnfjnS+b9hh7Ohq0rQIW6yXiUph37f723DPEp580QZPIm1X5UkXrboZJBB9Q==
X-Received: by 2002:a50:8d8a:0:b0:423:d77b:a683 with SMTP id r10-20020a508d8a000000b00423d77ba683mr14081863edh.138.1650368517058;
        Tue, 19 Apr 2022 04:41:57 -0700 (PDT)
Received: from [192.168.0.217] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id fq2-20020a1709069d8200b006efdd9baaa7sm652738ejc.196.2022.04.19.04.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 04:41:56 -0700 (PDT)
Message-ID: <c644122d-25b1-918b-6c9f-ea331c4da3da@linaro.org>
Date:   Tue, 19 Apr 2022 13:41:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v8 01/13] arm64: dts: freescale: Add the top level dtsi
 support for imx8dxl
Content-Language: en-US
To:     Abel Vesa <abel.vesa@nxp.com>, Rob Herring <robh@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Jacky Bai <ping.bai@nxp.com>
References: <20220419113516.1827863-1-abel.vesa@nxp.com>
 <20220419113516.1827863-2-abel.vesa@nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220419113516.1827863-2-abel.vesa@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/2022 13:35, Abel Vesa wrote:
> From: Jacky Bai <ping.bai@nxp.com>
> 
> The i.MX8DXL is a device targeting the automotive and industrial
> market segments. The flexibility of the architecture allows for
> use in a wide variety of general embedded applications. The chip
> is designed to achieve both high performance and low power consumption.
> The chip relies on the power efficient dual (2x) Cortex-A35 cluster.
> 
> Add the reserved memory node property for dsp reserved memory,
> the wakeup-irq property for SCU node, the rpmsg and the cm4 rproc
> support.
> 
> Signed-off-by: Jacky Bai <ping.bai@nxp.com>
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>


(...)

> +	thermal_zones: thermal-zones {
> +		cpu-thermal0 {

Same concerns as you DTS.

> +			polling-delay-passive = <250>;
> +			polling-delay = <2000>;
> +			thermal-sensors = <&tsens IMX_SC_R_SYSTEM>;
> +
> +			trips {
> +				cpu_alert0: trip0 {
> +					temperature = <107000>;
> +					hysteresis = <2000>;
> +					type = "passive";
> +				};
> +
> +				cpu_crit0: trip1 {
> +					temperature = <127000>;
> +					hysteresis = <2000>;
> +					type = "critical";
> +				};
> +			};
> +
> +			cooling-maps {
> +				map0 {
> +					trip = <&cpu_alert0>;
> +					cooling-device =
> +					<&A35_0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
> +					<&A35_1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
> +				};
> +			};
> +		};
> +	};
> +
> +	clk_dummy: clock-dummy {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <0>;
> +		clock-output-names = "clk_dummy";
> +	};
> +
> +	xtal32k: clock-xtal32k {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <32768>;
> +		clock-output-names = "xtal_32KHz";
> +	};
> +
> +	xtal24m: clock-xtal24m {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <24000000>;
> +		clock-output-names = "xtal_24MHz";
> +	};
> +
> +	/* sorted in register address */
> +	#include "imx8-ss-adma.dtsi"
> +	#include "imx8-ss-conn.dtsi"
> +	#include "imx8-ss-ddr.dtsi"
> +	#include "imx8-ss-lsio.dtsi"
> +};
> +
> +#include "imx8dxl-ss-adma.dtsi"

There is no such file. Your changes are not bisectable.

> +#include "imx8dxl-ss-conn.dtsi"
> +#include "imx8dxl-ss-lsio.dtsi"
> +#include "imx8dxl-ss-ddr.dtsi"


Best regards,
Krzysztof
