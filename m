Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5762A2E7B
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 16:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgKBPlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgKBPlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 10:41:12 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7063DC0617A6;
        Mon,  2 Nov 2020 07:41:12 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id a20so13300840ilk.13;
        Mon, 02 Nov 2020 07:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9Z71+CRHeSSYfHh/rdABmuoHOyi/fRlH7aLBxC2yDpU=;
        b=iSWetLUMc7RYDMQf5wr2cews90QZqJUKFaGXZ5iccbb/Qq6vxKAI2fsK+HrKyq2WrY
         HCLym+/7eZrauEfvsp3rJ0xLkajaMPmpeo3Lwfs+Bz+kOpNcBJnO0izJKZ7fh3unelnF
         d2uwS5+rNylKpfVEUmguS9RL8gisWele/+s5eGJMs6UEis2nRekRcALmwHflutfmOEIk
         nJFoM+KQ2AO7J+b9VekcMfIY6MsPbQJTpAg4Ucj/pyLeAEtEEIl9sRRohe+gnwdGkQd2
         E9q9IeCsSHuqwy5yKjpY68kIHhw/dHkS4zNj+lip4EfmdkQcTtJgivuuykvXFVnG5nUg
         D1IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Z71+CRHeSSYfHh/rdABmuoHOyi/fRlH7aLBxC2yDpU=;
        b=JTqpsSMKdOGbJ52qV/HHeMKUXDuqFBK6OPOgLwFqUtkRU4FabDroczfwuwk7o84S8q
         Ry2XUC5o/Nw5RVr3VeJN5ejPSAQKn7+Wsf8OFJzME4EUIqbRTJzD67ZEtCddOLiFQixM
         t+0zjVhGm9mEMa9Bt0ApdM8fHmwVYJPTRAn9Q1eRVNGWz+BNQ1cKF0uvuZT5cvFnyn4q
         CFo/6ciytEnTjFNqHxfSwoAgdilQGfMRX7CMUYi1X2e/GTsBiXC7FUNhTG+f14I8pc0C
         vRUa14jllctDkXjj2KKN2oZSXXwKMeVeQdDLciPW4LaigmWVlWLcjxER1mRlz5iVUdHa
         dMDA==
X-Gm-Message-State: AOAM530NyBh6wQAwLeDZ2FLC84Ob6aySiq7SWm1R4Vd2wP/+D8dGMqJM
        73HT13TK/Ooemc82fXfkC0I=
X-Google-Smtp-Source: ABdhPJxV61ZiI7s8SbvcMnnKq+94/IApK6HApTDx6Sj5KuzesYwg0evJj3jEJOTGUpPGx0B5tW+4xw==
X-Received: by 2002:a05:6e02:52c:: with SMTP id h12mr10997668ils.196.1604331671827;
        Mon, 02 Nov 2020 07:41:11 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4ca9:ddcf:e3b:9c54])
        by smtp.googlemail.com with ESMTPSA id r17sm9499041iov.7.2020.11.02.07.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 07:41:11 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 3/5] lib: add libbpf support
To:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <20201029151146.3810859-4-haliu@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <db14a227-1d5e-ed3a-9ada-ecf99b526bf6@gmail.com>
Date:   Mon, 2 Nov 2020 08:41:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201029151146.3810859-4-haliu@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/20 9:11 AM, Hangbin Liu wrote:
> diff --git a/ip/ipvrf.c b/ip/ipvrf.c
> index 33150ac2..afaf1de7 100644
> --- a/ip/ipvrf.c
> +++ b/ip/ipvrf.c
> @@ -28,8 +28,14 @@
>  #include "rt_names.h"
>  #include "utils.h"
>  #include "ip_common.h"
> +
>  #include "bpf_util.h"
>  
> +#ifdef HAVE_LIBBPF
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +#endif
> +
>  #define CGRP_PROC_FILE  "/cgroup.procs"
>  
>  static struct link_filter vrf_filter;
> @@ -256,8 +262,13 @@ static int prog_load(int idx)
>  		BPF_EXIT_INSN(),
>  	};
>  
> +#ifdef HAVE_LIBBPF
> +	return bpf_load_program(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
> +				"GPL", 0, bpf_log_buf, sizeof(bpf_log_buf));
> +#else
>  	return bpf_prog_load_buf(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
>  			         "GPL", bpf_log_buf, sizeof(bpf_log_buf));
> +#endif
>  }
>  
>  static int vrf_configure_cgroup(const char *path, int ifindex)
> @@ -288,7 +299,11 @@ static int vrf_configure_cgroup(const char *path, int ifindex)
>  		goto out;
>  	}
>  
> +#ifdef HAVE_LIBBPF
> +	if (bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_INET_SOCK_CREATE, 0)) {
> +#else
>  	if (bpf_prog_attach_fd(prog_fd, cg_fd, BPF_CGROUP_INET_SOCK_CREATE)) {
> +#endif
>  		fprintf(stderr, "Failed to attach prog to cgroup: '%s'\n",
>  			strerror(errno));
>  		goto out;

I would prefer to have these #ifdef .. #endif checks consolidated in the
lib code. Create a bpf_compat file for these. e.g.,

int bpf_program_load(enum bpf_prog_type type, const struct bpf_insn *insns,
                     size_t size_insns, const char *license, char *log,
                     size_t size_log)
{
+#ifdef HAVE_LIBBPF
+	return bpf_load_program(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
+				"GPL", 0, bpf_log_buf, sizeof(bpf_log_buf));
+#else
 	return bpf_prog_load_buf(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
 			         "GPL", bpf_log_buf, sizeof(bpf_log_buf));
+#endif
}

Similarly for bpf_program_attach.


I think even the includes can be done once in bpf_util.h with a single
+#ifdef HAVE_LIBBPF
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#endif
+

The iproute2_* functions added later in this patch can be in the compat
file as well.
