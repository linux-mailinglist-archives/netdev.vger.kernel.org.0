Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084CF6903FE
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjBIJkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBIJkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:40:06 -0500
Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E843E171A;
        Thu,  9 Feb 2023 01:40:04 -0800 (PST)
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3199HVrD002242;
        Thu, 9 Feb 2023 10:38:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=Ol2FAil1EFrxD0YCoc4RaKOOMiU4+0QQ6K3rmBBavMY=;
 b=zS8kOrt2KVewz+s3mnOTmo7LU9Cc3ORYz7IBRYT5OTjObo1pyepsY+qE5HXkKKN66gpG
 zziMaf9H7EmROzlrcyjB0I/xViLvFeWfY0cF8425FsZYoM9nFJAJX2fEaDPmtS/Gyvvt
 ygEnpE96nP1nW3A6JaIGJmXFtnNXCmlCuPgLFYG+AYuMX+O4UU0oi0e8PfMtjQHqLffQ
 0NFpsXsAIv4nFggJogS6uMTO44x4AaNU8fit5z0y6zKZavsSTVjeqSaHilzCnUWgR/Df
 V3NqFFGOR/JrE9YP4YSbYw41TTjdH+tR6aDFUumn17mklQS7fkLD1sxaTZSpAwowrWL+ dw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3nhdcg18v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:38:23 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 1C17210002A;
        Thu,  9 Feb 2023 10:38:19 +0100 (CET)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id EF17D210F8F;
        Thu,  9 Feb 2023 10:38:18 +0100 (CET)
Received: from [10.201.21.26] (10.201.21.26) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Thu, 9 Feb
 2023 10:38:16 +0100
Message-ID: <c1d361d1-1599-230c-3609-88cd9f455114@foss.st.com>
Date:   Thu, 9 Feb 2023 10:38:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 02/11] ARM: sti: removal of stih415/stih416 related
 entries
Content-Language: en-US
To:     Alain Volmat <avolmat@me.com>, Jonathan Corbet <corbet@lwn.net>,
        "Rob Herring" <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        "Zhang Rui" <rui.zhang@intel.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-pm@vger.kernel.org>, <linux-clk@vger.kernel.org>
References: <20230209091659.1409-1-avolmat@me.com>
 <20230209091659.1409-3-avolmat@me.com>
From:   Patrice CHOTARD <patrice.chotard@foss.st.com>
In-Reply-To: <20230209091659.1409-3-avolmat@me.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.21.26]
X-ClientProxiedBy: SHFCAS1NODE1.st.com (10.75.129.72) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/9/23 10:16, Alain Volmat wrote:
> ST's STiH415 and STiH416 platforms have already been removed since
> a while.  Remove some remaining bits within the mach-sti.
> 
> Signed-off-by: Alain Volmat <avolmat@me.com>
> ---
>  arch/arm/mach-sti/Kconfig    | 20 +-------------------
>  arch/arm/mach-sti/board-dt.c |  2 --
>  2 files changed, 1 insertion(+), 21 deletions(-)
> 
> diff --git a/arch/arm/mach-sti/Kconfig b/arch/arm/mach-sti/Kconfig
> index b2d45cf10a3c..609957dead98 100644
> --- a/arch/arm/mach-sti/Kconfig
> +++ b/arch/arm/mach-sti/Kconfig
> @@ -19,31 +19,13 @@ menuconfig ARCH_STI
>  	select PL310_ERRATA_769419 if CACHE_L2X0
>  	select RESET_CONTROLLER
>  	help
> -	  Include support for STMicroelectronics' STiH415/416, STiH407/10 and
> +	  Include support for STMicroelectronics' STiH407/10 and
>  	  STiH418 family SoCs using the Device Tree for discovery.  More
>  	  information can be found in Documentation/arm/sti/ and
>  	  Documentation/devicetree.
>  
>  if ARCH_STI
>  
> -config SOC_STIH415
> -	bool "STiH415 STMicroelectronics Consumer Electronics family"
> -	default y
> -	help
> -	  This enables support for STMicroelectronics Digital Consumer
> -	  Electronics family StiH415 parts, primarily targeted at set-top-box
> -	  and other digital audio/video applications using Flattned Device
> -	  Trees.
> -
> -config SOC_STIH416
> -	bool "STiH416 STMicroelectronics Consumer Electronics family"
> -	default y
> -	help
> -	  This enables support for STMicroelectronics Digital Consumer
> -	  Electronics family StiH416 parts, primarily targeted at set-top-box
> -	  and other digital audio/video applications using Flattened Device
> -	  Trees.
> -
>  config SOC_STIH407
>  	bool "STiH407 STMicroelectronics Consumer Electronics family"
>  	default y
> diff --git a/arch/arm/mach-sti/board-dt.c b/arch/arm/mach-sti/board-dt.c
> index ffecbf29646f..8c313f07bd02 100644
> --- a/arch/arm/mach-sti/board-dt.c
> +++ b/arch/arm/mach-sti/board-dt.c
> @@ -12,8 +12,6 @@
>  #include "smp.h"
>  
>  static const char *const stih41x_dt_match[] __initconst = {
> -	"st,stih415",
> -	"st,stih416",
>  	"st,stih407",
>  	"st,stih410",
>  	"st,stih418",

Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>

Thanks
Patrice
