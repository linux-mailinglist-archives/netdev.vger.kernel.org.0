Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F809350A2F
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhCaW0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhCaW0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 18:26:18 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A807C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 15:26:17 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id m7so286128pgj.8
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 15:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nnNBkMWu/3QbO3vZ8yjEgkaAeNqZ0CA+Kse5f3Dod70=;
        b=VrO0s2YqBtWHWw8bJik3cg2s+HIG6e7UdCLpSSiHg4+Xa/+T+Bm7WIE9bjMhTfPBxJ
         ESW+H914tM8qzSZ3WbdiCN2uEdA9xIhXOLMvXEG/p0lB6B/bW/ZI9US0kxhKSAaPX0f7
         NwS0SF71utPrVxLLCybWgqQp2gP+8rQaCDq37AcLMXTSAvgirffz5QvEwumjNnxHKUyp
         /uyNi/FL/93p7R1Bi3Th8JL1BC8gz94KJgpOITqOpqalPW2ffRBVNG8ixtHunjEoxOVw
         wmYJ34yltjUNunCW/McK6M6KIUHs9IpvbVGul2oErf8mbgbEi5bvk9JBs9NlWZeVoqKp
         zyPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nnNBkMWu/3QbO3vZ8yjEgkaAeNqZ0CA+Kse5f3Dod70=;
        b=G4fLOi+oQ4VKCXnjOkOItZuLdT3q8mzrfUw+r8IXKuoGhPVpfmZPUGjNHYcF3EQq3X
         7VB5Liqf1J+QELeP3ttBOwHYoafGTqE86SyQCz7c48UNOWWFc5hc4bMRyQaECfo8hfcb
         bwJX6iyiadGFKO3DMxAl2Q2pbD+eV0J2aB33vQGyF5lGXMKNRdHrO50sYIGgyzGIvs+6
         LQAOSLjRBl7CFfMIDx2PDWmDtcXGxsLvJI6yloh2STpAD7FGSbW3hoWLComQj34hmtu9
         vZ+2UtMff8FXZjVItKXdOmYOkwSMc/F5t0xOy4ItqWSSQk6SbgDMOzSFqawCbUuRYQiz
         GX4Q==
X-Gm-Message-State: AOAM530Teoy+R/FmqU/NTlrbHVzEtJ655Ca5OaKnFS8cjvjfR6NpGL/M
        YLJx60ri+HztFTmuGJcq1QgP/h8wxKWMBg==
X-Google-Smtp-Source: ABdhPJzdp/Sf3lw/SSuBSjEN1AS4dbOSMFbY8jIHtTosX6p/V1BxW5+QTsCRMjLEJmvXqf/HF5O3Kw==
X-Received: by 2002:a62:2a07:0:b029:214:fd95:7f7 with SMTP id q7-20020a622a070000b0290214fd9507f7mr4926260pfq.60.1617229576740;
        Wed, 31 Mar 2021 15:26:16 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id z8sm3209309pjd.0.2021.03.31.15.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 15:26:16 -0700 (PDT)
Date:   Wed, 31 Mar 2021 15:26:02 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Hongren Zheng <i@zenithal.me>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] iptoken: Add doc on the conditions of iptoken
Message-ID: <20210331152602.50cc4a79@hermes.local>
In-Reply-To: <YF80x4bBaXpS4s/W@Sun>
References: <YF80x4bBaXpS4s/W@Sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Mar 2021 21:36:07 +0800
Hongren Zheng <i@zenithal.me> wrote:

> `ip token set suffix dev interface' may be unsuccessful
> with only the error 'RTNETLINK answers: Invalid argument'
> prompted. For users this is mysterious and hard to debug.
> Hence a more user-friendly prompt is added.
> 
> This commit adds doc for conditions for setting the token and
> making the token take effect. For the former one, conditions
> in the function 'inet6_set_iftoken' of 'net/ipv6/addrconf.c'
> of the Linux kernel code is documented.
> 
> For the latter one, conditions in the function 'addrconf_prefix_rcv'
> of 'net/ipv6/addrconf.c' of the Linux kernel code is docuemnted.
> 
> Signed-off-by: Hongren Zheng <i@zenithal.me>
> ---
>  ip/iptoken.c        |  4 +++-
>  man/man8/ip-token.8 | 24 ++++++++++++++++++++++++
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/ip/iptoken.c b/ip/iptoken.c
> index 9f356890..d56fd68d 100644
> --- a/ip/iptoken.c
> +++ b/ip/iptoken.c
> @@ -177,8 +177,10 @@ static int iptoken_set(int argc, char **argv, bool delete)
>  	addattr_nest_end(&req.n, afs6);
>  	addattr_nest_end(&req.n, afs);
>  
> -	if (rtnl_talk(&rth, &req.n, NULL) < 0)
> +	if (rtnl_talk(&rth, &req.n, NULL) < 0) {
> +		fprintf(stderr, "Conditions not met: 'man ip-token' for more info\n");
>  		return -2;
> +	}
>  
>  	return 0;
>  }
> diff --git a/man/man8/ip-token.8 b/man/man8/ip-token.8
> index 6505b8c5..ac64eb66 100644
> --- a/man/man8/ip-token.8
> +++ b/man/man8/ip-token.8
> @@ -67,6 +67,30 @@ must be left out.
>  list all tokenized interface identifiers for the networking interfaces from
>  the kernel.
>  
> +.SH "NOTES"
> +Several conditions should be met before setting the token for an interface.
> +.RS
> +.IP A
> +\- The interface is not a loopback device.
> +.IP B
> +\- The interface does not have NOARP flag.
> +.IP C
> +\- The interface accepts router advertisement (RA). To be more specific,
> +net.ipv6.conf.interface.accept_ra=1,
> +and when net.ipv6.conf.interface.forwarding=1,
> +net.ipv6.conf.interface.accept_ra=2.
> +.RE
> +
> +For the token to take effect, several conditions should be met.
> +.RS
> +.IP A
> +\- The interface has autoconf flag turned on. To be more specific, net.ipv6.conf.interface.autoconf=1
> +.IP B
> +\- The router advertisement (RA) has autonomous address-configuration flag turned on.
> +.IP C
> +\- The length of the prefix in the router advertisement (RA) is 64.
> +.RE
> +
>  .SH SEE ALSO
>  .br
>  .BR ip (8)

It would be better if kernel provided the error messages through external ack
of the netlink message, rather than providing potentially out of date
recommendations on the man page.


