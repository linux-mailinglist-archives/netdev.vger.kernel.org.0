Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3341C2A91CE
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgKFIwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:52:18 -0500
Received: from smtprelay0031.hostedemail.com ([216.40.44.31]:59746 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725868AbgKFIwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:52:18 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id D6ECC837F253;
        Fri,  6 Nov 2020 08:52:16 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:152:355:379:599:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2691:2827:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3872:3873:4321:5007:6119:6120:7901:7903:8531:8660:10004:10400:10848:11232:11658:11783:11914:12297:12555:12740:12895:13069:13138:13148:13230:13231:13311:13357:13894:14659:14721:21060:21080:21627:21660:21939:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: hope57_0d0ff78272d1
X-Filterd-Recvd-Size: 2210
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Fri,  6 Nov 2020 08:52:15 +0000 (UTC)
Message-ID: <1662b333dd72369af4c1173035d43590fbc45292.camel@perches.com>
Subject: Re: [PATCH] net/dsa: remove unused macros to tame gcc warning
From:   Joe Perches <joe@perches.com>
To:     Alex Shi <alex.shi@linux.alibaba.com>, andrew@lunn.ch
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 06 Nov 2020 00:52:14 -0800
In-Reply-To: <8e0fac45-9107-cdfe-de9e-ccf3abd416a4@linux.alibaba.com>
References: <1604641050-6004-1-git-send-email-alex.shi@linux.alibaba.com>
         <71dc38c1646980840fb83d82fc588501af72e05f.camel@perches.com>
         <8e0fac45-9107-cdfe-de9e-ccf3abd416a4@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-11-06 at 16:28 +0800, Alex Shi wrote:
> 
> 在 2020/11/6 下午2:36, Joe Perches 写道:
> > On Fri, 2020-11-06 at 13:37 +0800, Alex Shi wrote:
> > > There are some macros unused, they causes much gcc warnings. Let's
> > > remove them to tame gcc.
> > 
> > I believe these to be essentially poor warnings.
> > 
> > Aren't these warnings generated only when adding  W=2 to the make
> > command line?
> > 
> > Perhaps it's better to move the warning to level 3
> > ---
> > diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> > index 95e4cdb94fe9..5c3c220ddb32 100644
> > --- a/scripts/Makefile.extrawarn
> > +++ b/scripts/Makefile.extrawarn
> > @@ -68,7 +68,6 @@ KBUILD_CFLAGS += $(call cc-option, -Wlogical-op)
> >  KBUILD_CFLAGS += -Wmissing-field-initializers
> >  KBUILD_CFLAGS += -Wtype-limits
> >  KBUILD_CFLAGS += $(call cc-option, -Wmaybe-uninitialized)
> > -KBUILD_CFLAGS += $(call cc-option, -Wunused-macros)
> 
> This changed too much, and impact others. May not good. :)

Can you clarify what you mean?


