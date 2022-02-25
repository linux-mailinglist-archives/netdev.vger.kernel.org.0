Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6B94C4E64
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 20:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiBYTMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 14:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234344AbiBYTMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 14:12:23 -0500
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48E420D537;
        Fri, 25 Feb 2022 11:11:50 -0800 (PST)
Received: by mail-oo1-f47.google.com with SMTP id x6-20020a4a4106000000b003193022319cso7626859ooa.4;
        Fri, 25 Feb 2022 11:11:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ptG46z6H5ifEKTx2dBnfEYgkcUc6HPFhRtrAbm9h2S0=;
        b=S8siLbfa+uUxbstKleeGY35T4+KCDWGjThdtV2DNSH16L3ct5xGs18RsoEecyu9dke
         3lTLGCE2Vyhy+kuS11S6uvkhzmW+yLzhQLiEPfSzwwMVLeHg8ZuZo6fcKu5bZUNFkfj4
         MQKP43FgWnEcr1FmfVolZyoICX3F4sCoFPEGmwPNiXln4Mm6XJ/zXEkycABMMuWL2AHR
         rQX6fseW+Y4kI9id/39CF4WkxpMUXIyyt92N8PYg6xO2WPrJGvbEl0+US7Rcx3LhibwR
         e1vo2nrXdbWSH1paDh3rCyEr8G+1aA3JF+oyAkUC/cZBa8UkI0ACh1NazyUAKIUncpFi
         wNdQ==
X-Gm-Message-State: AOAM533TTQrWrefv/kbsfLG5s5DCxWc7/9YPaEAA5J/DIjoE2bXSfH+F
        2a8j1sPzzxZuOaVVuqH/j67ZTBOTXg==
X-Google-Smtp-Source: ABdhPJzWcs65ePV5falZWYBKART4XIExLG7Jl4rNz0RlRKlhWRGox/P8effT9Lz52v++C+k7FNY9wQ==
X-Received: by 2002:a05:6870:70a8:b0:d3:e21:8545 with SMTP id v40-20020a05687070a800b000d30e218545mr2101513oae.321.1645816310209;
        Fri, 25 Feb 2022 11:11:50 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id u12-20020a056808114c00b002d72b6e5676sm1887530oiu.29.2022.02.25.11.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 11:11:49 -0800 (PST)
Received: (nullmailer pid 1267526 invoked by uid 1000);
        Fri, 25 Feb 2022 19:11:48 -0000
Date:   Fri, 25 Feb 2022 13:11:48 -0600
From:   Rob Herring <robh@kernel.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Robert Marko <robert.marko@sartura.hr>,
        Baruch Siach <baruch.siach@siklu.com>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/2] arm64: dts: qcom: ipq6018: Add mdio bus description
Message-ID: <Yhkp9CH0SpBKKlzZ@robh.at.kernel.org>
References: <a4b1ad7b15c13f368b637efdb903da143b830a88.1645454002.git.baruch@tkos.co.il>
 <5e7e06e0cb189bab4586646470894bbda572785d.1645454002.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e7e06e0cb189bab4586646470894bbda572785d.1645454002.git.baruch@tkos.co.il>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 04:33:22PM +0200, Baruch Siach wrote:
> From: Baruch Siach <baruch.siach@siklu.com>
> 
> The IPQ60xx has the same MDIO bug block as IPQ4019. Add IO range and
> clock resources description.
> 
> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
> ---
>  arch/arm64/boot/dts/qcom/ipq6018.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
> index 5eb7dc9cc231..093011d18ca6 100644
> --- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
> +++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
> @@ -635,6 +635,16 @@ qrtr_requests {
>  			};
>  		};
>  
> +		mdio: mdio@90000 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			compatible = "qcom,ipq6018-mdio", "qcom,ipq4019-mdio";

This looks correct with the fallback based on your description, but it
doesn't match the schema.

You tested this with the schemas, right? That's why we have them.

> +			reg = <0x0 0x90000 0x0 0x64>;
> +			clocks = <&gcc GCC_MDIO_AHB_CLK>;
> +			clock-names = "gcc_mdio_ahb_clk";
> +			status = "disabled";
> +		};
> +
>  		qusb_phy_1: qusb@59000 {
>  			compatible = "qcom,ipq6018-qusb2-phy";
>  			reg = <0x0 0x059000 0x0 0x180>;
> -- 
> 2.34.1
> 
> 
