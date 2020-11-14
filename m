Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FD42B2F38
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 18:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgKNRqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 12:46:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbgKNRqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 12:46:51 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F3D122254;
        Sat, 14 Nov 2020 17:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605376011;
        bh=avposLBN+IH40C43UJv8twYBQQ/80T9BU11WlpgW03A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NZ3PVX6xAAj9lE1HGwyWYUe16cQoibKxTNH6YsMmzKzF/9mhd92s4k1SrrYftWClx
         cBBLYee6WtIez2qVnw4pocuJILjdfiyqjoA3z/SJxLgircJNmFIoWd0GsyvLFHLX17
         /Av8miUcYPqkrOtyjgu5CVJANKQw8v5WuInRCOSY=
Date:   Sat, 14 Nov 2020 09:46:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 3/3] ICMPv6: define probe message types
Message-ID: <20201114094650.2666c2a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <03d35bcb7aa843ede4fb3bc224b7eba85c12d522.1605323689.git.andreas.a.roeseler@gmail.com>
References: <cover.1605323689.git.andreas.a.roeseler@gmail.com>
        <03d35bcb7aa843ede4fb3bc224b7eba85c12d522.1605323689.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 19:24:17 -0800 Andreas Roeseler wrote:
> The types of ICMPV6 Extended Echo Request and ICMPV6 Extended Echo Reply
> are defined in sections 2 and 3 of RFC8335.
> 
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>

> diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
> index ba45e6bc076..c6186774584 100644
> --- a/include/linux/icmpv6.h
> +++ b/include/linux/icmpv6.h
> @@ -137,6 +137,12 @@ static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)
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

Hm, quite strange. The context we're seeing here was removed 8 years
ago by:

commit 607ca46e97a1b6594b29647d98a32d545c24bdff
Author: David Howells <dhowells@redhat.com>
Date:   Sat Oct 13 10:46:48 2012 +0100

    UAPI: (Scripted) Disintegrate include/linux

Are you sure you are on the right tree?
