Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189452CFB49
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 13:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgLEKz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 05:55:29 -0500
Received: from smtprelay0063.hostedemail.com ([216.40.44.63]:44106 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728406AbgLEKxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 05:53:51 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 6C27B18224D86;
        Sat,  5 Dec 2020 10:51:48 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:4250:4321:5007:6691:6742:6743:10004:10400:10848:10967:11232:11658:11914:12297:12740:12760:12895:13019:13069:13311:13357:13439:14096:14097:14181:14659:14721:14777:14913:21080:21433:21451:21627:21819:30022:30029:30054:30079:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: edge87_1a0a959273cc
X-Filterd-Recvd-Size: 2215
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Sat,  5 Dec 2020 10:51:44 +0000 (UTC)
Message-ID: <7779f4de8d70653fe0d92fd4821c32a71b6df436.camel@perches.com>
Subject: Re: [PATCH 1/7] net: 8021q: remove unneeded MODULE_VERSION() usage
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, marcel@holtmann.org, johan.hedberg@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, jmaloy@redhat.com,
        ying.xue@windriver.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Date:   Sat, 05 Dec 2020 02:51:43 -0800
In-Reply-To: <20201204160924.2e170514@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201202124959.29209-1-info@metux.net>
         <20201204160924.2e170514@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-12-04 at 16:09 -0800, Jakub Kicinski wrote:
> On Wed,  2 Dec 2020 13:49:53 +0100 Enrico Weigelt, metux IT consult
> wrote:
> > Remove MODULE_VERSION(), as it isn't needed at all: the only version
> > making sense is the kernel version.
> > 
> > Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
> 
> Thanks for the patches. Please drop the "metux IT consult" from the
> addresses. The from space is supposed to be for your name.

If you _really_ want this superfluous 'metux IT consult' content in your
signature, and I don't think you should, use parentheses around it.

Enrico Weigelt (metux IT consult) <info@metux.net>

Using a comma makes copy/paste into an email client think it's two addresses.



