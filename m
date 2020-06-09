Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517DA1F412B
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 18:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731217AbgFIQkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 12:40:35 -0400
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:44916 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731073AbgFIQkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 12:40:31 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 2F7D4183B25B7;
        Tue,  9 Jun 2020 16:40:29 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4361:5007:6691:7807:7875:7903:7974:9025:10004:10400:10848:11026:11232:11658:11914:12043:12048:12296:12297:12740:12760:12895:13069:13311:13357:13439:14180:14181:14659:14721:21080:21451:21627:21740:21788:21810:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: paste04_0b0768b26dc4
X-Filterd-Recvd-Size: 1978
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Tue,  9 Jun 2020 16:40:27 +0000 (UTC)
Message-ID: <2bf362d58b320b3081703d75ea419274fb889e9a.camel@perches.com>
Subject: Re: [PATCH v3 0/7] Venus dynamic debug
From:   Joe Perches <joe@perches.com>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>
Date:   Tue, 09 Jun 2020 09:40:26 -0700
In-Reply-To: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-06-09 at 13:45 +0300, Stanimir Varbanov wrote:
> Hello,
> 
> Here is the third version of dynamic debug improvements in Venus
> driver.  As has been suggested on previous version by Joe [1] I've
> made the relevant changes in dynamic debug core to handle leveling
> as more generic way and not open-code/workaround it in the driver.
> 
> About changes:
>  - added change in the dynamic_debug and in documentation
>  - added respective pr_debug_level and dev_dbg_level
> 
> regards,
> Stan
> 
> [1] https://lkml.org/lkml/2020/5/21/668

This capability is already clumsily used by many
drivers that use a module level "debug" flag.

$ git grep -P "MODULE_PARM.*\bdebug\b"|wc -l
501

That's a _lot_ of homebrewed mechanisms.

Making dynamic debug have this as a feature would
help consolidate and standardize the capability.

ftrace is definitely useful, but not quite as
lightweight and doesn't have the typical uses.


