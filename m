Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3801C4C73
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgEEDCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:02:32 -0400
Received: from smtprelay0073.hostedemail.com ([216.40.44.73]:35450 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726516AbgEEDCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:02:31 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 9C5F31802E6D5;
        Tue,  5 May 2020 03:02:30 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:2895:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3870:4321:5007:6120:6737:7514:10004:10400:10848:11026:11232:11658:11914:12048:12296:12297:12555:12740:12895:13019:13069:13255:13311:13357:13439:13894:14181:14659:14721:21080:21451:21627:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: spade83_6ce8685b68a3f
X-Filterd-Recvd-Size: 1826
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Tue,  5 May 2020 03:02:28 +0000 (UTC)
Message-ID: <5ae86fa9e7fbb92e08055dd60526bf9802217f5f.camel@perches.com>
Subject: Re: [RFC PATCH bpf-next 13/13] MAINTAINERS, xsk: update AF_XDP
 section after moves/adds
From:   Joe Perches <joe@perches.com>
To:     =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Cc:     =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Date:   Mon, 04 May 2020 20:02:27 -0700
In-Reply-To: <20200504113716.7930-14-bjorn.topel@gmail.com>
References: <20200504113716.7930-1-bjorn.topel@gmail.com>
         <20200504113716.7930-14-bjorn.topel@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-05-04 at 13:37 +0200, Björn Töpel wrote:
> Update MAINTAINERS to correctly mirror the current AF_XDP socket file
> layout. Also, add the AF_XDP files of libbpf.
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -18451,8 +18451,12 @@ R:	Jonathan Lemon <jonathan.lemon@gmail.com>
>  L:	netdev@vger.kernel.org
>  L:	bpf@vger.kernel.org
>  S:	Maintained
> -F:	kernel/bpf/xskmap.c
>  F:	net/xdp/
> +F:	include/net/xdp_sock*
> +F:	include/net/xsk_buffer_pool.h
> +F:	include/uapi/linux/if_xdp.h
> +F:	tools/lib/bpf/xsk*
> +F:	samples/bpf/xdpsock*

Alphabetic order in file patterns please

+F:	samples/bpf/xdpsock*
+F:	tools/lib/bpf/xsk*



