Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D84516994
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 05:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346947AbiEBDem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 23:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbiEBDek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 23:34:40 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4714D64E5;
        Sun,  1 May 2022 20:31:13 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id g6so25539743ejw.1;
        Sun, 01 May 2022 20:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wUqXzBeFEsDrc5ibIJLNWC7b6ZPsu9hMCM0ez1Zi5wc=;
        b=iU77RsSZOrmcHoZK9CQEATY2m29clBJxiS1rYOez7jD+9DzreAp+6wWJMS+4HQEqfT
         AE03j8qZlJLSkTSH7WAaVPqQm2BygCRXFvouqDi4AhqAaSH/pxLslYxnVP1ncorP7pQO
         zzuPqasP1cqizGwDZ/7uoVsVzqFwdcxOR4xCG1W+Oz+6SNbc/PQ83A+jtsPJ3h7bj4/i
         jFswD/v5U4s8B/R+LBtIX4ajmgEM39F4dzUAQ8wOp1MGMzpu6qeXtU1Ctqa7ofv4SJSo
         uyjbBe6gZuvqabax3CF/jl+kQd6bzVF15y3J/jiVFTZUuCee1v0MrCvrxvm8dxc7WpY/
         taaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wUqXzBeFEsDrc5ibIJLNWC7b6ZPsu9hMCM0ez1Zi5wc=;
        b=5smilJtlY2YWwPP8tRsUq2bEWjHmvIsszKf6LfxMnz2s/onadWvxvHR1OxrOa2tLz/
         CNcLcrG9pDh6Xwj5GEePGKA4uM7W+D/CrNKkfSU6veJjPsgkdRujI6UdjsrjNgPSNz+z
         RS55o4aykSTIgYg5QiBESf1Twan1l8Cg8h1ccgiLM84ralI6knF/yFdBqI2hwrGujtYX
         OljzCO226EPDwFVCH/2xcsKovKbyVpnYdU4rXSDUfOr/jZzDbl+PKLBqE3+4F4PHirHc
         Wgwqq2Qhyl53eOnBAize8ta/b0HmsVO6oq87hxZehy07pBPxS8S50WRm0VJEuRYeTRFM
         JdSg==
X-Gm-Message-State: AOAM5324k/4iIOpMPFj6B27i10qNAVKhKspZeS4OHSXMQ69yZRcC4TtF
        z5X5jUGQrZJoWiEgZA/bqLzWGxYaRldcj5T2W1eU58SRRSvbyQ==
X-Google-Smtp-Source: ABdhPJydmRr2I7cWSvYLptLKn8O1vb6z2JLBHKQwD3RiR9UfCNtsj8ke3fjrOYJj8eqCdvfylMbnrv5OJOv3mAgUjFU=
X-Received: by 2002:a17:907:d22:b0:6f4:7bb:d53e with SMTP id
 gn34-20020a1709070d2200b006f407bbd53emr9455869ejc.251.1651462271429; Sun, 01
 May 2022 20:31:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220501035524.91205-1-xiangxia.m.yue@gmail.com> <20220501035524.91205-3-xiangxia.m.yue@gmail.com>
In-Reply-To: <20220501035524.91205-3-xiangxia.m.yue@gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 2 May 2022 11:30:35 +0800
Message-ID: <CAMDZJNX0tm+krFb+Nr9Emy4UBg3niGg1y88Y2hTd37ByLGhkQA@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] net: sysctl: introduce sysctl SYSCTL_THREE
To:     linux-fsdevel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 1, 2022 at 11:56 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This patch introdues the SYSCTL_THREE.
>
> KUnit:
> [00:10:14] ================ sysctl_test (10 subtests) =================
> [00:10:14] [PASSED] sysctl_test_api_dointvec_null_tbl_data
> [00:10:14] [PASSED] sysctl_test_api_dointvec_table_maxlen_unset
> [00:10:14] [PASSED] sysctl_test_api_dointvec_table_len_is_zero
> [00:10:14] [PASSED] sysctl_test_api_dointvec_table_read_but_position_set
> [00:10:14] [PASSED] sysctl_test_dointvec_read_happy_single_positive
> [00:10:14] [PASSED] sysctl_test_dointvec_read_happy_single_negative
> [00:10:14] [PASSED] sysctl_test_dointvec_write_happy_single_positive
> [00:10:14] [PASSED] sysctl_test_dointvec_write_happy_single_negative
> [00:10:14] [PASSED] sysctl_test_api_dointvec_write_single_less_int_min
> [00:10:14] [PASSED] sysctl_test_api_dointvec_write_single_greater_int_max
> [00:10:14] =================== [PASSED] sysctl_test ===================
>
> ./run_kselftest.sh -c sysctl
> ...
> ok 1 selftests: sysctl: sysctl.sh
>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Iurii Zaikin <yzaikin@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Julian Anastasov <ja@ssi.bg>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: Akhmat Karakotov <hmukos@yandex-team.ru>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Reviewed-by: Simon Horman <horms@verge.net.au>

