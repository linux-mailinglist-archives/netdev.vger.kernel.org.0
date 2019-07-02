Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBFF5D39B
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfGBPxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:53:18 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33371 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfGBPxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:53:18 -0400
Received: by mail-pg1-f194.google.com with SMTP id m4so7891720pgk.0
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 08:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cl0v8wIi5ckV/JFTMr62z9IJnCBwgq6PTLXNZySJFKE=;
        b=BshvCv0z48GDRlOe7wUUakEQ7WtAa6qqMxNiKS5VyGMORJhmGXBbwBb3fYxkLSIwfX
         t3IY+Mm2FOv7fSzVA361hclrSmxT8ykILSHq5gdRKnLKWyOJwW5DRfLgN+tmGPAIgLuG
         wmCaW/nIZWD2mwm+1eysoj200TWQVJlqjSVQyUWDGcu7jJ28U0LWQPX8MCz98yPjtdki
         cHC8f2S4FcWmxWZLQ64JzUEfcyy2zjRNbdtlFomOuWkANc47lZIA5LstyjRrI1imqOlJ
         j2DSqs9//sFGOHphCtCfUYZ7XwQxNIHYojoMsnGXdXNwAltpmEdUXzp9fd65+7EkV5ry
         ApdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cl0v8wIi5ckV/JFTMr62z9IJnCBwgq6PTLXNZySJFKE=;
        b=MK+GGY+SziWi1pM8q9ddwUhCfT4lxAS6SC6if622kqrRLXrkEphM6qBmlH8MNGDBOX
         0fxTRMx4hhcCO+eiM1S/vbugvbC/kMmz5GqbGSgNFqPhZnArjO9k151cGyL78Jz8pjw4
         anCxMzoV62RCcjmCf1cY7TCgiSn14DciEwIj8l2Yyo+N/Sws8MkBVn7CNjzjNXl2h5Hl
         6kyyHKnTQe6XIt2JXK4yiSmZR1oHXw2tYHFplcnzUG+saCmaxOHuMzHzhZpW6UpWZOAL
         08H1q1uV3fRDgrIXKjTHhbyn6am0rmPlaL9XdNMMTUQvRW4106OfL9W4dqIdRqZAC3wP
         0gDw==
X-Gm-Message-State: APjAAAXoJYoCiY8kJMfhCHZ67WM+IfNtZLumrs/GESCh2+s+bbQOW0Lq
        8au/dCdDKlg+Q0SjmBDjQ9o9VQ==
X-Google-Smtp-Source: APXvYqycrzymxcdSRUPnb+KLUWdFvBSdBC/+ZeideYCH3ZcxbIG30pYV4vOVAAIvgC9L4pK46S5UKA==
X-Received: by 2002:a63:d301:: with SMTP id b1mr207334pgg.379.1562082797621;
        Tue, 02 Jul 2019 08:53:17 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id m13sm11837936pgv.89.2019.07.02.08.53.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 08:53:17 -0700 (PDT)
Date:   Tue, 2 Jul 2019 08:53:16 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, sdf@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] bpf: cgroup: Fix build error without CONFIG_NET
Message-ID: <20190702155316.GJ6757@mini-arch>
References: <20190702132913.26060-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702132913.26060-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02, YueHaibing wrote:
> If CONFIG_NET is not set, gcc building fails:
> 
> kernel/bpf/cgroup.o: In function `cg_sockopt_func_proto':
> cgroup.c:(.text+0x237e): undefined reference to `bpf_sk_storage_get_proto'
> cgroup.c:(.text+0x2394): undefined reference to `bpf_sk_storage_delete_proto'
> kernel/bpf/cgroup.o: In function `__cgroup_bpf_run_filter_getsockopt':
> (.text+0x2a1f): undefined reference to `lock_sock_nested'
> (.text+0x2ca2): undefined reference to `release_sock'
> kernel/bpf/cgroup.o: In function `__cgroup_bpf_run_filter_setsockopt':
> (.text+0x3006): undefined reference to `lock_sock_nested'
> (.text+0x32bb): undefined reference to `release_sock'
> 
> Add CONFIG_NET dependency to fix this.
Can you share the config? Do I understand correctly that you have
CONFIG_NET=n and CONFIG_BPF=y? What parts of BPF do you expect to
work in this case?

Less invasive fix would be something along the lines:

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 76fa0076f20d..0a00eaca6fae 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -939,6 +939,7 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sysctl);
 
+#ifdef CONFIG_NET
 static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
 					     enum bpf_attach_type attach_type)
 {
@@ -1120,6 +1121,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	return ret;
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_getsockopt);
+#endif
 
 static ssize_t sysctl_cpy_dir(const struct ctl_dir *dir, char **bufp,
 			      size_t *lenp)
@@ -1386,10 +1388,12 @@ static const struct bpf_func_proto *
 cg_sockopt_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	switch (func_id) {
+#ifdef CONFIG_NET
 	case BPF_FUNC_sk_storage_get:
 		return &bpf_sk_storage_get_proto;
 	case BPF_FUNC_sk_storage_delete:
 		return &bpf_sk_storage_delete_proto;
+#endif
 #ifdef CONFIG_INET
 	case BPF_FUNC_tcp_sock:
 		return &bpf_tcp_sock_proto;

> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  init/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index e2e51b5..341cf2a 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -998,6 +998,7 @@ config CGROUP_PERF
>  config CGROUP_BPF
>  	bool "Support for eBPF programs attached to cgroups"
>  	depends on BPF_SYSCALL
> +	depends on NET
>  	select SOCK_CGROUP_DATA
>  	help
>  	  Allow attaching eBPF programs to a cgroup using the bpf(2)
> -- 
> 2.7.4
> 
> 
