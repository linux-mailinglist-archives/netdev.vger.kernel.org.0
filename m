Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E057F16ED40
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 18:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730857AbgBYR51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 12:57:27 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:57954 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgBYR51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 12:57:27 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01PHvO6g118931;
        Tue, 25 Feb 2020 11:57:24 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582653444;
        bh=hQ2uIHjwpTtJd56UjDVGgdNIbg9rWSbDzA/3T4wHuB8=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=iE2Ub7TW60Al9VxN8PEadGgbs5BBH9yGJa7MegH5Qx4FJn8tZ+fJ+KIhL50zhnSqp
         TVeEewZXmOJYdpnNqpQPU5dWX5HtjPpkHU92DLqdf/Bv4FEh73liimeyZS4WRU5Bk0
         SLRTI1dad94YiPWDWopxLLimPJzzIlPcfeRV3D+0=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01PHvOFv026587
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Feb 2020 11:57:24 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 25
 Feb 2020 11:57:23 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 25 Feb 2020 11:57:23 -0600
Received: from [158.218.117.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01PHvNdn070866;
        Tue, 25 Feb 2020 11:57:23 -0600
Subject: Re: [for-next PATCH 1/5] phy: ti: gmii-sel: simplify config
 dependencies between net drivers and gmii phy
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>
References: <20200222120358.10003-1-grygorii.strashko@ti.com>
 <20200222120358.10003-2-grygorii.strashko@ti.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <78f6521a-d44b-b0b9-8dcf-4b1dc1446946@ti.com>
Date:   Tue, 25 Feb 2020 13:04:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200222120358.10003-2-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Grygorii,

On 02/22/2020 07:03 AM, Grygorii Strashko wrote:
> The phy-gmii-sel can be only autoselacted in Kconfig and now the pretty
s/autoselacted/auto selected
> complex Kconfig dependencies are defined for phy-gmii-sel driver, which
> also need to be updated every time phy-gmii-sel is re-used for any new
> networking driver.
> 
> Simplify Kconfig definotion for phy-gmii-sel PHY driver - drop all

s/definotion/definition

> depndencies and from networking drivers and rely on using 'imply imply

s/depndencies/dependencies

> PHY_TI_GMII_SEL' in Kconfig definotions for networking drivers instead.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>   drivers/net/ethernet/ti/Kconfig | 1 +
>   drivers/phy/ti/Kconfig          | 3 ---
>   2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index bf98e0fa7d8b..8a6ca16eee3b 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -53,6 +53,7 @@ config TI_CPSW
>   	select MFD_SYSCON
>   	select PAGE_POOL
>   	select REGMAP
> +	imply PHY_TI_GMII_SEL
>   	---help---
>   	  This driver supports TI's CPSW Ethernet Switch.
>   
> diff --git a/drivers/phy/ti/Kconfig b/drivers/phy/ti/Kconfig
> index 6dbe9d0b9ff3..15a3bcf32308 100644
> --- a/drivers/phy/ti/Kconfig
> +++ b/drivers/phy/ti/Kconfig
> @@ -106,11 +106,8 @@ config TWL4030_USB
>   
>   config PHY_TI_GMII_SEL
>   	tristate
> -	default y if TI_CPSW=y || TI_CPSW_SWITCHDEV=y
> -	depends on TI_CPSW || TI_CPSW_SWITCHDEV || COMPILE_TEST
>   	select GENERIC_PHY
>   	select REGMAP
> -	default m
>   	help
>   	  This driver supports configuring of the TI CPSW Port mode depending on
>   	  the Ethernet PHY connected to the CPSW Port.
> 

-- 
Murali Karicheri
Texas Instruments
