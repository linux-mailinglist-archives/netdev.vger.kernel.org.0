Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C458E114F9F
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 12:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfLFLJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 06:09:24 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:33142 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbfLFLJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 06:09:24 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB6B7KYf043909;
        Fri, 6 Dec 2019 05:07:20 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575630440;
        bh=43MIP2YvtyQu/1M9KI8G6euH8OqvsdbRq2rXQEnRmok=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=knuVRvKuQDjE3s9nYvvgOMREZYWNbUjRSPfExtHOZpisBBmwmOOjcszBBjQha9AYG
         FTTUIdRMF62rKvJrz3+v75vQq4Guic5BUFeAr8NKaZ7xAI0svA86A0RZIFwfiDaVKz
         7oLuXgy1uPsbhweAGJfuz6VO2arceAbez1W0T5gc=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xB6B7KKp094692
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 6 Dec 2019 05:07:20 -0600
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 6 Dec
 2019 05:07:20 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 6 Dec 2019 05:07:20 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB6B7HjZ112203;
        Fri, 6 Dec 2019 05:07:18 -0600
Subject: Re: [PATCH 2/2] arm: omap2plus_defconfig: enable NET_SWITCHDEV
To:     Tony Lindgren <tony@atomide.com>
CC:     Randy Dunlap <rdunlap@infradead.org>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
References: <20191204174533.32207-1-grygorii.strashko@ti.com>
 <20191204174533.32207-3-grygorii.strashko@ti.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <c8058866-2be9-831c-19f6-31d17decb6f1@ti.com>
Date:   Fri, 6 Dec 2019 13:07:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191204174533.32207-3-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tony,

On 04/12/2019 19:45, Grygorii Strashko wrote:
> The TI_CPSW_SWITCHDEV definition in Kconfig was changed from "select
> NET_SWITCHDEV" to "depends on NET_SWITCHDEV", and therefore it is required
> to explicitelly enable NET_SWITCHDEV config option in omap2plus_defconfig.
> 
> Fixes: 3727d259ddaf ("arm: omap2plus_defconfig: enable new cpsw switchdev driver")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>   arch/arm/configs/omap2plus_defconfig | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
> index 89cce8d4bc6b..7bbef86a4e76 100644
> --- a/arch/arm/configs/omap2plus_defconfig
> +++ b/arch/arm/configs/omap2plus_defconfig
> @@ -92,6 +92,7 @@ CONFIG_IP_PNP_BOOTP=y
>   CONFIG_IP_PNP_RARP=y
>   CONFIG_NETFILTER=y
>   CONFIG_PHONET=m
> +CONFIG_NET_SWITCHDEV=y
>   CONFIG_CAN=m
>   CONFIG_CAN_C_CAN=m
>   CONFIG_CAN_C_CAN_PLATFORM=m
> @@ -182,6 +183,7 @@ CONFIG_SMSC911X=y
>   # CONFIG_NET_VENDOR_STMICRO is not set
>   CONFIG_TI_DAVINCI_EMAC=y
>   CONFIG_TI_CPSW=y
> +CONFIG_TI_CPSW_SWITCHDEV=y
>   CONFIG_TI_CPTS=y
>   # CONFIG_NET_VENDOR_VIA is not set
>   # CONFIG_NET_VENDOR_WIZNET is not set
> @@ -554,4 +556,3 @@ CONFIG_DEBUG_INFO_DWARF4=y
>   CONFIG_MAGIC_SYSRQ=y
>   CONFIG_SCHEDSTATS=y
>   # CONFIG_DEBUG_BUGVERBOSE is not set
> -CONFIG_TI_CPSW_SWITCHDEV=y
> 

Could it be applied as fix, as without it cpsw switch driver will not be built,
so no networking on am571x-idk

-- 
Best regards,
grygorii
