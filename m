Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADB12F251B
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732704AbhALAsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:48:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34566 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732594AbhALAsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 19:48:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kz7qJ-000385-LG; Tue, 12 Jan 2021 01:47:27 +0100
Date:   Tue, 12 Jan 2021 01:47:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     stefanc@marvell.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        mw@semihalf.com, rmk+kernel@armlinux.org.uk, atenart@kernel.org
Subject: Re: [PATCH net ] net: mvpp2: Remove Pause and Asym_Pause support
Message-ID: <X/zxnyyTRf0xsYmd@lunn.ch>
References: <1610306582-16641-1-git-send-email-stefanc@marvell.com>
 <20210111163653.6483ae82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111163653.6483ae82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 04:36:53PM -0800, Jakub Kicinski wrote:
> On Sun, 10 Jan 2021 21:23:02 +0200 stefanc@marvell.com wrote:
> > From: Stefan Chulski <stefanc@marvell.com>
> > 
> > Packet Processor hardware not connected to MAC flow control unit and
> > cannot support TX flow control.
> > This patch disable flow control support.
> > 
> > Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
> > Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> 
> I'm probably missing something, but why not 4bb043262878 ("net: mvpp2:
> phylink support")?

Hi Jakub

Before that change, it used phylib. The same is true with phylib, you
need to tell phylib it should not advertise pause. How you do it is
different, but the basic issue is the same. Anybody doing a backport
past 4bb043262878is going to need a different fix, but the basic issue
is there all the way back to when the driver was added.

      Andrew
