Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D51A180BCD
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgCJWnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:43:24 -0400
Received: from smtprelay0023.hostedemail.com ([216.40.44.23]:46894 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726293AbgCJWnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:43:24 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 406F0815F;
        Tue, 10 Mar 2020 22:43:23 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:966:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2110:2196:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3867:3871:3872:3874:4321:4385:5007:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13069:13255:13311:13357:13439:14659:14721:21080:21627:21990:30012:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: pot45_1d56460630d0c
X-Filterd-Recvd-Size: 1994
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Tue, 10 Mar 2020 22:43:21 +0000 (UTC)
Message-ID: <ac0ab948aabd201360d9330c206dd72df14847ae.camel@perches.com>
Subject: Re: [PATCH][next] zd1211rw/zd_usb.h: Replace zero-length array with
 flexible-array member
From:   Joe Perches <joe@perches.com>
To:     Jes Sorensen <jes.sorensen@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Mar 2020 15:41:39 -0700
In-Reply-To: <e65fd08d-984f-0bdc-5fbf-6abceacf819a@gmail.com>
References: <20200305111216.GA24982@embeddedor>
         <87k13yq2jo.fsf@kamboji.qca.qualcomm.com>
         <256881484c5db07e47c611a56550642a6f6bd8e9.camel@perches.com>
         <87blpapyu5.fsf@kamboji.qca.qualcomm.com>
         <1bb7270f-545b-23ca-aa27-5b3c52fba1be@embeddedor.com>
         <87r1y0nwip.fsf@kamboji.qca.qualcomm.com>
         <48ff1333-0a14-36d8-9565-a7f13a06c974@embeddedor.com>
         <021d1125-3ffd-39ef-395a-b796c527bde4@gmail.com>
         <fb3395d7-e932-10ac-1feb-ab2ceb63424e@embeddedor.com>
         <937b0b529509ec1641453ef7c13f38e2d7cc813e.camel@perches.com>
         <c2aa4d8d-1c39-1903-2b49-382f2143e181@embeddedor.com>
         <8b6213e51131deacbdac29a8d9c088ae49933724.camel@perches.com>
         <e65fd08d-984f-0bdc-5fbf-6abceacf819a@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-03-10 at 18:33 -0400, Jes Sorensen wrote:
> Again, the changes are not harmful to the code, but add no value.

That argument asserts that style consistency is value-free.
I generally disagree with that argument.

But then again, it's likely we will have to agree to disagree.

cheers, Joe

