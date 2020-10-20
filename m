Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB10A29323B
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389232AbgJTAMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:12:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35682 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgJTAMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 20:12:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUfGA-002Zn9-M2; Tue, 20 Oct 2020 02:12:14 +0200
Date:   Tue, 20 Oct 2020 02:12:14 +0200
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
Subject: Re: [PATCH v3] net: mii: Report advertised link capabilities when
 autonegotiation is off
Message-ID: <20201020001214.GS456889@lunn.ch>
References: <CGME20201019120419eucas1p26a296cc89b171e85642c6255872e23f0@eucas1p2.samsung.com>
 <20201019120415.1416-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201019120415.1416-1-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 02:04:15PM +0200, Łukasz Stelmach wrote:
> Unify the set of information returned by mii_ethtool_get_link_ksettings(),
> mii_ethtool_gset() and phy_ethtool_ksettings_get(). Make the mii_*()
> functions report advertised settings when autonegotiation if disabled.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>

Hi Łukasz

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

You should repost once net-next has reopened for commits in a weeks
time.

    Andrew
