Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF181B1658
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgDTT5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:57:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51858 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgDTT5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 15:57:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IqE7/k/wP7v8PNyQusFkoxnSxLx5Dg8o8W6frjL5sIg=; b=PefrVbjhr8EMpaAV29ne7JrSyE
        3u8hMm61U8WuBm3Zf987w3XpNz/2KKuWNdPDYpjXScRipB7xmyVd3IW34wcwbN2za0j4ozhyP1oEE
        NqQc06L6KPfTqHkNQQo961vRYNWEJ5/hdNgsiuP+rW3WG16JBdGXtcOGz3WR9TFi1uJM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQcY1-003tPh-K7; Mon, 20 Apr 2020 21:57:41 +0200
Date:   Mon, 20 Apr 2020 21:57:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 2/3] net: phy: add Broadcom BCM54140 support
Message-ID: <20200420195741.GG917792@lunn.ch>
References: <20200420182113.22577-1-michael@walle.cc>
 <20200420182113.22577-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420182113.22577-2-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 08:21:12PM +0200, Michael Walle wrote:
> The Broadcom BCM54140 is a Quad SGMII/QSGMII Copper/Fiber Gigabit
> Ethernet transceiver.
> 
> This also adds support for tunables to set and get downshift and
> energy detect auto power-down.
> 
> The PHY has four ports and each port has its own PHY address.
> There are per-port registers as well as global registers.
> Unfortunately, the global registers can only be accessed by reading
> and writing from/to the PHY address of the first port. Further,
> there is no way to find out what port you actually are by just
> reading the per-port registers. We therefore, have to scan the
> bus on the PHY probe to determine the port and thus what address
> we need to access the global registers.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
