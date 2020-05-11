Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5999C1CE15F
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 19:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730744AbgEKRQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 13:16:38 -0400
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:34178 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728556AbgEKRQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 13:16:37 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id B80131802EF0E;
        Mon, 11 May 2020 17:16:36 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2565:2682:2685:2828:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4362:5007:6119:7875:7903:7974:8660:8957:9025:10004:10400:10848:11232:11658:11914:12043:12295:12297:12555:12696:12737:12740:12760:12895:12986:13069:13148:13230:13311:13357:13439:14096:14097:14157:14181:14659:14721:21080:21433:21451:21627:21811:21939:30012:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: feast86_39949ece28c5c
X-Filterd-Recvd-Size: 2164
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Mon, 11 May 2020 17:16:35 +0000 (UTC)
Message-ID: <c4c6fee41ceb2eb4b583df37ad0d659357cd81d8.camel@perches.com>
Subject: Re: [PATCH net-next v3] checkpatch: warn about uses of ENOTSUPP
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        linux-kernel@vger.kernel.org
Date:   Mon, 11 May 2020 10:16:34 -0700
In-Reply-To: <20200511170807.2252749-1-kuba@kernel.org>
References: <20200511170807.2252749-1-kuba@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-05-11 at 10:08 -0700, Jakub Kicinski wrote:
> ENOTSUPP often feels like the right error code to use, but it's
> in fact not a standard Unix error. E.g.:
> 
> $ python
> > > > import errno
> > > > errno.errorcode[errno.ENOTSUPP]
> Traceback (most recent call last):
>   File "<stdin>", line 1, in <module>
> AttributeError: module 'errno' has no attribute 'ENOTSUPP'
> 
> There were numerous commits converting the uses back to EOPNOTSUPP
> but in some cases we are stuck with the high error code for backward
> compatibility reasons.
> 
> Let's try prevent more ENOTSUPPs from getting into the kernel.
> 
> Recent example:
> https://lore.kernel.org/netdev/20200510182252.GA411829@lunn.ch/
> 
> v3 (Joe):
>  - fix the "not file" condition.
> 
> v2 (Joe):
>  - add a link to recent discussion,
>  - don't match when scanning files, not patches to avoid sudden
>    influx of conversion patches.
> https://lore.kernel.org/netdev/20200511165319.2251678-1-kuba@kernel.org/
> 
> v1:
> https://lore.kernel.org/netdev/20200510185148.2230767-1-kuba@kernel.org/
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Acked-by: Joe Perches <joe@perches.com>
> ---

Thanks.

No worries here and it's not worth a respin, but
typically the patch changelog goes below the --- line.


