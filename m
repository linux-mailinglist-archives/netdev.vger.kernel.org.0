Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1697F2F801E
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 16:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732973AbhAOPyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 10:54:22 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:36356 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732707AbhAOPyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 10:54:21 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 10FFqa9v115961;
        Fri, 15 Jan 2021 09:52:36 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1610725956;
        bh=5rybIAVwOkDRzlPOdQwYK8uXyvhz+ZQoD/ZgVc8vJIg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=seGRolhIKjpD1r2FjnqJY+HCqeg1HYHGUKQv0u6lnPfXk04W1aopB6PeCaGh6H+CZ
         AUGdkOQxSJL+/x6s2gamsY+B4O4WtEik+iptiXMOBd9ny5+pesoN6jWkFFxuABMGoj
         G6YlNVJIh8ieb7BMoLDYWlKNVAu64CqSjZTK8dvY=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 10FFqaLg074614
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 Jan 2021 09:52:36 -0600
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 15
 Jan 2021 09:52:36 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 15 Jan 2021 09:52:36 -0600
Received: from [10.250.235.36] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 10FFqW1P023732;
        Fri, 15 Jan 2021 09:52:33 -0600
Subject: Re: [PATCH v12 2/4] phy: Add ethernet serdes configuration option
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
References: <20210107091924.1569575-1-steen.hegelund@microchip.com>
 <20210107091924.1569575-3-steen.hegelund@microchip.com>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <92a943cc-b332-4ac6-42a8-bb3cdae13bc0@ti.com>
Date:   Fri, 15 Jan 2021 21:22:31 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210107091924.1569575-3-steen.hegelund@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 07/01/21 2:49 pm, Steen Hegelund wrote:
> Provide a new ethernet phy configuration structure, that
> allow PHYs used for ethernet to be configured with
> speed, media type and clock information.
> 
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/linux/phy/phy-ethernet-serdes.h | 30 +++++++++++++++++++++++++
>  include/linux/phy/phy.h                 |  4 ++++
>  2 files changed, 34 insertions(+)
>  create mode 100644 include/linux/phy/phy-ethernet-serdes.h
> 
> diff --git a/include/linux/phy/phy-ethernet-serdes.h b/include/linux/phy/phy-ethernet-serdes.h
> new file mode 100644
> index 000000000000..d2462fadf179
> --- /dev/null
> +++ b/include/linux/phy/phy-ethernet-serdes.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
> +/*
> + * Microchip Sparx5 Ethernet SerDes driver
> + *
> + * Copyright (c) 2020 Microschip Inc
> + */
> +#ifndef __PHY_ETHERNET_SERDES_H_
> +#define __PHY_ETHERNET_SERDES_H_
> +
> +#include <linux/types.h>
> +
> +enum ethernet_media_type {
> +	ETH_MEDIA_DEFAULT,
> +	ETH_MEDIA_SR,
> +	ETH_MEDIA_DAC,
> +};

I'm not familiar with Ethernet. Are these generic media types? what does
SR or DAC refer to? Are there other media types? What is the out-of-band
mechanism by which the controller gets the media type? Why was this not
required for other existing Ethernet SERDES? Are you aware of any other
vendors who might require this?

Thanks
Kishon
> +
> +/**
> + * struct phy_configure_opts_eth_serdes - Ethernet SerDes This structure is used
> + * to represent the configuration state of a Ethernet Serdes PHY.
> + * @speed: Speed of the serdes interface in Mbps
> + * @media_type: Specifies which media the serdes will be using
> + */
> +struct phy_configure_opts_eth_serdes {
> +	u32                        speed;
> +	enum ethernet_media_type   media_type;
> +};
> +
> +#endif
> +
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> index e435bdb0bab3..78ecb375cede 100644
> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -18,6 +18,7 @@
>  
>  #include <linux/phy/phy-dp.h>
>  #include <linux/phy/phy-mipi-dphy.h>
> +#include <linux/phy/phy-ethernet-serdes.h>
>  
>  struct phy;
>  
> @@ -49,11 +50,14 @@ enum phy_mode {
>   *
>   * @mipi_dphy:	Configuration set applicable for phys supporting
>   *		the MIPI_DPHY phy mode.
> + * @eth_serdes: Configuration set applicable for phys supporting
> + *		the ethernet serdes.
>   * @dp:		Configuration set applicable for phys supporting
>   *		the DisplayPort protocol.
>   */
>  union phy_configure_opts {
>  	struct phy_configure_opts_mipi_dphy	mipi_dphy;
> +	struct phy_configure_opts_eth_serdes	eth_serdes;
>  	struct phy_configure_opts_dp		dp;
>  };
>  
> 
