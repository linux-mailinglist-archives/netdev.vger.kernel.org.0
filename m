Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBEB1F5C31
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 21:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgFJTuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 15:50:02 -0400
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:34158 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730085AbgFJTuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 15:50:02 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 700B5180295B8;
        Wed, 10 Jun 2020 19:50:00 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3872:3874:4321:5007:6119:6691:7903:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13069:13172:13229:13311:13357:13439:14659:14721:21080:21433:21627:21740:30045:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: blade08_160868726dcd
X-Filterd-Recvd-Size: 1819
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 10 Jun 2020 19:49:58 +0000 (UTC)
Message-ID: <31e1aa72b41f9ff19094476033511442bb6ccda0.camel@perches.com>
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Jason Baron <jbaron@akamai.com>
Date:   Wed, 10 Jun 2020 12:49:57 -0700
In-Reply-To: <20200610133717.GB1906670@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
         <20200609104604.1594-7-stanimir.varbanov@linaro.org>
         <20200609111414.GC780233@kroah.com>
         <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
         <20200610133717.GB1906670@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-06-10 at 15:37 +0200, Greg Kroah-Hartman wrote:
> Please work with the infrastructure we have, we have spent a lot of time
> and effort to make it uniform to make it easier for users and
> developers.

Not quite.

This lack of debug grouping by type has been a
_long_ standing issue with drivers.

> Don't regress and try to make driver-specific ways of doing
> things, that way lies madness...

It's not driver specific, it allows driver developers to
better isolate various debug states instead of keeping
lists of specific debug messages and enabling them
individually.


