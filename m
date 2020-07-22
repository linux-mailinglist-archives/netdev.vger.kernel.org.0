Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5DD22A0E2
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 22:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732855AbgGVUqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 16:46:36 -0400
Received: from smtprelay0032.hostedemail.com ([216.40.44.32]:55562 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726452AbgGVUqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 16:46:36 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 2D8AB1D6A0374;
        Wed, 22 Jul 2020 20:46:35 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1461:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3872:3873:3874:4321:5007:7576:7901:7903:9036:10004:10400:10848:10967:11232:11658:11914:12043:12297:12740:12760:12895:13069:13311:13357:13439:14181:14659:14721:21080:21451:21611:21627:21740:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: vase54_4e01a1326f39
X-Filterd-Recvd-Size: 1999
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 22 Jul 2020 20:46:33 +0000 (UTC)
Message-ID: <8721f64a3150e1e5c4813738f470443297ef1cdd.camel@perches.com>
Subject: Re: [PATCH v2] net-sysfs: add a newline when printing 'tx_timeout'
 by sysfs
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>, stephen@networkplumber.org
Cc:     wangxiongfeng2@huawei.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 22 Jul 2020 13:46:32 -0700
In-Reply-To: <20200722.132311.31388808811810422.davem@davemloft.net>
References: <1595314977-57991-1-git-send-email-wangxiongfeng2@huawei.com>
         <20200721.153632.1416164807029507588.davem@davemloft.net>
         <20200722082741.1675d611@hermes.lan>
         <20200722.132311.31388808811810422.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-07-22 at 13:23 -0700, David Miller wrote:
> From: Stephen Hemminger <stephen@networkplumber.org>
> Date: Wed, 22 Jul 2020 08:27:41 -0700
> 
> > On Tue, 21 Jul 2020 15:36:32 -0700 (PDT)
> > David Miller <davem@davemloft.net> wrote:
> > 
> >> From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> >> Date: Tue, 21 Jul 2020 15:02:57 +0800
> >> 
> >> > When I cat 'tx_timeout' by sysfs, it displays as follows. It's better to
> >> > add a newline for easy reading.
> >> > 
> >> > root@syzkaller:~# cat /sys/devices/virtual/net/lo/queues/tx-0/tx_timeout
> >> > 0root@syzkaller:~#
> >> > 
> >> > Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>  
> >> 
> >> Applied, thank you.
> > 
> > Could you add
> 
> Stephen, of all people you should know by now that all of my commits
> are %100 immutable.  So commit log changes cannot be made after I've
> applied the patch, ever.

Maybe it's time to use git notes?


