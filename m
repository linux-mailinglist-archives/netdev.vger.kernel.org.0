Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C28E292BED
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 18:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbgJSQzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 12:55:05 -0400
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:57428 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730322AbgJSQzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 12:55:05 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 965181802926E;
        Mon, 19 Oct 2020 16:55:03 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2692:2693:2828:2892:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3872:3873:4321:5007:10004:10400:11232:11658:11914:12295:12297:12555:12740:12760:12895:13069:13311:13357:13439:14659:21080:21611:21627:21740:30012:30034:30054:30075:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: air55_460ecc327238
X-Filterd-Recvd-Size: 2011
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Mon, 19 Oct 2020 16:55:01 +0000 (UTC)
Message-ID: <b92c72c591e6657ebb7f1984959607b3949ef58a.camel@perches.com>
Subject: Re: [PATCH] [v6] wireless: Initial driver submission for pureLiFi
 STA devices
From:   Joe Perches <joe@perches.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>,
        Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Date:   Mon, 19 Oct 2020 09:54:59 -0700
In-Reply-To: <LOYP265MB1918B212C618FF60333BFD85E01E0@LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM>
References: <20201019031744.17916-1-srini.raju@purelifi.com>
         <20201019083914.10932-1-srini.raju@purelifi.com>
        ,<CABPxzYJaB5_zZshs3JCnPDgUZQZc+XRN+DuE3BjGjJKsiJh0uA@mail.gmail.com>
         <LOYP265MB1918B212C618FF60333BFD85E01E0@LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-19 at 16:40 +0000, Srinivasan Raju wrote:
> > Overall, there are many magic numbers without comments, this makes it hard to
> > understand the code. Using defines with proper naming helps and for 802.11 stuff
> > can use ieee80211_*/IEEE80211_* should be used.
> 
> Thanks for your comments Krishna, will work on them.

When you do, please start adding
changelog information below the
---
line to your patches.

It's quite a chore to figure out
what changed between revisions.


