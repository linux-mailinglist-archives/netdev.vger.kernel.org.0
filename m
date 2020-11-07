Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CA52AA742
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgKGRjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:39:47 -0500
Received: from smtprelay0223.hostedemail.com ([216.40.44.223]:39430 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727218AbgKGRjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:39:47 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id B98E3181D341E;
        Sat,  7 Nov 2020 17:39:45 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:152:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1963:2393:2559:2562:2692:2827:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:6120:6691:7901:7903:9040:10004:10400:10848:11232:11658:11783:11914:12297:12740:12895:13069:13076:13149:13230:13311:13357:13894:14096:14097:14659:21060:21080:21451:21627:21660:21972:30012:30054:30075:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: side79_2f0f021272dd
X-Filterd-Recvd-Size: 2419
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat,  7 Nov 2020 17:39:44 +0000 (UTC)
Message-ID: <6ed68a7898c5505d3106223b7ad47950a0c79dc3.camel@perches.com>
Subject: Re: [PATCH] net/dsa: remove unused macros to tame gcc warning
From:   Joe Perches <joe@perches.com>
To:     Alex Shi <alex.shi@linux.alibaba.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 07 Nov 2020 09:39:42 -0800
In-Reply-To: <b3274bdb-5680-0c24-9800-8c025bfa119a@linux.alibaba.com>
References: <1604641050-6004-1-git-send-email-alex.shi@linux.alibaba.com>
         <20201106141820.GP933237@lunn.ch>
         <24690741-cc10-eec1-33c6-7960c8b7fac6@gmail.com>
         <b3274bdb-5680-0c24-9800-8c025bfa119a@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-11-07 at 20:54 +0800, Alex Shi wrote:
> 在 2020/11/7 上午12:39, Florian Fainelli 写道:
> > > It is good to remember that there are multiple readers of source
> > > files. There is the compiler which generates code from it, and there
> > > is the human trying to understand what is going on, what the hardware
> > > can do, how we could maybe extend the code in the future to make use
> > > of bits are currently don't, etc.
> > > 
> > > The compiler has no use of these macros, at the moment. But i as a
> > > human do. It is valuable documentation, given that there is no open
> > > datasheet for this hardware.
> > > 
> > > I would say these warnings are bogus, and the code should be left
> > > alone.
> > Agreed, these definitions are intended to document what the hardware
> > does. These warnings are getting too far.
> 
> Thanks for all comments! I agree these info are much meaningful.
> Is there other way to tame the gcc warning? like put them into a .h file
> or covered by comments?

Does _any_ version of gcc have this warning on by default?

I still think my proposal of moving the warning from W=2 to W=3
quite reasonable.

Another possibility is to turn the warning off altogether.


