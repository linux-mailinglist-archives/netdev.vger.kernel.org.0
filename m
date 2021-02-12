Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4EF31A225
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhBLPzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:55:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37230 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231422AbhBLPzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 10:55:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lAamK-005rA6-TH; Fri, 12 Feb 2021 16:54:44 +0100
Date:   Fri, 12 Feb 2021 16:54:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH net v1 1/3] net: phy: mscc: adding LCPLL reset to VSC8514
Message-ID: <YCakxN3iYvsW8afy@lunn.ch>
References: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 03:06:41PM +0100, Bjarni Jonasson wrote:
> At Power-On Reset, transients may cause the LCPLL to lock onto a
> clock that is momentarily unstable. This is normally seen in QSGMII
> setups where the higher speed 6G SerDes is being used.
> This patch adds an initial LCPLL Reset to the PHY (first instance)
> to avoid this issue.

Hi Bjarni

https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

These patches are rather large for stable, and not obviously correct.

There these problems hitting real users running stable kernels? Or is
it so broken it never really worked?

   Andrew
