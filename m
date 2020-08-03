Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCAB23ABBE
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 19:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHCRin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 13:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCRim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 13:38:42 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FED3C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 10:38:42 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s15so8794262pgc.8
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 10:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YDxDfS5ZnDP/fSsHSnu3HFOQe81aZhcFJgQH5fQI7KE=;
        b=a99rN20tVAS41MYHgNEZOPP1kWpE2e3+3H+x3Ny3HMiPdFwv/tlfg4UtTPjEMP/FoU
         O+i/KfhFOzyWyCIRAjH9OhfF3FOiidExXJSh6v+dJ6y2IjhhBIch1bndLhHLDR4cOvRA
         u8x5hYwe7tbN/qaocqfoiMz+9LmaJC3dnd+ArNO2mblNoiL+/e4yfJW3hbe7yplYo5wJ
         885/Gr5PEfWHeKWKioI4hIJPeFdrYcQfQ98JB3Xa8VkZcN3XEdtXmQ6bV33TfNKSa9vj
         SzhzrwpMJR93QawojURW8GCC1UaC5cnjqHLLhoLnoYnScaVS3rhd7H2xIQYVOPIb1DD9
         OBqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YDxDfS5ZnDP/fSsHSnu3HFOQe81aZhcFJgQH5fQI7KE=;
        b=Mv2oVxGOWtmgiQOD5M/piGasO2h52KHI7vNDhJtfSJgK+TF5k6PCqSSOKlSFS8L8de
         GwcPCATqqbti5pNk9oVymTveMw+ceic+141uSrgJo2zjK5HQWszksCKtxSkpG0eDnZIG
         IUT1OeEZNF2k4CqMVGdyOnu42zPTZe7T91LyJ/Fi4vbByaD5T9Ur9DILwX5rAC9wKu+a
         /FziHAJ3ilc2ZjI4VVXEkSmCh69YY19XuC7FhS7k7bvGt8/o9F6W7tTCDq9Vc4Psy8RI
         e87WXnnqOI6Iqkjx/2qxAt7iwECnXGahlMsh/dP9wA/UR6OefzKhTOFFl/wBiUDoCycg
         ve+Q==
X-Gm-Message-State: AOAM533Lpl15lo5CyS44G0Oj7c7MP64GQp/wWPejI/KVjrixzohRyuej
        8z/ydbtmdZ8PingxrYlpiFnZDPE4
X-Google-Smtp-Source: ABdhPJwt08gXVshS/q+6GW6Ks1XjOs0EaZOdsw3vVfK7UTIa9yEFhe04eS/iOv8GqIfztZUjZKJDSA==
X-Received: by 2002:a63:8ec4:: with SMTP id k187mr15577539pge.425.1596476321810;
        Mon, 03 Aug 2020 10:38:41 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 124sm496592pfb.19.2020.08.03.10.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 10:38:41 -0700 (PDT)
Subject: Re: [PATCH v4 01/11] net: phy: Add support for microchip SMI0 MDIO
 bus
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel@pengutronix.de
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
 <20200803054442.20089-2-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <84eda532-c4d9-6847-876d-305a0f59b8dd@gmail.com>
Date:   Mon, 3 Aug 2020 10:38:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803054442.20089-2-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/2020 10:44 PM, Michael Grzeschik wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> SMI0 is a mangled version of MDIO. The main low level difference is
> the MDIO C22 OP code is always 0, not 0x2 or 0x1 for Read/Write. The
> read/write information is instead encoded in the PHY address.
> 
> Extend the bit-bang code to allow the op code to be overridden, but
> default to normal C22 values. Add an extra compatible to the mdio-gpio
> driver, and when this compatible is present, set the op codes to 0.
> 
> A higher level driver, sitting on top of the basic MDIO bus driver can
> then implement the rest of the microchip SMI0 odderties.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> ---

[snip]

> diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio-gpio.c
> index 1b00235d7dc5b56..e8d83cee1bc17e1 100644
> --- a/drivers/net/phy/mdio-gpio.c
> +++ b/drivers/net/phy/mdio-gpio.c
> @@ -132,6 +132,14 @@ static struct mii_bus *mdio_gpio_bus_init(struct device *dev,
>  		new_bus->phy_ignore_ta_mask = pdata->phy_ignore_ta_mask;
>  	}
>  
> +	if (dev->of_node &&
> +	    of_device_is_compatible(dev->of_node, "microchip,mdio-smi0")) {
> +		bitbang->ctrl.op_c22_read = 0;
> +		bitbang->ctrl.op_c22_write = 0;
> +	} else {
> +		bitbang->ctrl.override_op_c22 = 1;

Do not you have the logic reversed here? You meant to set
ctrl.override_op_c22 to 1 *if* your compatibility string is
microchip,mdio-smi0 to indicate the use of non-standard clause 22 read
and write opcodes?
-- 
Florian
