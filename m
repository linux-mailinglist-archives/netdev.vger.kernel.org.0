Return-Path: <netdev+bounces-4110-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B099370AE72
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 17:11:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16C40280EDE
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 15:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36AD046B4;
	Sun, 21 May 2023 15:10:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CA046AC
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 15:10:44 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC14E1;
	Sun, 21 May 2023 08:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684681842; x=1716217842;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MQFK43OnzuPwcmRa8kbMKCTdWnWcoVZv3AtoiXcB18k=;
  b=Kpq/mWQPkE7jbRka7CBEdC0psx4wVDwrOxrUzQbuanlHm6DnIcrB8Ndz
   RFLM4MON0qlkSejdb4HWr3jF6xKs/2U2OqfjGm1787WUi91DWeIabdT7h
   8RsCaGJry4vwywfXSnNu2e03Uf5pvFTPR0C4Pt6FtdUGD8HqpmIxmSYum
   FvYBBedENofxldgAw3fZ5oiw3fO35TvI8zPwjy21CfsyITxbfoFD6owGB
   Eui4MOn7pM/830QHka8Ln8Z5FPtDCkU+ijSCUf6H+gt0pXskw7+Sui9Dx
   5fNwFoJxLZ2EiRfUFgk1U/Z2ClCUQunWZzKvNFoWMgTi7S0q8dpFqoONu
   w==;
X-IronPort-AV: E=Sophos;i="6.00,182,1681196400"; 
   d="scan'208";a="214216229"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 May 2023 08:10:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 21 May 2023 08:10:41 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Sun, 21 May 2023 08:10:40 -0700
Date: Sun, 21 May 2023 17:10:40 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>
CC: <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
	<richardcochran@gmail.com>, <nicolas.ferre@microchip.com>,
	<claudiu.beznea@microchip.com>
Subject: Re: [PATCH] ARM: dts: lan966x: Add support for SMA connectors
Message-ID: <20230521151040.nvurjgukigiqohhx@soft-dev3-1>
References: <20230421113758.3465678-1-horatiu.vultur@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230421113758.3465678-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 04/21/2023 13:37, Horatiu Vultur wrote:

Hi,

> The pcb8309 has 2 SMA connectors which are connected to the lan966x
> chip. The lan966x can generate 1PPS output on one of them and it can
> receive 1PPS input on the other one.

Just a gentle ping. Thanks.

> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  arch/arm/boot/dts/lan966x-pcb8309.dts | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/lan966x-pcb8309.dts b/arch/arm/boot/dts/lan966x-pcb8309.dts
> index c436cd20d4b4c..0cb505f79ba1a 100644
> --- a/arch/arm/boot/dts/lan966x-pcb8309.dts
> +++ b/arch/arm/boot/dts/lan966x-pcb8309.dts
> @@ -144,6 +144,18 @@ fc4_b_pins: fc4-b-pins {
>  		function = "fc4_b";
>  	};
>  
> +	pps_out_pins: pps-out-pins {
> +		/* 1pps output */
> +		pins = "GPIO_38";
> +		function = "ptpsync_3";
> +	};
> +
> +	ptp_ext_pins: ptp-ext-pins {
> +		/* 1pps input */
> +		pins = "GPIO_39";
> +		function = "ptpsync_4";
> +	};
> +
>  	sgpio_a_pins: sgpio-a-pins {
>  		/* SCK, D0, D1, LD */
>  		pins = "GPIO_32", "GPIO_33", "GPIO_34", "GPIO_35";
> @@ -212,5 +224,7 @@ gpio@1 {
>  };
>  
>  &switch {
> +	pinctrl-0 = <&pps_out_pins>, <&ptp_ext_pins>;
> +	pinctrl-names = "default";
>  	status = "okay";
>  };
> -- 
> 2.38.0
> 

-- 
/Horatiu

