Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015EB2C8AE5
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 18:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387524AbgK3R0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 12:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387520AbgK3R0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 12:26:04 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107EAC0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 09:25:24 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id k3so4708072ioq.4
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 09:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QHeX9XMfAhQejgr8sV/YZcZS6hSeF26K1lfoLRbRWsg=;
        b=kuTT87qGYKNXQPSmMsRnhslGGISuZm0Ezme6NYWbGCpJO2Tn4WfuHBROJfHexnp8bw
         jSwt8tqA9crSMtEPMypsomEw2h6rR2oiImHThrWZpigYeJbmmWT0dOSAWyEaKAY4P3L6
         iDkdRjnDzW5EzC9U5LXF+rlk1tBgJQibg1IP7oRfapB5/yOOLRg6laMMmDO1hH90/xuW
         ipM56IU+7Vn6GPvucOObHkaaLrBDZ66BnTC7f+/xV8neRaCnIjHc9q2KKP/fvYfO3Iqv
         jSPHI0/VXju8nOaCUwg5zTYgoU797/wMqS8+chuX3MDOrpscXAHjo0TvwQUAHn115ShO
         0iaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QHeX9XMfAhQejgr8sV/YZcZS6hSeF26K1lfoLRbRWsg=;
        b=TjF+9OGH8skC7Z3jUxs1Z8MMbiGfuyv1rZr1FTnjC8ck2x2hP0Y0JfEeQ6u8TXhGWA
         KpnVL2sw1731ZQnvaysxGQaFjQ426sSGi/W4BuxPPL1XfYtPC/eNKlZYAHxc8ZQthHRJ
         nkedjeEFQU3P2gnWees84hYndMGkL+gO0Kig4HgSF+GNb1crGqdWcbXCeb/k77yfTY8H
         JsXyGr9Kt3iT/dqT5RSxT4sDSnD+ACyKtU8AvsRrqqV/QulGaO94wxVViHyWGKdY/0+M
         /4sbF/GX27KZLKcXSh87JuRZTcorhLLXyxMKoP7XBtn0Gw2CKRLurSP8wIOxK93xeH4R
         Tm1A==
X-Gm-Message-State: AOAM532eVV6zScedUY7NL/ejAbkUfMkzGaIGvEA81kks1yB0bl1pIGBM
        sv+r/3B/H7i/cmbcEqbwk6I=
X-Google-Smtp-Source: ABdhPJwm9fcWnkaCd7/yMNtGucYWLHWwNdvemHoybwx0Do4O9YfsTh9p0qI0Vj7sg8KmxsMWtjojhw==
X-Received: by 2002:a6b:5911:: with SMTP id n17mr7629374iob.34.1606757123469;
        Mon, 30 Nov 2020 09:25:23 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:f4ef:fcd1:6421:a6de])
        by smtp.googlemail.com with ESMTPSA id t26sm8201320ioi.11.2020.11.30.09.25.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 09:25:22 -0800 (PST)
Subject: Re: [PATCH iproute2-next] ip: add IP_LIB_DIR environment variable
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20201122173921.31473-1-ryazanov.s.a@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0863b383-cd6a-1898-3556-bc519e2b0cf4@gmail.com>
Date:   Mon, 30 Nov 2020 10:25:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201122173921.31473-1-ryazanov.s.a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ sorry, this got lost in the backlog ]

On 11/22/20 10:39 AM, Sergey Ryazanov wrote:
> Do not hardcode /usr/lib/ip as a path and allow libraries path
> configuration in run-time.
> 
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> ---
>  ip/ip.c        | 15 +++++++++++++++
>  ip/ip_common.h |  2 ++
>  ip/iplink.c    |  5 +----
>  3 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/ip/ip.c b/ip/ip.c
> index 5e31957f..38600e51 100644
> --- a/ip/ip.c
> +++ b/ip/ip.c
> @@ -25,6 +25,10 @@
>  #include "color.h"
>  #include "rt_names.h"
>  
> +#ifndef LIBDIR
> +#define LIBDIR "/usr/lib"
> +#endif
> +
>  int preferred_family = AF_UNSPEC;
>  int human_readable;
>  int use_iec;
> @@ -41,6 +45,17 @@ bool do_all;
>  
>  struct rtnl_handle rth = { .fd = -1 };
>  
> +const char *get_ip_lib_dir(void)
> +{
> +	const char *lib_dir;
> +
> +	lib_dir = getenv("IP_LIB_DIR");
> +	if (!lib_dir)
> +		lib_dir = LIBDIR "/ip";
> +
> +	return lib_dir;
> +}
> +
>  static void usage(void) __attribute__((noreturn));
>  
>  static void usage(void)
> diff --git a/ip/ip_common.h b/ip/ip_common.h
> index d604f755..227eddd3 100644
> --- a/ip/ip_common.h
> +++ b/ip/ip_common.h
> @@ -27,6 +27,8 @@ struct link_filter {
>  	int target_nsid;
>  };
>  
> +const char *get_ip_lib_dir(void);
> +
>  int get_operstate(const char *name);
>  int print_linkinfo(struct nlmsghdr *n, void *arg);
>  int print_addrinfo(struct nlmsghdr *n, void *arg);
> diff --git a/ip/iplink.c b/ip/iplink.c
> index d6b766de..4250b2c3 100644
> --- a/ip/iplink.c
> +++ b/ip/iplink.c
> @@ -34,9 +34,6 @@
>  #include "namespace.h"
>  
>  #define IPLINK_IOCTL_COMPAT	1
> -#ifndef LIBDIR
> -#define LIBDIR "/usr/lib"
> -#endif
>  
>  #ifndef GSO_MAX_SIZE
>  #define GSO_MAX_SIZE		65536
> @@ -157,7 +154,7 @@ struct link_util *get_link_kind(const char *id)
>  		if (strcmp(l->id, id) == 0)
>  			return l;
>  
> -	snprintf(buf, sizeof(buf), LIBDIR "/ip/link_%s.so", id);
> +	snprintf(buf, sizeof(buf), "%s/link_%s.so", get_ip_lib_dir(), id);
>  	dlh = dlopen(buf, RTLD_LAZY);
>  	if (dlh == NULL) {
>  		/* look in current binary, only open once */
> 

What's the use case for needing this? AIUI this is a legacy feature from
many years ago.

All of the link files are builtin, so this is only useful for out of
tree modules. iproute2 should not be supporting such an option, so
really this code should be ripped out, not updated.
