Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1466822120A
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGOQMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:12:39 -0400
Received: from smtprelay0035.hostedemail.com ([216.40.44.35]:48024 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725831AbgGOQMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:12:38 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 02B74181D303A;
        Wed, 15 Jul 2020 16:12:37 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2692:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3870:3873:3874:4321:5007:8957:10004:10400:10848:10967:11232:11658:11914:12297:12555:12740:12760:12895:13069:13311:13357:13439:14180:14181:14659:14721:21060:21080:21451:21611:21627:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:4,LUA_SUMMARY:none
X-HE-Tag: grade82_170551826efa
X-Filterd-Recvd-Size: 1637
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Wed, 15 Jul 2020 16:12:35 +0000 (UTC)
Message-ID: <6653f2f65ec4a9cc1024b69ffe97d5dc4c7ff33a.camel@perches.com>
Subject: Re: [PATCH 01/13 net-next] net: nl80211.h: drop duplicate words in
 comments
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        johannes@sipsolutions.net
Date:   Wed, 15 Jul 2020 09:12:34 -0700
In-Reply-To: <20200715084811.01ba7ffd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200715025914.28091-1-rdunlap@infradead.org>
         <20200715084811.01ba7ffd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-07-15 at 08:48 -0700, Jakub Kicinski wrote:
> On Tue, 14 Jul 2020 19:59:02 -0700 Randy Dunlap wrote:
> > Drop doubled words in several comments.
> > 
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: netdev@vger.kernel.org
> 
> Hi Randy, the WiFi stuff goes through Johannes's mac80211 tree.
> 
> Would you mind splitting those 5 patches out to a separate series and
> sending to him?

Do I understand you to want separate patches
for separate sections of individual files?

I think that's a bit much...


