Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F471F690D
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 15:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgFKN3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 09:29:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37268 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgFKN3S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 09:29:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jjNGX-000B7B-V9; Thu, 11 Jun 2020 15:29:09 +0200
Date:   Thu, 11 Jun 2020 15:29:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiko Stuebner <heiko@sntech.de>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Subject: Re: [PATCH v2 2/2] net: phy: mscc: handle the clkout control on some
 phy variants
Message-ID: <20200611132909.GD19869@lunn.ch>
References: <20200609133140.1421109-1-heiko@sntech.de>
 <20200609133140.1421109-2-heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609133140.1421109-2-heiko@sntech.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 03:31:40PM +0200, Heiko Stuebner wrote:
> From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> 
> At least VSC8530/8531/8540/8541 contain a clock output that can emit
> a predefined rate of 25, 50 or 125MHz.
> 
> This may then feed back into the network interface as source clock.
> So follow the example the at803x already set and introduce a
> vsc8531,clk-out-frequency property to set that output.
> 
> Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> ---
> Hi Andrew,
> 
> I didn't change the property yet, do you have a suggestion on
> how to name it though? Going by the other examples in the
> ethernet-phy.yamls, something like enet-phy-clock-out-frequency ?

Hi Heiko

Yes, that looks good.

Thanks
	Andrew
