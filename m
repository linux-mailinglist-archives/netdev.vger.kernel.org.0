Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7040656A16
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 12:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiL0LzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 06:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiL0LzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 06:55:16 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5429FE2;
        Tue, 27 Dec 2022 03:55:12 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id m18so31409745eji.5;
        Tue, 27 Dec 2022 03:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X6iaCG2BPEAfstDTQK7Chp1YWfal4CgLw9FeJm6/8OA=;
        b=TMU3/v/jjzfRB7hJwXTKIAOGaY4rkzONqauW9KypWDdQUMtZBx7DJN0u9NQ33uG8KJ
         fGRYDuPiQAx1VEr7H9kGSIYXdS7aq20jmFb1eiywnPwgnUkf2DGdjf9yxqt9ita5kCIG
         cVFZu8tvi//MBIbjSFpZN5f8lRgy4NGeZPAArEKfNhEmzTHN/R0uizAU8wYQcTnFOUdv
         3zWL+ZJ5xsD3WJvF1bJeQK2Xgu3V+TAxgDOo/nOzkG29JkoddtqMq+OEaUjswlVa4M/H
         rSz2Oz+b1FkoucnkXzYXnKEiZGiRD3fh++LBYg+Wj+zIYqBmtvb2wpyRo6imz/212BgM
         xMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X6iaCG2BPEAfstDTQK7Chp1YWfal4CgLw9FeJm6/8OA=;
        b=cZLUzD1d3GVoSTIzsMBsk0Nq1B/AV2s1pW3PqkALN6ato4R+6FJAIzUpY+IEUgr2UH
         NTr/D/4wZR4iW0q9Rjj3PO2aS3UMc+5vNTMBdwMJAmr9OYwSUOO2VRNeHSoGB13h/sM3
         gDFtaDZqS53hJgWYL3etimb2jMIW75Ydqql5/7LDAPdmxJBfDUUI1GX/9euMSDD99v43
         lq6uz2ZKBY66MQd2mye7nycrRBwocs+jErqSQhuaRtdCuctDy7cPYQbrBu89yP71xti7
         j2oJlXOQ8oujbgdhuBTmGavRXbvN/P9F8h4gSEYwZXKqZhLdbmSVQRnFl0+rhFNHJQ9e
         9f/A==
X-Gm-Message-State: AFqh2koFRvt12vb5z+lwRVHqzeUwJHj7mC6alfqXanb1FIhY0Ggg71qu
        HIkCyQjZbXA2S1SqVwgwL05UL8sDvrs=
X-Google-Smtp-Source: AMrXdXvQX9JN/0hXoM+n1PXaAzQEZouI9zk+r04XcJ4eXmN/Wv9lEHTUnuTGIiOFDeR3lEkwrMjr1w==
X-Received: by 2002:a17:906:6b0f:b0:78d:f454:ba3d with SMTP id q15-20020a1709066b0f00b0078df454ba3dmr15991137ejr.60.1672142110714;
        Tue, 27 Dec 2022 03:55:10 -0800 (PST)
Received: from [192.168.2.1] (81-204-249-205.fixed.kpn.net. [81.204.249.205])
        by smtp.gmail.com with ESMTPSA id p12-20020a17090653cc00b007aece68483csm5890362ejo.193.2022.12.27.03.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 03:55:10 -0800 (PST)
Message-ID: <732352f3-fda0-039e-4fef-ceb6f5348086@gmail.com>
Date:   Tue, 27 Dec 2022 12:55:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCHv3 linux-next 3/4] ARM: dts: rockchip: rv1126: Add GMAC
 node
To:     Anand Moon <anand@edgeble.ai>, Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Jagan Teki <jagan@edgeble.ai>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20221227104837.27208-1-anand@edgeble.ai>
 <20221227104837.27208-3-anand@edgeble.ai>
Content-Language: en-US
From:   Johan Jonker <jbx6244@gmail.com>
In-Reply-To: <20221227104837.27208-3-anand@edgeble.ai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/27/22 11:48, Anand Moon wrote:
> Rockchip RV1126 has GMAC 10/100/1000M ethernet controller
> add GMAC node for RV1126 SoC.
> 
> Signed-off-by: Anand Moon <anand@edgeble.ai>
> Signed-off-by: Jagan Teki <jagan@edgeble.ai>
> ---
> v3: drop the gmac_clkin_m0 & gmac_clkin_m1 fix clock node which are not
> used, Add SoB of Jagan Teki.
> V2: drop SoB of Jagan Teki.
> ---
>  arch/arm/boot/dts/rv1126.dtsi | 49 +++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rv1126.dtsi b/arch/arm/boot/dts/rv1126.dtsi
> index 1cb43147e90b..e20fdd0d333c 100644
> --- a/arch/arm/boot/dts/rv1126.dtsi
> +++ b/arch/arm/boot/dts/rv1126.dtsi
> @@ -90,6 +90,55 @@ xin24m: oscillator {
>  		#clock-cells = <0>;
>  	};
>  

> +	gmac: ethernet@ffc40000 {

Nodes with a reg property are sort on reg address.
Heiko can fix that.. ;)

	timer0: timer@ff660000 {
	gmac: ethernet@ffc40000 {
	emmc: mmc@ffc50000 {

> +		compatible = "rockchip,rv1126-gmac", "snps,dwmac-4.20a";
> +		reg = <0xffc40000 0x4000>;
> +		interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
> +			     <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
> +		interrupt-names = "macirq", "eth_wake_irq";
> +		rockchip,grf = <&grf>;
> +		clocks = <&cru CLK_GMAC_SRC>, <&cru CLK_GMAC_TX_RX>,
> +			 <&cru CLK_GMAC_TX_RX>, <&cru CLK_GMAC_REF>,
> +			 <&cru ACLK_GMAC>, <&cru PCLK_GMAC>,
> +			 <&cru CLK_GMAC_TX_RX>, <&cru CLK_GMAC_PTPREF>;
> +		clock-names = "stmmaceth", "mac_clk_rx",
> +			      "mac_clk_tx", "clk_mac_ref",
> +			      "aclk_mac", "pclk_mac",
> +			      "clk_mac_speed", "ptp_ref";
> +		resets = <&cru SRST_GMAC_A>;
> +		reset-names = "stmmaceth";
> +
> +		snps,mixed-burst;
> +		snps,tso;
> +
> +		snps,axi-config = <&stmmac_axi_setup>;
> +		snps,mtl-rx-config = <&mtl_rx_setup>;
> +		snps,mtl-tx-config = <&mtl_tx_setup>;
> +		status = "disabled";
> +
> +		mdio: mdio {
> +			compatible = "snps,dwmac-mdio";
> +			#address-cells = <0x1>;
> +			#size-cells = <0x0>;
> +		};
> +
> +		stmmac_axi_setup: stmmac-axi-config {
> +			snps,wr_osr_lmt = <4>;
> +			snps,rd_osr_lmt = <8>;
> +			snps,blen = <0 0 0 0 16 8 4>;
> +		};
> +
> +		mtl_rx_setup: rx-queues-config {
> +			snps,rx-queues-to-use = <1>;
> +			queue0 {};
> +		};
> +
> +		mtl_tx_setup: tx-queues-config {
> +			snps,tx-queues-to-use = <1>;
> +			queue0 {};
> +		};
> +	};
> +
>  	grf: syscon@fe000000 {
>  		compatible = "rockchip,rv1126-grf", "syscon", "simple-mfd";
>  		reg = <0xfe000000 0x20000>;
