Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0097A2630C8
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 17:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730434AbgIIPnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 11:43:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52596 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730423AbgIIPnO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 11:43:14 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kG0Qo-00DvEn-Ru; Wed, 09 Sep 2020 15:46:38 +0200
Date:   Wed, 9 Sep 2020 15:46:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     David Miller <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Jisheng.Zhang@synaptics.com" <Jisheng.Zhang@synaptics.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v2] net: phy: call phy_disable_interrupts() in
 phy_attach_direct() instead
Message-ID: <20200909134638.GF3290129@lunn.ch>
References: <1599609338-17732-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <20200908.202524.1861811044367438406.davem@davemloft.net>
 <TY2PR01MB36921A4404E47B78C42CF2DED8260@TY2PR01MB3692.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TY2PR01MB36921A4404E47B78C42CF2DED8260@TY2PR01MB3692.jpnprd01.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 04:18:56AM +0000, Yoshihiro Shimoda wrote:
> Hi David,
> 
> > From: David Miller, Sent: Wednesday, September 9, 2020 12:25 PM
> > 
> > From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > Date: Wed,  9 Sep 2020 08:55:38 +0900
> > 
> > >  Changes from v1:
> > >  - Fix build error.
> > 
> > When such a fundamental build failure is fixed (it could never have
> > built for anyone, even you), I want it explained why this happened
> > and how this was functionally tested if it did not even compile.
> 
> I'm sorry about this. I used two PCs now:
>  PC 1 = for testing at local
>  PC 2 = for submitting patches at remote (because corporate network situation)
> 
> I tested on the PC 1.
> But, after that, I modified the code on the PC 2 again. And, it seemed
> I didn't do a compile.

This sort of split setup is always a bad idea. Always do the git
format-patch on PC 1 and somehow get the patch files off it, and use
PC 2 only for git send-email, never any development work. That way you
will avoid issues like this.

     Andrew
