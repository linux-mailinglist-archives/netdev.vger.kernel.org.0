Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E23B1F4159
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 18:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731277AbgFIQti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 12:49:38 -0400
Received: from smtprelay0148.hostedemail.com ([216.40.44.148]:58246 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731061AbgFIQtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 12:49:36 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 07A511005E387;
        Tue,  9 Jun 2020 16:49:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2525:2553:2561:2564:2682:2685:2828:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7514:7875:7903:9025:10004:10400:10848:11026:11232:11658:11914:12043:12048:12296:12297:12555:12740:12760:12895:12986:13069:13311:13357:13439:13845:14181:14659:14721:21080:21451:21627:21740:21811:21939:30029:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: van97_43148ba26dc4
X-Filterd-Recvd-Size: 2619
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Tue,  9 Jun 2020 16:49:31 +0000 (UTC)
Message-ID: <9a79aded6981ec47f1f8b317b784e6e44158ac61.camel@perches.com>
Subject: Re: [PATCH v3 0/7] Venus dynamic debug
From:   Joe Perches <joe@perches.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Jim Cromie <jim.cromie@gmail.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>
Date:   Tue, 09 Jun 2020 09:49:30 -0700
In-Reply-To: <c239d5df-e069-2091-589e-30f341c2cbd3@infradead.org>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
         <20200609111323.GA19604@bombadil.infradead.org>
         <c239d5df-e069-2091-589e-30f341c2cbd3@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(adding Jim Cromie and comments)

On Tue, 2020-06-09 at 09:03 -0700, Randy Dunlap wrote:
> On 6/9/20 4:13 AM, Matthew Wilcox wrote:
> > On Tue, Jun 09, 2020 at 01:45:57PM +0300, Stanimir Varbanov wrote:
> > > Here is the third version of dynamic debug improvements in Venus
> > > driver.  As has been suggested on previous version by Joe [1] I've
> > > made the relevant changes in dynamic debug core to handle leveling
> > > as more generic way and not open-code/workaround it in the driver.
> > > 
> > > About changes:
> > >  - added change in the dynamic_debug and in documentation
> > >  - added respective pr_debug_level and dev_dbg_level
> > 
> > Honestly, this seems like you want to use tracepoints, not dynamic debug.

Tracepoints are a bit heavy and do not have any class
or grouping mechanism.

debug_class is likely a better name than debug_level

> Also see this patch series:
> https://lore.kernel.org/lkml/20200605162645.289174-1-jim.cromie@gmail.com/
> [PATCH 00/16] dynamic_debug: cleanups, 2 features
> 
> It adds/expands dynamic debug flags quite a bit.

Yes, and thanks Randy and Jim and Stanimir

I haven't gone through Jim's proposal enough yet.
It's unfortunate these patches series conflict.

And for Jim, a link to Stanimir's patch series:
https://lore.kernel.org/lkml/20200609104604.1594-1-stanimir.varbanov@linaro.org/


