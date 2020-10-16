Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0CF290B22
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 20:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391238AbgJPSJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 14:09:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60166 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391056AbgJPSJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 14:09:40 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTUAZ-0021xY-W8; Fri, 16 Oct 2020 20:09:35 +0200
Date:   Fri, 16 Oct 2020 20:09:35 +0200
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
Subject: Re: [PATCH v2] net: phy: Prevent reporting advertised modes when
 autoneg is off
Message-ID: <20201016180935.GG139700@lunn.ch>
References: <CGME20201015084513eucas1p234e2fa7a42b973ee7feafbdac6267a84@eucas1p2.samsung.com>
 <20201015084435.24368-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201015084435.24368-1-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 10:44:35AM +0200, Łukasz Stelmach wrote:
> Do not report advertised link modes (local and remote) when
> autonegotiation is turned off. mii_ethtool_get_link_ksettings() exhibits
> the same behaviour and this patch aims at unifying the behavior of both
> functions.

Does ethtool allow you to configure advertised modes with autoneg off?
If it can, it would be useful to see what is being configured, before
it is actually turned on.

ethtool -s eth42 autoneg off advertise 0xf

does not give an error on an interface i have.

     Andrew
