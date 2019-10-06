Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26DA3CD1F8
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 15:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfJFNAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 09:00:37 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34658 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfJFNAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 09:00:37 -0400
Received: by mail-ed1-f68.google.com with SMTP id p10so9975586edq.1
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 06:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4oeU6G9etNS3vLvXtCz0JCbt0CzSepxL7D2cW0lcQH8=;
        b=Dtwjytc8O3bW3qam/SMyCFN/gwS3+jBD0BivXJ6xRS6/frAruDNkAiVO/bISJMAvmG
         htpErpdqTklEg/qIaWZnY2xBp6NfRcWm6FAhgxy4WtZTeSwdHGKpX6J5VwQtusMHbTQW
         oT3jvXbZ8FlTu+2qGZw+iuQ1PSFlaXeutZqPFl09GC8+at3V+1Hx56251/m7qL9rLbOW
         yVf3il0oMD/Ul0PqsxcFf3uv0X/BkfUjIoajwRfcP+/ky2XHMEWsB6+VAL0+zEslrGes
         84D035rBa2Pjg1BdYoNmBgQRVtFSJMKhW5GGnbmYw70atHpq7Mi6CuWhij0N+wljfaO3
         1+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4oeU6G9etNS3vLvXtCz0JCbt0CzSepxL7D2cW0lcQH8=;
        b=fh3mXhQqgzLDI731FoCHKhY/7DemRZmMOxsArxx3L9seUAQqtg5MrEdxgrB6kcrp51
         MPZLeBIpgEYAa4fYbm+Fw2llkv+FMqNRZpqha2kmKc5CeSMqRXNM/TAt9reFwqO3s3UZ
         SLSyRKuGH2hzx1x+Ek0yqSol+LpHWgVouVw5493lpdeI9wX/cvfuJ4NQKgWVsi3FDZEd
         sOACfIZYyd6lFoaGEfWfLDjhAL0kXZP1j2SfJKjxknlYf9MMmvbnktccFBen2pTX7pP6
         YAisZHt4/ri1T+d8IRhOsXcUYx7Q3PycQmWqK8pC/A3b0zY1Jp1jxvOPJbl/ejld+8V7
         bzUg==
X-Gm-Message-State: APjAAAXTYDDZ423PVv93X9zeu+MkbgBvgghvsoR7cAGAksrlR4sMip7a
        rROrcIVkbMVmFMUmHlmws5I6BVeu/Io=
X-Google-Smtp-Source: APXvYqzUV9DjBeAd9MrmhA/d1OHCVN7c6tomi77Nj+8QIDkJ4jn8OoVgzHVZd6SRKz42X1eAJNVkTw==
X-Received: by 2002:a17:906:6805:: with SMTP id k5mr19510358ejr.50.1570366835434;
        Sun, 06 Oct 2019 06:00:35 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id t30sm2775802edt.91.2019.10.06.06.00.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 06 Oct 2019 06:00:34 -0700 (PDT)
Date:   Sun, 6 Oct 2019 15:00:32 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Tom Herbert <tom@quantonium.net>
Subject: Re: [PATCH v5 net-next 2/7] ipeh: Move generic EH functions to
 exthdrs_common.c
Message-ID: <20191006130030.rv4tjcu2qkk7baf6@netronome.com>
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
 <1570139884-20183-3-git-send-email-tom@herbertland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570139884-20183-3-git-send-email-tom@herbertland.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 02:57:59PM -0700, Tom Herbert wrote:
> From: Tom Herbert <tom@quantonium.net>
> 
> Move generic functions in exthdrs.c to new exthdrs_common.c so that
> exthdrs.c only contains functions that are specific to IPv6 processing,
> and exthdrs_common.c contains functions that are generic. These
> functions include those that will be used with IPv4 extension headers.
> Generic extension header related functions are prefixed by ipeh_.
> 
> Signed-off-by: Tom Herbert <tom@herbertland.com>

...

> diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> index 25aab67..b8843c1 100644
> --- a/net/dccp/ipv6.c
> +++ b/net/dccp/ipv6.c
> @@ -515,7 +515,7 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
>  	if (!opt)
>  		opt = rcu_dereference(np->opt);
>  	if (opt) {
> -		opt = ipv6_dup_options(newsk, opt);
> +		opt = ipeh_dup_options(newsk, opt);
>  		RCU_INIT_POINTER(newnp->opt, opt);
>  	}
>  	inet_csk(newsk)->icsk_ext_hdr_len = 0;
> diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
> index ae1344e..700fcea 100644
> --- a/net/ipv6/Kconfig
> +++ b/net/ipv6/Kconfig
> @@ -3,9 +3,13 @@
>  # IPv6 configuration
>  #
>  
> +config EXTHDRS
> +	bool
> +
>  #   IPv6 as module will cause a CRASH if you try to unload it
>  menuconfig IPV6
>  	tristate "The IPv6 protocol"
> +	select EXTHDRS
>  	default y
>  	---help---
>  	  Support for IP version 6 (IPv6).

Hi Tom,

could you expand on the motivation for this new Kconfig symbol.
It seems that at this time exthdrs_common.o could simply depend on IPV6.

Otherwise this patch seems fine to me.

> diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
> index df3919b..0bcab81 100644
> --- a/net/ipv6/Makefile
> +++ b/net/ipv6/Makefile
> @@ -44,6 +44,7 @@ obj-$(CONFIG_IPV6_SIT) += sit.o
>  obj-$(CONFIG_IPV6_TUNNEL) += ip6_tunnel.o
>  obj-$(CONFIG_IPV6_GRE) += ip6_gre.o
>  obj-$(CONFIG_IPV6_FOU) += fou6.o
> +obj-$(CONFIG_EXTHDRS) += exthdrs_common.o
>  
>  obj-y += addrconf_core.o exthdrs_core.o ip6_checksum.o ip6_icmp.o
>  obj-$(CONFIG_INET) += output_core.o protocol.o $(ipv6-offload)

...
