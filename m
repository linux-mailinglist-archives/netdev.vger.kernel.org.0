Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FC83092E8
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbhA3JJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:09:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233877AbhA3JIM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 04:08:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3EEB64E12;
        Sat, 30 Jan 2021 08:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611995775;
        bh=7gLJ+o3JkB0eusHgIumir48OcUHn9KEhZX0kSm0JRsA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M+EwpS8FIewCm/f+P8zSYKaJlN4cHIKfhIN0y5sETN+vuRe6xhT8GnbQvWh2HO4Yn
         we2HiB7jTvyzjAufQi+U06Zm+KONRdOeEL7oJEXN6xewPeeBLqMePwq6EtJpdOARYA
         f6EPghB5MAI5/5MC/haF5mktiAiXZTejTReCGMaE=
Date:   Sat, 30 Jan 2021 09:36:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aviraj CJ <acj@cisco.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xe-linux-external@cisco.com, Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [Internal review][PATCH stable v5.4 1/2] ICMPv6: Add ICMPv6
 Parameter Problem, code 3 definition
Message-ID: <YBUafB76nbydgXv+@kroah.com>
References: <20210129192741.117693-1-acj@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129192741.117693-1-acj@cisco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 12:57:40AM +0530, Aviraj CJ wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> 
> commit b59e286be280fa3c2e94a0716ddcee6ba02bc8ba upstream.
> 
> Based on RFC7112, Section 6:
> 
>    IANA has added the following "Type 4 - Parameter Problem" message to
>    the "Internet Control Message Protocol version 6 (ICMPv6) Parameters"
>    registry:
> 
>       CODE     NAME/DESCRIPTION
>        3       IPv6 First Fragment has incomplete IPv6 Header Chain
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Aviraj CJ <acj@cisco.com>
> ---
>  include/uapi/linux/icmpv6.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/icmpv6.h b/include/uapi/linux/icmpv6.h
> index 2622b5a3e616..9a31ea2ad1cf 100644
> --- a/include/uapi/linux/icmpv6.h
> +++ b/include/uapi/linux/icmpv6.h
> @@ -137,6 +137,7 @@ struct icmp6hdr {
>  #define ICMPV6_HDR_FIELD		0
>  #define ICMPV6_UNK_NEXTHDR		1
>  #define ICMPV6_UNK_OPTION		2
> +#define ICMPV6_HDR_INCOMP		3
>  
>  /*
>   *	constants for (set|get)sockopt
> -- 
> 2.26.2.Cisco
> 

What do you mean by "internal review" and what am I supposed to do with
this patch?  Same for the 2/2 patch in this series...

thanks,

greg k-h
