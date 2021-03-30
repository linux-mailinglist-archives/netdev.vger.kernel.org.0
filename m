Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F9D34EA6E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhC3Oal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:30:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54922 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231627AbhC3Oac (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 10:30:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lRFNw-00E25C-WF; Tue, 30 Mar 2021 16:30:25 +0200
Date:   Tue, 30 Mar 2021 16:30:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v2 0/7] remove different PHY fixups
Message-ID: <YGM2AGfawEFTKOtE@lunn.ch>
References: <20210309112615.625-1-o.rempel@pengutronix.de>
 <CAOMZO5CYquzd4BBZBUM6ufWkPqfidctruWmaDROwHKVmi3NX2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5CYquzd4BBZBUM6ufWkPqfidctruWmaDROwHKVmi3NX2A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 11:00:52AM -0300, Fabio Estevam wrote:
> Hi Oleksij,
> 
> On Tue, Mar 9, 2021 at 8:26 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> >
> > changes v2:
> > - rebase against latest kernel
> > - fix networking on RIoTBoard
> >
> > This patch series tries to remove most of the imx6 and imx7 board
> > specific PHY configuration via fixup, as this breaks the PHYs when
> > connected to switch chips or USB Ethernet MACs.
> >
> > Each patch has the possibility to break boards, but contains a
> > recommendation to fix the problem in a more portable and future-proof
> > way.
> 
> I think this series moves us in the right direction, even with the
> possibility to break old dtb's.
> 
> Reviewed-by: Fabio Estevam <festevam@gmail.com>
> 
> Andrew, what do you think?

Hi Fabio

I think it should be merged, and we fixup anything which does break.
We are probably at the point where more is broken by not merging it
than merging it.

  Andrew
