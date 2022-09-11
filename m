Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2515B512B
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 22:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiIKUs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 16:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIKUsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 16:48:25 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB46622BFC;
        Sun, 11 Sep 2022 13:48:24 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id l16so3626489ilj.2;
        Sun, 11 Sep 2022 13:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ZVQHM/37BbrOGPiFeLtiNZICTr76UsNj+DYuPTvsb8Q=;
        b=RE50kfvR/4MBOCxWXWbyfeWyAOuv3CbuiaLU7BMsyghIreYzCGstvna7nzetMmdNVT
         Gt0EnZWy+hhZWdPO/qkwuo1IP2xsnPHlAEpWuZmvZ6trJP6d/tnrBtQx7K1AW2CPgIq5
         5Bj/9wvyD27kxFExBucubc/D8uCzJ9HCh3ndqqKBWAH1jjtfcz/4GVNoB+0GpyKNM2SR
         MJYikIp66vTwOZ915PwxP5PZZIut6ucG7vZ7AdEbEC6IrdtU7vfewJQko5F91HrvvkDJ
         jkPcVOAgFzg4tom5e4rFX85P+QjNKecE9ulprVilfILVcUKTiwnLI/m9F0CM0YEbnHkd
         nrLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ZVQHM/37BbrOGPiFeLtiNZICTr76UsNj+DYuPTvsb8Q=;
        b=r/vMRqJ10U+tFhTIsWXAhu3tVUnqpxEcPOYuA5A3UpzJCTK/2dR6TT8L7E2L5D+v1X
         x9WzNb3bNJhh/BLx4QSA7eV/EzeNU6AxuhuhpMJDF2ntc/tewcoqoauGBPbEIgGQyLu3
         Iqf4i30Nhf4LjrFoMhWC6B7vxwWlB7DQumL6JM+EAs8YDu6WwXgJHiSipwHZxj9ZQu2K
         SR4XORAnoQYegQjFQMK7yCSdUk41GcKb3DNTlGf/zkS3jueZ691xStVBDITCQTklUlSn
         fABSorfMtRngwYilcjZsU958VSLeOywNFmZ5qZtHXQKb1rzcd0MzZL0XJAFtZWhOorkZ
         PLPg==
X-Gm-Message-State: ACgBeo0Wie0uJDl7gS3oBGx36YhYwfWJHjY23w83CH4Iq1V2lgEHXu1o
        p3QuzMc1e/UJ6yBX57XWFZ4PpXNkUZo53AjN6bk=
X-Google-Smtp-Source: AA6agR71aeFCzogjuFx7JGCncWwFSimJ0ZSs/t1MkvqU4gU1pAfSi8OsmEw+8k+rZI02d0TUsGGR7A74lK4B2C6WBv8=
X-Received: by 2002:a92:cbcf:0:b0:2f3:b515:92d with SMTP id
 s15-20020a92cbcf000000b002f3b515092dmr2734086ilq.91.1662929304245; Sun, 11
 Sep 2022 13:48:24 -0700 (PDT)
MIME-Version: 1.0
References: <c4cb11c8ffe732b91c175a0fc80d43b2547ca17e.1662920329.git.dxu@dxuuu.xyz>
In-Reply-To: <c4cb11c8ffe732b91c175a0fc80d43b2547ca17e.1662920329.git.dxu@dxuuu.xyz>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Sun, 11 Sep 2022 22:47:46 +0200
Message-ID: <CAP01T74zOa=3uYJ_3YebAxzZTYRwAhF62Giy9ovuKwk++FpU0g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Move nf_conn extern declarations to filter.h
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Sun, 11 Sept 2022 at 20:20, Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> We're seeing the following new warnings on netdev/build_32bit and
> netdev/build_allmodconfig_warn CI jobs:
>
>     ../net/core/filter.c:8608:1: warning: symbol
>     'nf_conn_btf_access_lock' was not declared. Should it be static?
>     ../net/core/filter.c:8611:5: warning: symbol 'nfct_bsa' was not
>     declared. Should it be static?
>
> Fix by ensuring extern declaration is present while compiling filter.o.
>
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

>  include/linux/filter.h                   | 6 ++++++
>  include/net/netfilter/nf_conntrack_bpf.h | 7 +------
>  2 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 527ae1d64e27..96de256b2c8d 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -567,6 +567,12 @@ struct sk_filter {
>
>  DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
>
> +extern struct mutex nf_conn_btf_access_lock;
> +extern int (*nfct_bsa)(struct bpf_verifier_log *log, const struct btf *btf,
> +                      const struct btf_type *t, int off, int size,
> +                      enum bpf_access_type atype, u32 *next_btf_id,
> +                      enum bpf_type_flag *flag);
> +
>  typedef unsigned int (*bpf_dispatcher_fn)(const void *ctx,
>                                           const struct bpf_insn *insnsi,
>                                           unsigned int (*bpf_func)(const void *,
> diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
> index a61a93d1c6dc..cf2c0423d174 100644
> --- a/include/net/netfilter/nf_conntrack_bpf.h
> +++ b/include/net/netfilter/nf_conntrack_bpf.h
> @@ -5,6 +5,7 @@
>
>  #include <linux/bpf.h>
>  #include <linux/btf.h>
> +#include <linux/filter.h>
>  #include <linux/kconfig.h>
>  #include <linux/mutex.h>
>
> @@ -14,12 +15,6 @@
>  extern int register_nf_conntrack_bpf(void);
>  extern void cleanup_nf_conntrack_bpf(void);
>
> -extern struct mutex nf_conn_btf_access_lock;
> -extern int (*nfct_bsa)(struct bpf_verifier_log *log, const struct btf *btf,
> -                      const struct btf_type *t, int off, int size,
> -                      enum bpf_access_type atype, u32 *next_btf_id,
> -                      enum bpf_type_flag *flag);
> -
>  #else
>
>  static inline int register_nf_conntrack_bpf(void)
> --
> 2.37.1
>
