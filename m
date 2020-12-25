Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3D22E2BF7
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 18:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgLYRHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 12:07:37 -0500
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:53988 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725953AbgLYRHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 12:07:37 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id E8A0118029140;
        Fri, 25 Dec 2020 17:06:55 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6742:7652:7902:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13069:13076:13311:13357:13439:14659:14721:21080:21627:30012:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: band89_34144c92747b
X-Filterd-Recvd-Size: 1987
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Fri, 25 Dec 2020 17:06:53 +0000 (UTC)
Message-ID: <327d6cad23720c8fe984aa75a046ff69499568c8.camel@perches.com>
Subject: Re: [PATCH] nfp: remove h from printk format specifier
From:   Joe Perches <joe@perches.com>
To:     Tom Rix <trix@redhat.com>,
        Simon Horman <simon.horman@netronome.com>
Cc:     kuba@kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, gustavoars@kernel.org,
        louis.peens@netronome.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, oss-drivers@netronome.com,
        linux-kernel@vger.kernel.org
Date:   Fri, 25 Dec 2020 09:06:51 -0800
In-Reply-To: <7b5517e6-41a9-cc7f-f42f-8ef449f3898e@redhat.com>
References: <20201223202053.131157-1-trix@redhat.com>
         <20201224202152.GA3380@netronome.com>
         <bac92bab-243b-ca48-647c-dad5688fa060@redhat.com>
         <18c81854639aa21e76c8b26cc3e7999b0428cc4e.camel@perches.com>
         <7b5517e6-41a9-cc7f-f42f-8ef449f3898e@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-12-25 at 06:56 -0800, Tom Rix wrote:
> On 12/24/20 2:39 PM, Joe Perches wrote:
[]
> > Kernel code doesn't use a signed char or short with %hx or %hu very often
> > but in case you didn't already know, any signed char/short emitted with
> > anything like %hx or %hu needs to be left alone as sign extension occurs so:
> 
> Yes, this would also effect checkpatch.

Of course but checkpatch is stupid and doesn't know types
so it just assumes that the type argument is not signed.

In general, that's a reasonable but imperfect assumption.

coccinelle could probably do this properly as it's a much
better parser.  clang-tidy should be able to as well.


