Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16FC1187BF
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 11:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfEIJ3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 05:29:39 -0400
Received: from smtprelay0195.hostedemail.com ([216.40.44.195]:57114 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725826AbfEIJ3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 05:29:39 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id CFD69100E86CA;
        Thu,  9 May 2019 09:29:37 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3872:3873:3874:4321:4433:4605:5007:6120:7208:7903:7996:9113:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12555:12679:12700:12737:12740:12760:12895:13018:13019:13069:13161:13229:13311:13357:13439:14181:14659:14721:21080:21451:21627:30054:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:38,LUA_SUMMARY:none
X-HE-Tag: skate64_198a4048ff50b
X-Filterd-Recvd-Size: 2238
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Thu,  9 May 2019 09:29:35 +0000 (UTC)
Message-ID: <1f6fbb9fdcea4a39ff11cd977a5ce46babe34454.camel@perches.com>
Subject: Re: [RFC PATCH 1/2] rtl8xxxu: Add rate adaptive related data
From:   Joe Perches <joe@perches.com>
To:     Daniel Drake <drake@endlessm.com>, Chris Chiu <chiu@endlessm.com>
Cc:     jes.sorensen@gmail.com, Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Date:   Thu, 09 May 2019 02:29:34 -0700
In-Reply-To: <CAD8Lp45WmPz2c+OnszFyaRL=veF0avEffwv3muwXNoeLcE0fhw@mail.gmail.com>
References: <20190503072146.49999-1-chiu@endlessm.com>
         <20190503072146.49999-2-chiu@endlessm.com>
         <CAD8Lp45WmPz2c+OnszFyaRL=veF0avEffwv3muwXNoeLcE0fhw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-05-09 at 16:11 +0800, Daniel Drake wrote:
> On Fri, May 3, 2019 at 3:22 PM Chris Chiu <chiu@endlessm.com> wrote:
> > Add wireless mode, signal strength level, and rate table index
> > to tell the firmware that we need to adjust the tx rate bitmap
> > accordingly.
[]
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
[]
> > +/*mlme related.*/
> > +enum wireless_mode {
> > +       WIRELESS_MODE_UNKNOWN = 0,
> > +       //Sub-Element
> 
> Run these patches through checkpatch.pl, it'll have some suggestions
> to bring the coding style in line, for example not using // style
> comments.

just fyi:

checkpatch ignores // comments since 2016
(new in 2019: unless you add --ignore=c99_comment_tolerance)

These are the relevant checkpatch commits:

In 2016, commit dadf680de3c2 ("checkpatch: allow c99 style // comments")
In 2019, commit 98005e8c743f ("checkpatch: allow reporting C99 style comments")




