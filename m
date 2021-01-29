Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F2030830C
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhA2BM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:12:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37456 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231256AbhA2BMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:12:51 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l5IKU-00376U-4t; Fri, 29 Jan 2021 02:12:06 +0100
Date:   Fri, 29 Jan 2021 02:12:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 4/8] net: dsa: microchip: add support for
 phylink management
Message-ID: <YBNg5iRtKp9Twqpe@lunn.ch>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
 <20210128064112.372883-5-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128064112.372883-5-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* For T1 PHY */
> +	if (lan937x_is_internal_t1_phy_port(dev, port)) {
> +		phylink_set(mask, 100baseT_Full);
> +		phylink_set_port_modes(mask);

Since this is a T1 PHY, you should be using 100baseT1_Full.

This might be the first user of this for phylink, so please test this
actually works.

	 Andrew
