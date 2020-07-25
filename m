Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DAA22D9F5
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 23:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgGYVDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 17:03:45 -0400
Received: from smtprelay0013.hostedemail.com ([216.40.44.13]:53398 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728015AbgGYVDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 17:03:45 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 83030100E7B47;
        Sat, 25 Jul 2020 21:03:44 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:3868:3870:3871:3872:4321:5007:7974:10004:10400:10848:11232:11658:11914:12043:12297:12555:12679:12740:12760:12895:12903:12986:13069:13161:13229:13311:13357:13439:14181:14659:14721:14819:21080:21627:30029:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: sun63_59013f726f53
X-Filterd-Recvd-Size: 1432
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 25 Jul 2020 21:03:42 +0000 (UTC)
Message-ID: <f7349cdd968aa8e8fa6552d62999a7e05fa875f7.camel@perches.com>
Subject: Re: [PATCH 0/6] rtlwifi: Convert RT_TRACE to rtl_dbg and neatening
From:   Joe Perches <joe@perches.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 25 Jul 2020 14:03:41 -0700
In-Reply-To: <cover.1595706419.git.joe@perches.com>
References: <cover.1595706419.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-07-25 at 12:55 -0700, Joe Perches wrote:
> RT_TRACE seems like it should be associated to tracing but it's not.
> It's a generic debug logging mechanism.
> Rename it to a more typical name.
> Miscellaneous neatening around these changes.

Patch 1/6 is over 1MB and is too large for some mailing lists.

These patches are based on wireless-drivers-next and are also
available at:

git://repo.or.cz/linux-2.6/trivial-mods.git in branch 20200724_rtlwifi


