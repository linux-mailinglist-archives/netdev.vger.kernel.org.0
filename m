Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CAA1F418D
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 18:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731325AbgFIQ6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 12:58:15 -0400
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:60760 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731061AbgFIQ6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 12:58:12 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 48FFD100462CE;
        Tue,  9 Jun 2020 16:58:10 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:4321:5007:6119:10004:10400:10848:11232:11658:11914:12050:12297:12740:12760:12895:13069:13161:13229:13255:13311:13357:13439:14659:14721:21080:21433:21627:21810:30041:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: paper32_280912f26dc4
X-Filterd-Recvd-Size: 2234
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Tue,  9 Jun 2020 16:58:08 +0000 (UTC)
Message-ID: <ba32bfa93ac2e147c2e0d3a4724815a7bbf41c59.camel@perches.com>
Subject: Re: [PATCH v3 1/7] Documentation: dynamic-debug: Add description of
 level bitmask
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jim Cromie <jim.cromie@gmail.com>
Date:   Tue, 09 Jun 2020 09:58:07 -0700
In-Reply-To: <20200609111615.GD780233@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
         <20200609104604.1594-2-stanimir.varbanov@linaro.org>
         <20200609111615.GD780233@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-06-09 at 13:16 +0200, Greg Kroah-Hartman wrote:
> What is wrong with the existing control of dynamic
> debug messages that you want to add another type of arbitrary grouping
> to it? 

There is no existing grouping mechanism.

Many drivers and some subsystems used an internal one
before dynamic debug.

$ git grep "MODULE_PARM.*\bdebug\b"|wc -l
501

This is an attempt to unify those homebrew mechanisms.

Stanimir attempted to add one for his driver via a
driver specific standardized format substring for level.

> And who defines that grouping?

Individual driver authors

> Will it be driver/subsystem/arch/author specific?  Or kernel-wide?

driver specific

> This feels like it could easily get out of hand really quickly.

Likely not.  A question might be how useful all these
old debugging printks are today and if it's reasonable
to just delete them.

> Why not just use tracepoints if you really want to be fine-grained?

Weight and lack of class/group capability


