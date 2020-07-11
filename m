Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C04C21C3E1
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 13:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgGKLKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 07:10:19 -0400
Received: from smtprelay0109.hostedemail.com ([216.40.44.109]:58056 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726523AbgGKLKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 07:10:19 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 22C46100E7B42;
        Sat, 11 Jul 2020 11:10:17 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3165:3355:3622:3865:3866:3867:3870:3871:3872:3873:3874:4321:4605:5007:6119:6742:7514:10004:10400:10848:10967:11232:11657:11658:11914:12043:12295:12297:12555:12663:12740:12895:12986:13439:13894:14093:14097:14181:14659:14721:21080:21451:21627:21740:30029:30054:30056:30064:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: day58_420072326ed6
X-Filterd-Recvd-Size: 3571
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 11 Jul 2020 11:10:15 +0000 (UTC)
Message-ID: <02995ace8cc4524d44bf6e6db0282391c3f6d8e4.camel@perches.com>
Subject: Re: [PATCH v2] MAINTAINERS: XDP: restrict N: and K:
From:   Joe Perches <joe@perches.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com,
        mchehab+huawei@kernel.org, robh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Sat, 11 Jul 2020 04:10:13 -0700
In-Reply-To: <20200711102318.28ce29d6@carbon>
References: <87tuyfi4fm.fsf@toke.dk>
         <20200710190407.31269-1-grandmaster@al2klimov.de>
         <28a81dfe62b1dc00ccc721ddb88669d13665252b.camel@perches.com>
         <20200711102318.28ce29d6@carbon>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-07-11 at 10:23 +0200, Jesper Dangaard Brouer wrote:
> On Fri, 10 Jul 2020 12:37:47 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Fri, 2020-07-10 at 21:04 +0200, Alexander A. Klimov wrote:
> > > Rationale:
> > > Documentation/arm/ixp4xx.rst contains "xdp" as part of "ixdp465"
> > > which has nothing to do with XDP.
> > > 
> > > Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> > > ---
> > >  Better?
> > > 
> > >  MAINTAINERS | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 1d4aa7f942de..735e2475e926 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -18708,8 +18708,8 @@ F:	include/trace/events/xdp.h
> > >  F:	kernel/bpf/cpumap.c
> > >  F:	kernel/bpf/devmap.c
> > >  F:	net/core/xdp.c
> > > -N:	xdp
> > > -K:	xdp
> > > +N:	(?:\b|_)xdp
> > > +K:	(?:\b|_)xdp  
> > 
> > Generally, it's better to have comprehensive files lists
> > rather than adding name matching regexes.
> 
> I like below more direct matching of the files we already know are XDP
> related. The pattern match are meant to catch drivers containing XDP
> related bits.

That's what the K: entry is for no?

Anyway, if you agree with using the appropriate F: patterns,
please submit it.  I'm not going to.

> (small typo in your patch below)
> 
> > Perhaps:
> > ---
> >  MAINTAINERS | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 16854e47e8cb..2e96cbf15b31 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -18763,13 +18763,19 @@ M:	John Fastabend <john.fastabend@gmail.com>
> >  L:	netdev@vger.kernel.org
> >  L:	bpf@vger.kernel.org
> >  S:	Supported
> > -F:	include/net/xdp.h
> > +F:	Documentation/networking/af_xdp.rst
> > +F:	include/net/xdp*
> >  F:	include/trace/events/xdp.h
> > +F:	include/uapi/linux/if_xdp.h
> > +F:	include/uapi/linux/xdp_diag.h
> >  F:	kernel/bpf/cpumap.c
> >  F:	kernel/bpf/devmap.c
> >  F:	net/core/xdp.c
> > -N:	xdp
> > -K:	xdp
> > +F:	net/xdp/
> > +F:	samples/bpf/xdp*
> > +F:	tools/testing/selftests/bfp/*xdp*
>                                ^^^^ 
> Typo, should be "bpf"
> 
> > +F:	tools/testing/selftests/bfp/*/*xdp*
> > +K:	(?:\b|_)xdp(?:\b|_)
> >  
> >  XDP SOCKETS (AF_XDP)
> >  M:	Björn Töpel <bjorn.topel@intel.com>
> > 
> 
> 

