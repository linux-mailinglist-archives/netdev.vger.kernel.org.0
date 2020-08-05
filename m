Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E9C23D418
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 01:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHEXHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 19:07:18 -0400
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:33822 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726542AbgHEXHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 19:07:10 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 8FA8418224D8E;
        Wed,  5 Aug 2020 23:07:06 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:421:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2734:2828:3138:3139:3140:3141:3142:3165:3354:3622:3865:3866:3867:3870:3871:3872:3873:3874:4321:5007:6119:6120:7514:7903:9038:10004:10400:10450:10455:10848:11232:11658:11914:12043:12294:12296:12297:12346:12679:12740:12760:12895:13439:14093:14096:14097:14181:14659:14721:19904:19999:21080:21212:21433:21451:21627:21939:30012:30054:30056:30060:30070:30089:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: guide34_2308aad26fb2
X-Filterd-Recvd-Size: 3797
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Wed,  5 Aug 2020 23:07:05 +0000 (UTC)
Message-ID: <8a091297aef4ebb44a65ab1c683caae006acf76a.camel@perches.com>
Subject: Re: [PATCH] MAINTAINERS: update phylink/sfp keyword matching
From:   Joe Perches <joe@perches.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Date:   Wed, 05 Aug 2020 16:07:04 -0700
In-Reply-To: <20200805220917.GZ1551@shell.armlinux.org.uk>
References: <E1k3KUx-0000da-In@rmk-PC.armlinux.org.uk>
         <CAHk-=whbLwN9GEVVt=7eYhPYk0t0Wh1xeuNEDD+xmQxBFjAQJA@mail.gmail.com>
         <20200805182250.GX1551@shell.armlinux.org.uk>
         <957f48692a2f0bc4df2d83068073c4822da30eef.camel@perches.com>
         <20200805220917.GZ1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-08-05 at 23:09 +0100, Russell King - ARM Linux admin wrote:
> On Wed, Aug 05, 2020 at 11:47:38AM -0700, Joe Perches wrote:
> > On Wed, 2020-08-05 at 19:22 +0100, Russell King - ARM Linux admin wrote:
> > > On Wed, Aug 05, 2020 at 11:11:28AM -0700, Linus Torvalds wrote:
> > > > On Wed, Aug 5, 2020 at 7:34 AM Russell King <rmk+kernel@armlinux.org.uk> wrote:
> > > > > Is this something you're willing to merge directly please?
> > > > 
> > > > Done.
> > > > 
> > > > That said:
> > > > 
> > > > > -K:     phylink
> > > > > +K:     phylink\.h|struct\s+phylink|\.phylink|>phylink_|phylink_(autoneg|clear|connect|create|destroy|disconnect|ethtool|helper|mac|mii|of|set|start|stop|test|validate)
> > > > 
> > > > That's a very awkward pattern. I wonder if there could be better ways
> > > > to express this (ie "only apply this pattern to these files" kind of
> > > > thing)
> > > 
> > > Yes, it's extremely awkward - I spent much of the morning with perl
> > > testing it out on the drivers/ subtree.
> > 
> > There are a lot of phylink_<foo> in the kernel.
> > Are those really the only uses you want to watch?
> 
> It is sufficient; as I said, I've spent a morning running this:

Cool for you, I was just asking.

How you determine what functions you're interested in
is up to you.

Another mechanism might have been something like:

$ git grep -Poh '(?:static\s+inline|EXPORT_SYMBOL).*phylink_[a-z]+' | \ 
  grep -Poh 'phylink_[a-z]+' | sort | uniq

Maybe something that could be made generic in get_maintainer
for people maintaining specific EXPORT_SYMBOL(foo) blocks.

Maybe another letter/look could be added to MAINTAINERS like:

E:	symbol_regex

as another similar mechanism for keywords but just for data
or functions marked as exported symbols.

For example, that E: might help minimize xdp matches as xdp
is used by many other bits of code that aren't express data
path uses.

MAINTAINERS-XDP (eXpress Data Path)
MAINTAINERS-M:  Alexei Starovoitov <ast@kernel.org>
MAINTAINERS-M:  Daniel Borkmann <daniel@iogearbox.net>
MAINTAINERS-M:  David S. Miller <davem@davemloft.net>
MAINTAINERS-M:  Jakub Kicinski <kuba@kernel.org>
MAINTAINERS-M:  Jesper Dangaard Brouer <hawk@kernel.org>
MAINTAINERS-M:  John Fastabend <john.fastabend@gmail.com>
MAINTAINERS-L:  netdev@vger.kernel.org
MAINTAINERS-L:  bpf@vger.kernel.org
MAINTAINERS-S:  Supported
MAINTAINERS-F:  include/net/xdp.h
MAINTAINERS-F:  include/trace/events/xdp.h
MAINTAINERS-F:  kernel/bpf/cpumap.c
MAINTAINERS-F:  kernel/bpf/devmap.c
MAINTAINERS-F:  net/core/xdp.c
MAINTAINERS-N:  xdp
MAINTAINERS:K:  xdp


