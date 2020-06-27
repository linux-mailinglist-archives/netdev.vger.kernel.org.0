Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C559620BD5D
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 02:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgF0AGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 20:06:38 -0400
Received: from smtprelay0177.hostedemail.com ([216.40.44.177]:46550 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726101AbgF0AGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 20:06:37 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 25C3A100E7B42;
        Sat, 27 Jun 2020 00:06:36 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3866:3867:3870:3871:3872:4321:5007:10004:10400:10848:11026:11232:11658:11914:12296:12297:12740:12760:12895:13069:13311:13357:13439:14659:14721:14819:21080:21627:21990:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: roof26_4408f0826e59
X-Filterd-Recvd-Size: 1693
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 27 Jun 2020 00:06:34 +0000 (UTC)
Message-ID: <324448187976fc690ea63f1c18e063fb0b09f740.camel@perches.com>
Subject: Re: [PATCH 2/2] staging: qlge: fix else after return or break
From:   Joe Perches <joe@perches.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Fri, 26 Jun 2020 17:06:33 -0700
In-Reply-To: <20200626235725.2rcpisito2253jhm@Rk>
References: <20200625215755.70329-1-coiby.xu@gmail.com>
         <20200625215755.70329-3-coiby.xu@gmail.com>
         <049f51497b84e55e61aca989025b64493287cbab.camel@perches.com>
         <20200626235725.2rcpisito2253jhm@Rk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-06-27 at 07:57 +0800, Coiby Xu wrote:
> On Thu, Jun 25, 2020 at 03:13:14PM -0700, Joe Perches wrote:
> > On Fri, 2020-06-26 at 05:57 +0800, Coiby Xu wrote:
> > > Remove unnecessary elses after return or break.
> > 
> > unrelated trivia:
[]
> > looks like all of these could use netdev_err
[]
> should we also replace all pr_errs with netdev_err in
> ql_dump_* functions?

Ideally, anywhere a struct netdevice * is available, it should
be used to output netdev_<level> in preference to pr_<level>.


