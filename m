Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29FB2B2A05
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgKNAju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:39:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKNAju (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 19:39:50 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DA1D22265;
        Sat, 14 Nov 2020 00:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605314390;
        bh=SpS3AaCRszfjtzLS2DjxzA6kWHJvM5fL6BfBmsQ6ttE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sWH/0pOMIwAT6Qlq8HVYJFL3+cDF4x6I3TziVPhcnBLR8xa5puf5EOW8YaJgs3D12
         ZJLZmYWqMttq8QDBb0avha8N3ulgptFXU7a1kQKK81OOXMGugMzP9DsqehoWsV41G7
         Bs/flN4g6VZwbiXsWeHF+Z3u27MkAg7vCtLQrkTQ=
Date:   Fri, 13 Nov 2020 16:39:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] ICMPv6: define probe message types
Message-ID: <20201113163949.3bbb7391@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <55eb7b376f03af953f79810794c6349632189eae.1605303918.git.andreas.a.roeseler@gmail.com>
References: <cover.1605303918.git.andreas.a.roeseler@gmail.com>
        <55eb7b376f03af953f79810794c6349632189eae.1605303918.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 13:59:45 -0800 Andreas Roeseler wrote:
> The types of ICMPv6 Extended Echo Request and ICMPv6 Extended Echo Reply
> messages are defined by sections 2 adn 3 of RFC8335.
> 
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
>  include/uapi/linux/icmpv6.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/uapi/linux/icmpv6.h b/include/uapi/linux/icmpv6.h
> index c1661febc2dc..183a8b3feb92 100644
> --- a/include/uapi/linux/icmpv6.h
> +++ b/include/uapi/linux/icmpv6.h
> @@ -139,6 +139,12 @@ struct icmp6hdr {
>  #define ICMPV6_UNK_NEXTHDR		1
>  #define ICMPV6_UNK_OPTION		2
>  
> +/*
> + *	Codes for EXT_ECHO (Probe)
> + */
> +#define ICMPV6_EXT_ECHO_REQUEST		160
> +#define ICMPV6_EXT_ECHO_REPLY		161
> +
>  /*
>   *	constants for (set|get)sockopt
>   */

This patch does not apply to net-next [1]:

Applying: ICMPv6: define probe message types
error: patch failed: include/uapi/linux/icmpv6.h:139
error: include/uapi/linux/icmpv6.h: patch does not apply
Patch failed at 0003 ICMPv6: define probe message types
hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
fatal: It looks like 'git am' is in progress. Cannot rebase.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
