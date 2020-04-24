Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AF81B7D8C
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 20:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgDXSJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 14:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726813AbgDXSJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 14:09:35 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2676EC09B048;
        Fri, 24 Apr 2020 11:09:35 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id m67so11049265qke.12;
        Fri, 24 Apr 2020 11:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FijXuR/B8hNJZpXWfyWtzR4oc6TriA0O7KQol7jqy/s=;
        b=JiD+Ycyc4HTWj2d5zfxs5pReazgZID7D/HUWb8r/gF3uqVrJK3b4GyEQNKRXNwYPAd
         vTr8GHb5r2Xl0nY43cwFhIsp9iGrI+zkmyHLptBM03Bvr4pQwN7qbRjNO6ZJ+bgf6VOF
         3qNAaU9oX+DMC2OHIoKq9KsIepwbpTA/1Jnhi7HcTXM6/T+KYq/+wQ/NzgfENXsQEU/6
         7g7CXx6CRlsmeh5Ye3NlpXnAN1QyWJqOflQICWK46ZdjuGjsiWgbIhV0J09OXzFmH/qs
         YuwboQvyclw1diiRGgnA+UdmWvoFCTTPNgcLKUgSWD9lPFaKW5Skf2ZV5MqHiaC5NmDI
         HpEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FijXuR/B8hNJZpXWfyWtzR4oc6TriA0O7KQol7jqy/s=;
        b=ObhtHsoFu7NiVgvHplmbjVQzUMVZaVFt7/JRTNFd8Nc0ymp5RtQFJJMEg0zH4Mlaqt
         NjTvPdMYcR4MWnP9jUFm58W1o/zsXNC7PU7Ew46nWNpv2mmVN3bHfG3Y3TKFCyD/JbCf
         FAUambIjTIdIt132vu5b+RQfCVhIRfd/2doN40GIma1t4c0as8z75I1bHplouIR3iRDh
         YccCzfHPR+sxaUCGEuc1xWaKtHftCqVZ4W23aNikRQ3X1rFpCI9rcIzgmmiXlqHDfi1p
         SYwEfAqZiK4y+PXH8nIIBrjjRVAo3QxhaFgcKULdtWZEB5GiUrl5Jwv0ZBXCGa00xK6U
         LEmA==
X-Gm-Message-State: AGi0PubBEuIEKBvGH1VulZqwkh3kIGpA0JnHGCgr7KvS+T3EqVY5fzmT
        dAFDYil4sizTdRBXsDyMFNcwIS7Sw+KrRJZlr4M=
X-Google-Smtp-Source: APiQypLQ6g0jUtYo78C3CVXIxZwWdGdZDLVRfZoK4bcPN1GslJcobJDQsI5/kMLEeKsRoOnVhcv7SUm6L0w1t+LanSU=
X-Received: by 2002:a37:6587:: with SMTP id z129mr10655173qkb.437.1587751774283;
 Fri, 24 Apr 2020 11:09:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200424061755.436559-1-songliubraving@fb.com> <20200424061755.436559-3-songliubraving@fb.com>
In-Reply-To: <20200424061755.436559-3-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 24 Apr 2020 11:09:23 -0700
Message-ID: <CAEf4Bzb-8cv9xXQe5qCrTxuxdjvsvyZQJY=GB7vpX7nfKL73PA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/3] libbpf: add support for command BPF_ENABLE_STATS
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 11:19 PM Song Liu <songliubraving@fb.com> wrote:
>
> bpf_enable_stats() is added to enable given stats.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  tools/lib/bpf/bpf.c      | 9 +++++++++
>  tools/lib/bpf/bpf.h      | 1 +
>  tools/lib/bpf/libbpf.map | 5 +++++
>  3 files changed, 15 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 5cc1b0785d18..c06c25293ab7 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -826,3 +826,12 @@ int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf, __u32 *buf_len,
>
>         return err;
>  }
> +
> +int bpf_enable_stats(enum bpf_stats_type type)
> +{
> +       union bpf_attr attr = {};

this has to be memset(0) explicitly due to possibility of compiler not
zero-initializing padding

> +
> +       attr.enable_stats.type = type;
> +
> +       return sys_bpf(BPF_ENABLE_STATS, &attr, sizeof(attr));
> +}
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 46d47afdd887..5996e64d324c 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -229,6 +229,7 @@ LIBBPF_API int bpf_load_btf(void *btf, __u32 btf_size, char *log_buf,
>  LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf,
>                                  __u32 *buf_len, __u32 *prog_id, __u32 *fd_type,
>                                  __u64 *probe_offset, __u64 *probe_addr);
> +LIBBPF_API int bpf_enable_stats(enum bpf_stats_type type);
>
>  #ifdef __cplusplus
>  } /* extern "C" */
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index bb8831605b25..ebd946faada5 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -254,3 +254,8 @@ LIBBPF_0.0.8 {
>                 bpf_program__set_lsm;
>                 bpf_set_link_xdp_fd_opts;
>  } LIBBPF_0.0.7;
> +
> +LIBBPF_0.0.9 {
> +       global:
> +               bpf_enable_stats;
> +} LIBBPF_0.0.8;
> \ No newline at end of file
> --
> 2.24.1
>
