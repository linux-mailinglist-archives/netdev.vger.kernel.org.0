Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD729268410
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 07:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgINF1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 01:27:07 -0400
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:39272 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726027AbgINF1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 01:27:05 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 29EDF180F6CC3;
        Mon, 14 Sep 2020 05:27:04 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3873:4321:5007:7903:8603:10004:10400:10848:11232:11658:11914:12114:12297:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21324:21627:21660:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:4,LUA_SUMMARY:none
X-HE-Tag: floor72_0a09cdf27106
X-Filterd-Recvd-Size: 1348
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Mon, 14 Sep 2020 05:27:02 +0000 (UTC)
Message-ID: <c6568e2e4450633136c6e7d85f29ed68aa01a32f.camel@perches.com>
Subject: Re: [PATCH net-next] octeontx2-af: Constify
 npc_kpu_profile_{action,cam}
From:   Joe Perches <joe@perches.com>
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jerin Jacob <jerinj@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 13 Sep 2020 22:27:01 -0700
In-Reply-To: <20200911220015.41830-1-rikard.falkeborn@gmail.com>
References: <20200911220015.41830-1-rikard.falkeborn@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-09-12 at 00:00 +0200, Rikard Falkeborn wrote:
> These are never modified, so constify them to allow the compiler to
> place them in read-only memory. This moves about 25kB to read-only
> memory as seen by the output of the size command.

Nice.

Did you find this by tool or inspection?


