Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE4A230E90
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731208AbgG1P4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:56:11 -0400
Received: from smtprelay0250.hostedemail.com ([216.40.44.250]:37202 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730963AbgG1P4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:56:11 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id EED4018029122;
        Tue, 28 Jul 2020 15:56:09 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3870:3871:3874:4321:5007:10004:10400:10848:11232:11658:11914:12048:12297:12740:12760:12895:13069:13311:13357:13439:14659:21080:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: milk44_171497c26f6b
X-Filterd-Recvd-Size: 1381
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Tue, 28 Jul 2020 15:56:08 +0000 (UTC)
Message-ID: <e5d2cb28493050f2df7cedef209288abf103b4f3.camel@perches.com>
Subject: Re: [PATCH net-next] liquidio: Remove unneeded cast from memory
 allocation
From:   Joe Perches <joe@perches.com>
To:     Derek Chickles <dchickles@marvell.com>,
        "wanghai (M)" <wanghai38@huawei.com>,
        Satananda Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Tue, 28 Jul 2020 08:56:07 -0700
In-Reply-To: <BYAPR18MB24230A8301FD9849F9943B9DAC730@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <BYAPR18MB24230A8301FD9849F9943B9DAC730@BYAPR18MB2423.namprd18.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-07-28 at 15:39 +0000, Derek Chickles wrote:
> I think that is fine as well. We just used vmalloc since there is no need
> for a physically contiguous piece of memory.

Do any of the allocs in the driver actually need vmalloc?


