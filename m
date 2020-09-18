Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1CC26FF32
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgIRNyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:54:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43438 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgIRNyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 09:54:09 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJGpv-00FF2u-D6; Fri, 18 Sep 2020 15:54:03 +0200
Date:   Fri, 18 Sep 2020 15:54:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?5YqJ5YGJ5qyK?= <willy.liu@realtek.com>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ryan Kao <ryankao@realtek.com>,
        Kyle Evans <kevans@FreeBSD.org>,
        Joe Hershberger <joe.hershberger@ni.com>,
        Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH] net: phy: realtek: fix rtl8211e rx/tx delay config
Message-ID: <20200918135403.GC3631014@lunn.ch>
References: <1600307253-3538-1-git-send-email-willy.liu@realtek.com>
 <20200917101035.uwajg4m524g4lz5o@mobilestation>
 <87c4ebf4b1fe48a7a10b27d0ba0b333c@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87c4ebf4b1fe48a7a10b27d0ba0b333c@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 06:55:16AM +0000, 劉偉權 wrote:
> Hi Serge,

> Thanks for your reply. There is a confidential issue that realtek
> doesn't offer the detail of a full register layout for configuration
> register.

...

> >  	 * 0xa4 extension page (0x7) layout. It can be used to disable/enable
> >  	 * the RX/TX delays otherwise controlled by RXDLY/TXDLY pins. It can
> >  	 * also be used to customize the whole configuration register:
> 
> > -	 * 8:6 = PHY Address, 5:4 = Auto-Negotiation, 3 = Interface Mode Select,
> > -	 * 2 = RX Delay, 1 = TX Delay, 0 = SELRGV (see original PHY datasheet
> > -	 * for details).
> > +	 * 13 = Force Tx RX Delay controlled by bit12 bit11,
> > +	 * 12 = RX Delay, 11 = TX Delay
> 

> Here you've removed the register layout description and replaced itq
> with just three bits info. So from now the text above doesn't really
> corresponds to what follows.

> I might have forgotten something, but AFAIR that register bits
> stateq mapped well to what was available on the corresponding
> external pins.

Hi Willy

So it appears bits 3 to 8 have been reverse engineered. Unless you
know from your confidential datasheet that these are wrong, please
leave the comment alone.

If you confidential datasheet says that the usage of bits 0-2 is
wrong, then please do correct that part.

       Andrew
