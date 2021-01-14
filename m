Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80222F6E76
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 23:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730830AbhANWoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 17:44:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41586 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730812AbhANWox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 17:44:53 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l0BLZ-000eCw-4o; Thu, 14 Jan 2021 23:44:05 +0100
Date:   Thu, 14 Jan 2021 23:44:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v5 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <YADJNRo+IWczUhzl@lunn.ch>
References: <20210114195734.55313-1-george.mccollister@gmail.com>
 <20210114195734.55313-3-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114195734.55313-3-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 01:57:33PM -0600, George McCollister wrote:
> Add a driver with initial support for the Arrow SpeedChips XRS7000
> series of gigabit Ethernet switch chips which are typically used in
> critical networking applications.
> 
> The switches have up to three RGMII ports and one RMII port.
> Management to the switches can be performed over i2c or mdio.
> 
> Support for advanced features such as PTP and
> HSR/PRP (IEC 62439-3 Clause 5 & 4) is not included in this patch and
> may be added at a later date.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
