Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D041C2C7329
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389475AbgK1VuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:50:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54658 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387685AbgK1UV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 15:21:58 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kj6iS-009Hlr-F8; Sat, 28 Nov 2020 21:21:08 +0100
Date:   Sat, 28 Nov 2020 21:21:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201128202108.GI2191767@lunn.ch>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201128190616.GF2191767@lunn.ch>
 <20201128193707.GP1551@shell.armlinux.org.uk>
 <20201128200750.GK1296649@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201128200750.GK1296649@piout.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Maybe if I was copied on the patch submission... I don't have the
> > patches, and searching google for them is a faff, especially
> > when
> > 
> > site:kernel.org 20201127133307.2969817-1-steen.hegelund@microchip.com
> > 
> > gives:
> > 
> >    Your search - site:kernel.org
> >    20201127133307.2969817-1-steen.hegelund@microchip.com - did not
> >    match any documents. Suggestions: Make sure that all words are
> >    spelled correctly. Try different keywords. Try more general
> >    keywords.
> > 
> 
> http://lore.kernel.org/r/20201127133307.2969817-1-steen.hegelund@microchip.com
> does the right redirect.

b4 mbox 20201127133307.2969817-1-steen.hegelund@microchip.com

Also seems to work, and gives you it in mbox format, which mutt should
understand. b4 is a standard part of Debian now.

	    Andrew
