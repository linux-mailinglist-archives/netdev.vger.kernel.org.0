Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0422AA848
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 23:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgKGWdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 17:33:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41118 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKGWdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 17:33:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kbWlZ-005qOv-8H; Sat, 07 Nov 2020 23:33:01 +0100
Date:   Sat, 7 Nov 2020 23:33:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joe Perches <joe@perches.com>
Cc:     Alex Shi <alex.shi@linux.alibaba.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/dsa: remove unused macros to tame gcc warning
Message-ID: <20201107223301.GY933237@lunn.ch>
References: <1604641050-6004-1-git-send-email-alex.shi@linux.alibaba.com>
 <20201106141820.GP933237@lunn.ch>
 <24690741-cc10-eec1-33c6-7960c8b7fac6@gmail.com>
 <b3274bdb-5680-0c24-9800-8c025bfa119a@linux.alibaba.com>
 <6ed68a7898c5505d3106223b7ad47950a0c79dc3.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ed68a7898c5505d3106223b7ad47950a0c79dc3.camel@perches.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 07, 2020 at 09:39:42AM -0800, Joe Perches wrote:
> On Sat, 2020-11-07 at 20:54 +0800, Alex Shi wrote:
> > 在 2020/11/7 上午12:39, Florian Fainelli 写道:
> > > > It is good to remember that there are multiple readers of source
> > > > files. There is the compiler which generates code from it, and there
> > > > is the human trying to understand what is going on, what the hardware
> > > > can do, how we could maybe extend the code in the future to make use
> > > > of bits are currently don't, etc.
> > > > 
> > > > The compiler has no use of these macros, at the moment. But i as a
> > > > human do. It is valuable documentation, given that there is no open
> > > > datasheet for this hardware.
> > > > 
> > > > I would say these warnings are bogus, and the code should be left
> > > > alone.
> > > Agreed, these definitions are intended to document what the hardware
> > > does. These warnings are getting too far.
> > 
> > Thanks for all comments! I agree these info are much meaningful.
> > Is there other way to tame the gcc warning? like put them into a .h file
> > or covered by comments?
> 
> Does _any_ version of gcc have this warning on by default?
> 
> I still think my proposal of moving the warning from W=2 to W=3
> quite reasonable.
> 
> Another possibility is to turn the warning off altogether.

Lets tern the question around first. How many real bugs have you found
with this warning? Places where the #define should of been used, but
was not? Then we can get an idea of the value of this warning. My
guess would be, its value is ~ 0 for the kernel. If so, we should just
turn it off.

     Andrew
