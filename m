Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49D029C6AB
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 19:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1827165AbgJ0SVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 14:21:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48020 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1826979AbgJ0SVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 14:21:13 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXTah-003qah-MQ; Tue, 27 Oct 2020 19:21:03 +0100
Date:   Tue, 27 Oct 2020 19:21:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3 RESEND] net: mii: Report advertised link capabilities
 when autonegotiation is off
Message-ID: <20201027182103.GC904240@lunn.ch>
References: <CGME20201027114743eucas1p23c4a5e6762ce18509296cf23435e7268@eucas1p2.samsung.com>
 <20201027114317.8259-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201027114317.8259-1-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 12:43:17PM +0100, Łukasz Stelmach wrote:
> Unify the set of information returned by mii_ethtool_get_link_ksettings(),
> mii_ethtool_gset() and phy_ethtool_ksettings_get(). Make the mii_*()
> functions report advertised settings when autonegotiation if disabled.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
