Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D40C368975
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239773AbhDVXny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:43:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36782 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231605AbhDVXnx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 19:43:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZiyX-000Yrg-OJ; Fri, 23 Apr 2021 01:43:13 +0200
Date:   Fri, 23 Apr 2021 01:43:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/9] net: dsa: microchip: add DSA support for
 microchip lan937x
Message-ID: <YIIKEZ8VzMUv+/wW@lunn.ch>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
 <20210422094257.1641396-5-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422094257.1641396-5-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +int lan937x_reset_switch(struct ksz_device *dev)
> +{
> +	u32 data32;
> +	u8 data8;
> +	int rc;
> +
> +	/* reset switch */
> +	rc = lan937x_cfg(dev, REG_SW_OPERATION, SW_RESET, true);
> +	if (rc < 0)
> +		return rc;

Please consistently use ret everywhere, not rc.

       Andrew
