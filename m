Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53AA1BEDDE
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 03:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgD3Bvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 21:51:53 -0400
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:48620 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726282AbgD3Bvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 21:51:53 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 51CBD182CED28;
        Thu, 30 Apr 2020 01:51:52 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1381:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3866:3867:3868:3870:4321:5007:7903:10004:10400:10848:11232:11658:11914:12048:12296:12297:12740:12760:12895:13069:13255:13311:13357:13439:14181:14659:14721:21080:21451:21627:30012:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: lock88_4a60899a54114
X-Filterd-Recvd-Size: 1288
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Thu, 30 Apr 2020 01:51:50 +0000 (UTC)
Message-ID: <d03d6118f6640ac170c8e55fb0846b73f75f6f3c.camel@perches.com>
Subject: Re: [PATCH v2 0/7] staging: qlge: Checkpatch.pl indentation fixes
 in qlge_main.c
From:   Joe Perches <joe@perches.com>
To:     Rylan Dmello <mail@rylan.coffee>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 29 Apr 2020 18:51:49 -0700
In-Reply-To: <cover.1588209862.git.mail@rylan.coffee>
References: <cover.1588209862.git.mail@rylan.coffee>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-04-29 at 21:31 -0400, Rylan Dmello wrote:
> This patchset fixes some indentation- and style-related issues in qlge_main.c
> reported by checkpatch.pl, such as:
> 
>   WARNING: Avoid multiple line dereference
>   WARNING: line over 80 characters
>   WARNING: suspect code indent for conditional statements

All of this looks reasonable to me.