v4 version, Simon added this tag. I miss this tag in v5.
> ---
>  fs/proc/proc_sysctl.c          | 2 +-
>  include/linux/sysctl.h         | 9 +++++----
>  net/core/sysctl_net_core.c     | 3 +--
>  net/ipv4/sysctl_net_ipv4.c     | 3 +--
>  net/ipv6/sysctl_net_ipv6.c     | 3 +--
>  net/netfilter/ipvs/ip_vs_ctl.c | 4 +---
>  6 files changed, 10 insertions(+), 14 deletions(-)
>
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 7d9cfc730bd4..5851c2a92c0d 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -26,7 +26,7 @@ static const struct file_operations proc_sys_dir_file_operations;
>  static const struct inode_operations proc_sys_dir_operations;
>
>  /* shared constants to be used in various sysctls */
> -const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MAX, 65535 };
> +const int sysctl_vals[] = { 0, 1, 2, 3, 4, 100, 200, 1000, 3000, INT_MAX, 65535, -1 };
>  EXPORT_SYMBOL(sysctl_vals);
>
>  const unsigned long sysctl_long_vals[] = { 0, 1, LONG_MAX };
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 6353d6db69b2..80263f7cdb77 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -38,10 +38,10 @@ struct ctl_table_header;
>  struct ctl_dir;
>
>  /* Keep the same order as in fs/proc/proc_sysctl.c */
> -#define SYSCTL_NEG_ONE                 ((void *)&sysctl_vals[0])
> -#define SYSCTL_ZERO                    ((void *)&sysctl_vals[1])
> -#define SYSCTL_ONE                     ((void *)&sysctl_vals[2])
> -#define SYSCTL_TWO                     ((void *)&sysctl_vals[3])
> +#define SYSCTL_ZERO                    ((void *)&sysctl_vals[0])
> +#define SYSCTL_ONE                     ((void *)&sysctl_vals[1])
> +#define SYSCTL_TWO                     ((void *)&sysctl_vals[2])
> +#define SYSCTL_THREE                   ((void *)&sysctl_vals[3])
>  #define SYSCTL_FOUR                    ((void *)&sysctl_vals[4])
>  #define SYSCTL_ONE_HUNDRED             ((void *)&sysctl_vals[5])
>  #define SYSCTL_TWO_HUNDRED             ((void *)&sysctl_vals[6])
> @@ -51,6 +51,7 @@ struct ctl_dir;
>
>  /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
>  #define SYSCTL_MAXOLDUID               ((void *)&sysctl_vals[10])
> +#define SYSCTL_NEG_ONE                 ((void *)&sysctl_vals[11])
>
>  extern const int sysctl_vals[];
>
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 3a0ce309ffcd..195ca5c28771 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -25,7 +25,6 @@
>
>  #include "dev.h"
>
> -static int three = 3;
>  static int int_3600 = 3600;
>  static int min_sndbuf = SOCK_MIN_SNDBUF;
>  static int min_rcvbuf = SOCK_MIN_RCVBUF;
> @@ -553,7 +552,7 @@ static struct ctl_table net_core_table[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_dointvec_minmax,
>                 .extra1         = SYSCTL_ZERO,
> -               .extra2         = &three,
> +               .extra2         = SYSCTL_THREE,
>         },
>         {
>                 .procname       = "high_order_alloc_disable",
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 9ff60a389cd0..cd448cdd3b38 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -20,7 +20,6 @@
>  #include <net/protocol.h>
>  #include <net/netevent.h>
>
> -static int three __maybe_unused = 3;
>  static int tcp_retr1_max = 255;
>  static int ip_local_port_range_min[] = { 1, 1 };
>  static int ip_local_port_range_max[] = { 65535, 65535 };
> @@ -1056,7 +1055,7 @@ static struct ctl_table ipv4_net_table[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_fib_multipath_hash_policy,
>                 .extra1         = SYSCTL_ZERO,
> -               .extra2         = &three,
> +               .extra2         = SYSCTL_THREE,
>         },
>         {
>                 .procname       = "fib_multipath_hash_fields",
> diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
> index 560c48d0ddb7..94a0a294c6a1 100644
> --- a/net/ipv6/sysctl_net_ipv6.c
> +++ b/net/ipv6/sysctl_net_ipv6.c
> @@ -23,7 +23,6 @@
>  #endif
>  #include <linux/ioam6.h>
>
> -static int three = 3;
>  static int flowlabel_reflect_max = 0x7;
>  static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
>  static u32 rt6_multipath_hash_fields_all_mask =
> @@ -171,7 +170,7 @@ static struct ctl_table ipv6_table_template[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_rt6_multipath_hash_policy,
>                 .extra1         = SYSCTL_ZERO,
> -               .extra2         = &three,
> +               .extra2         = SYSCTL_THREE,
>         },
>         {
>                 .procname       = "fib_multipath_hash_fields",
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 7f645328b47f..efab2b06d373 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -1767,8 +1767,6 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
>
>  #ifdef CONFIG_SYSCTL
>
> -static int three = 3;
> -
>  static int
>  proc_do_defense_mode(struct ctl_table *table, int write,
>                      void *buffer, size_t *lenp, loff_t *ppos)
> @@ -1977,7 +1975,7 @@ static struct ctl_table vs_vars[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_dointvec_minmax,
>                 .extra1         = SYSCTL_ZERO,
> -               .extra2         = &three,
> +               .extra2         = SYSCTL_THREE,
>         },
>         {
>                 .procname       = "nat_icmp_send",
> --
> 2.27.0
>


-- 
Best regards, Tonghao
