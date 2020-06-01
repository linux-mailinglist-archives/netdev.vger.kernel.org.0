Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF29D1EAFD0
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgFATuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:50:37 -0400
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:47298 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727875AbgFATug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 15:50:36 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 321F8181D3025;
        Mon,  1 Jun 2020 19:50:35 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2282:2393:2553:2559:2562:2692:2693:2828:3138:3139:3140:3141:3142:3354:3622:3834:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4560:5007:6119:7903:10004:10400:10450:10455:10848:11026:11232:11658:11914:12043:12296:12297:12438:12555:12740:12760:12895:12986:13161:13229:13439:13548:14096:14097:14180:14181:14659:14721:19904:19999:21060:21080:21451:21627:21740:21889:21972:30012:30054:30083:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: stove86_2309c5626d80
X-Filterd-Recvd-Size: 3287
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Mon,  1 Jun 2020 19:50:34 +0000 (UTC)
Message-ID: <939720599f72cb9e4348a93d5b914e44ed6d3660.camel@perches.com>
Subject: Re: [PATCH net-next 0/1] wireguard column reformatting for end of
 cycle
From:   Joe Perches <joe@perches.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>
Date:   Mon, 01 Jun 2020 12:50:33 -0700
In-Reply-To: <CAHmME9pJB_Ts0+RBD=JqNBg-sfZMU+OtCCAtODBx61naZO3fqQ@mail.gmail.com>
References: <20200601062946.160954-1-Jason@zx2c4.com>
         <20200601.110044.945252928135960732.davem@davemloft.net>
         <CAHmME9pJB_Ts0+RBD=JqNBg-sfZMU+OtCCAtODBx61naZO3fqQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-06-01 at 13:33 -0600, Jason A. Donenfeld wrote:
> Hi Dave,
> 
> On Mon, Jun 1, 2020 at 12:00 PM David Miller <davem@davemloft.net> wrote:
> > This is going to make nearly every -stable backport not apply cleanly,
> > which is a severe burdon for everyone having to maintain stable trees.
> 
> This possibility had occurred to me too, which is why I mentioned the
> project being sufficiently young that this can work out. It's not
> actually in any LTS yet, which means at the worst, this will apply
> temporarily for 5.6, and only then on the off chance that a patch is
> near code that this touches. Alternatively, it'd be easy enough to add
> a Fixes: to this, just in case. I'll be sad but will understand if you
> decide to n'ack this in the end, but please do consider first that
> practically speaking this won't be nearly as bad as this kind of thing
> normally is.

It seems just this handful of wireguard patches in
-next are missing from 5.6.9.

a9e90d9931f3a474f04bab782ccd9d77904941e9 wireguard: noise: separate receive counter from send counter
c78a0b4a78839d572d8a80f6a62221c0d7843135 wireguard: queueing: preserve flow hash across packet scrubbing
bc67d371256f5c47d824e2eec51e46c8d62d022e wireguard: noise: read preshared key while taking lock
243f2148937adc72bcaaa590d482d599c936efde wireguard: send/receive: use explicit unlikely branch instead of implicit coalescing
4fed818ef54b08d4b29200e416cce65546ad5312 wireguard: selftests: initalize ipv6 members to NULL to squelch clang warning
4005f5c3c9d006157ba716594e0d70c88a235c5e wireguard: send/receive: cond_resched() when processing worker ringbuffers
b673e24aad36981f327a6570412ffa7754de8911 wireguard: socket: remove errant restriction on looping to self
eebabcb26ea1e3295704477c6cd4e772c96a9559 wireguard: receive: use tunnel helpers for decapsulating ECN markings
130c58606171326c81841a49cc913cd354113dd9 wireguard: queueing: cleanup ptr_ring in error path of packet_queue_init
d6833e42786e050e7522d6a91a9361e54085897d wireguard: send: remove errant newline from packet_encrypt_worker

It seems at least some of them fix defects.
Assuming they all get applied to 5.6.10, likely
it'd be reasonably simple to apply this cleanup.

The reformatting does make the code easier to read
and is a fair bit shorter.


