Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983D51728F6
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 20:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgB0Tww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 14:52:52 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38069 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729611AbgB0Twv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 14:52:51 -0500
Received: by mail-qt1-f195.google.com with SMTP id e20so227682qto.5
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 11:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UrXJ07Jeh6oTEGUnZQCOBfkLqNiCCp1m604IynhLWSo=;
        b=ENdMa3TJ+cY8tFUF85RgFHscx3rDL/HYmLrknVkEbFqeeQn2TcK+MK7K7XMPHevpqp
         eHsR7xLX1UdZhj6LGM1r1qrXR7wk6xaod4UQaATIP4ZMfdwPjLSpneVf44O4wlT7q3Tu
         KGLXPjuf/c590i4ybvcSD4qVxVxPOCKRAmJKXOS2Ogy65DeOQkvAtslG0hhoEKAXz9m1
         EUFT3qbTBmnh/qk+vqA/bmHcE3brgXWUGubL7fU0HS5Zb8/q9nWrv+16sdboa2CndoDn
         MwRMdJDl3g9kXZzQs/8fjb3cFhAg8RiWTa5Eg91ibjEozFNJ6CO507pRmCX2od+m9zIh
         znVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UrXJ07Jeh6oTEGUnZQCOBfkLqNiCCp1m604IynhLWSo=;
        b=Cn3dVTg5+zpqSDnSgX8cZLRnYlgL/4GC4NdBLlBGxSQVhKMv2W9NGTgw+WBdxNu5HM
         /xd5aLZGDOZG4LXczfZGHSrrSEBJgUM6foqoPsXuBFhbX6IA280I47KrsEbeG7tR2kVv
         pAEQ4GJZeEA6M2XfgCJ9Vb5cViz5Y99FBaqPSYvOGJITxr1SGQuFCCFLB+Zci5d+5XxN
         ejkIbhCz0TUJi6/8My2KLjuaQ5qPepCZ2xok08eMV+PQ3F/3gppCsV+gc1dpFuEyrigi
         wyTc4l2ndJx5cshhu0EOMaS8MchrG1620YTTdIJTK1OUgtgkA5nlZ9zB4wadZ64jO8Sq
         slhQ==
X-Gm-Message-State: APjAAAVsJkdAxvfm8qAOnIBk/eiC95u9iA3Mm8kfIeCjXENg4vTjnRlo
        esChB6l2MOKRY3DGYWGY3JA=
X-Google-Smtp-Source: APXvYqytfkmLVnTCK0sGSL2roDBTgV3yQNLPxyG6ArvgME2xCIJmrcIqEoeh2QpuSmzI37Ti86QQzQ==
X-Received: by 2002:ac8:664f:: with SMTP id j15mr926397qtp.267.1582833170933;
        Thu, 27 Feb 2020 11:52:50 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:a58e:e5e0:4900:6bcd? ([2601:282:803:7700:a58e:e5e0:4900:6bcd])
        by smtp.googlemail.com with ESMTPSA id i64sm1934302qke.56.2020.02.27.11.52.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 11:52:50 -0800 (PST)
Subject: Re: [PATCH iproute2] man: ip.8: Add missing vrf subcommand
 description
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <acd21cee80dfcb99c131059a8e393b6a62de0d64.1582821904.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6bda808c-6b12-ab47-5823-a07a32c86810@gmail.com>
Date:   Thu, 27 Feb 2020 12:52:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <acd21cee80dfcb99c131059a8e393b6a62de0d64.1582821904.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/20 9:45 AM, Andrea Claudi wrote:
> Add description to the vrf subcommand and a reference to the
> dedicated man page.
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  man/man8/ip.8 | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 

Thanks for adding.

Reviewed-by: David Ahern <dsahern@gmail.com>


> diff --git a/man/man8/ip.8 b/man/man8/ip.8
> index 1661aa678f7b2..1613f790a14b2 100644
> --- a/man/man8/ip.8
> +++ b/man/man8/ip.8
> @@ -22,7 +22,7 @@ ip \- show / manipulate routing, network devices, interfaces and tunnels
>  .BR link " | " address " | " addrlabel " | " route " | " rule " | " neigh " | "\
>   ntable " | " tunnel " | " tuntap " | " maddress " | "  mroute " | " mrule " | "\
>   monitor " | " xfrm " | " netns " | "  l2tp " | "  tcp_metrics " | " token " | "\
> - macsec " }"
> + macsec " | " vrf " }"
>  .sp
>  
>  .ti -8
> @@ -312,6 +312,10 @@ readability.
>  .B tuntap
>  - manage TUN/TAP devices.
>  
> +.TP
> +.B vrf
> +- manage virtual routing and forwarding devices.
> +
>  .TP
>  .B xfrm
>  - manage IPSec policies.
> @@ -410,6 +414,7 @@ was written by Alexey N. Kuznetsov and added in Linux 2.2.
>  .BR ip-tcp_metrics (8),
>  .BR ip-token (8),
>  .BR ip-tunnel (8),
> +.BR ip-vrf (8),
>  .BR ip-xfrm (8)
>  .br
>  .RB "IP Command reference " ip-cref.ps
> 

