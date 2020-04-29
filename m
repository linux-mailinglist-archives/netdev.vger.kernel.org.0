Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1653D1BE8F4
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgD2Uqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbgD2Uqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:46:38 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB9AC03C1AE;
        Wed, 29 Apr 2020 13:46:38 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id ep1so1920840qvb.0;
        Wed, 29 Apr 2020 13:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zLYimF40PcTpOHyGgGs96C3rLizmBF2u5rF/cVsiYlY=;
        b=CZU1Q/dXtPhAExDyIJcxUz1wR5RAbyfONDZ505rWTHmbQCmvmdLFLpiTFN9k2B6f02
         Ak4h6PDVCOpk0WdpN9zxpso3F8xF41V+IkMsinWICgVyK11KP+Fynvdf5wq+C2rhMVKW
         3H9B+o2uvuKDjri1lH21z7/xAgsIt8tQkE+YM7SPrQGoG3Qhy1GGe+DaAXARkLB1U1MK
         VhDmcAuBCprdr+yuypaiSv68eWEyS94zXgW2+piYNORgelrHtSFWEYWsMzVthlnwC7Qu
         RL96OgRf0frdY2WZXIH6n+iICUJZ1rOKXN2ReF1bvELwItyyvys0efnVXAxQc1egwAh5
         WdYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zLYimF40PcTpOHyGgGs96C3rLizmBF2u5rF/cVsiYlY=;
        b=UmdFg33Ur7SksJT88yylpaCGvSEnU2QxEkk88F9XRc3Tev2HjVgMixHW3GX/ZRMzxe
         L6dKuTGrkDRBS/mKq4l6Zb9plqL09b/bXcyHVmRLMXhLenRKRwntnSs5/NCm6At59Iwx
         DKwLe9BSvulUxaifgjK5PZxaTF+rNftAeEGqoiWqiG0GE40M+HRaXznM5drWkF2c4RlW
         6mXRrkr5L3BBnGHCQhdQpJiUrqJdm1q2XBnqeXkZfxxlxhsP02ixik3YUzcIthkmodT8
         j+j1+sOXAIo9InKkUF12KrIwKXPDlgO8bQ0WTp5x91P+tqVeHA3qdpwXGWESPi2qtb98
         lqhA==
X-Gm-Message-State: AGi0PuaN7QqCgw8EV7voM4G3J1nbl+W1DZ3Jiw7wZBYFlo8MAne3bldc
        ltkKBfZOF5CyBqeYg7XYT4TmgpeafpAZyPPD/wk=
X-Google-Smtp-Source: APiQypKLKmkXs57TvL9j1GKZOGbs/ArJKUy1qWWIsFX2rppKty4eLrKEIr8rCWySM0V6A/Bu602ZmEF4IeVX8zgiRLI=
X-Received: by 2002:a0c:fd8c:: with SMTP id p12mr35654357qvr.163.1588193197460;
 Wed, 29 Apr 2020 13:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201245.2995342-1-yhs@fb.com>
In-Reply-To: <20200427201245.2995342-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Apr 2020 13:46:26 -0700
Message-ID: <CAEf4Bzaxg5P2kdoSVK+Tuch5hQVhSXS6c4fWYrLOSc=eWDdfqQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 09/19] bpf: add PTR_TO_BTF_ID_OR_NULL support
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 1:13 PM Yonghong Song <yhs@fb.com> wrote:
>
> Add bpf_reg_type PTR_TO_BTF_ID_OR_NULL support.
> For tracing/iter program, the bpf program context
> definition, e.g., for previous bpf_map target, looks like
>   struct bpf_iter_bpf_map {
>     struct bpf_dump_meta *meta;
>     struct bpf_map *map;
>   };
>
> The kernel guarantees that meta is not NULL, but
> map pointer maybe NULL. The NULL map indicates that all
> objects have been traversed, so bpf program can take
> proper action, e.g., do final aggregation and/or send
> final report to user space.
>
> Add btf_id_or_null_non0_off to prog->aux structure, to
> indicate that for tracing programs, if the context access
> offset is not 0, set to PTR_TO_BTF_ID_OR_NULL instead of
> PTR_TO_BTF_ID. This bit is set for tracing/iter program.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h   |  2 ++
>  kernel/bpf/btf.c      |  5 ++++-
>  kernel/bpf/verifier.c | 19 ++++++++++++++-----
>  3 files changed, 20 insertions(+), 6 deletions(-)
>

[...]

>
>  static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
> @@ -410,7 +411,8 @@ static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
>         return type == PTR_TO_SOCKET ||
>                 type == PTR_TO_SOCKET_OR_NULL ||
>                 type == PTR_TO_TCP_SOCK ||
> -               type == PTR_TO_TCP_SOCK_OR_NULL;
> +               type == PTR_TO_TCP_SOCK_OR_NULL ||
> +               type == PTR_TO_BTF_ID_OR_NULL;

BTF_ID is not considered to be refcounted for the purpose of verifier,
unless I'm missing something?

>  }
>
>  static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
> @@ -462,6 +464,7 @@ static const char * const reg_type_str[] = {
>         [PTR_TO_TP_BUFFER]      = "tp_buffer",
>         [PTR_TO_XDP_SOCK]       = "xdp_sock",
>         [PTR_TO_BTF_ID]         = "ptr_",
> +       [PTR_TO_BTF_ID_OR_NULL] = "ptr_or_null_",
>  };
>

[...]
