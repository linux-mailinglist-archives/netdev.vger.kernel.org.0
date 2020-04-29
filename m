Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC791BD401
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 07:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgD2Fc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 01:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726158AbgD2Fc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 01:32:56 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314CEC03C1AC;
        Tue, 28 Apr 2020 22:32:56 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id c23so882025qtp.11;
        Tue, 28 Apr 2020 22:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9LluvVKKcfJBIuFEldKgTxkv1kXnIh/Kn+l5F/0wOEw=;
        b=sVXNfG/8245rvjUF5PDVguQiZNQxlxIGptlGDoPLuZGNN8aGvCt5mSEHlhtG6iZmXD
         jp8pSNxY3my7wKQItrOsD1DSDzQUuduK/1AbmZ4kBUAD9t1sbemlK2vgQaPcZd5aVfJT
         LwvbuUqaabqK7vc0TD2vb4stinl6T49r131x4CPFuhr3JtYlumXFRIJL9+LF+DKirlKY
         oNLECT9mLUL1ACTPlJjOjaVkGrU55nc3WUnCoNTpbTtpG1BWxJ309PUOE+e318+wzNA9
         w9KsV9IXR0jZGSHCZbhb1aV3xchvTmqZaiww7EeMoYNnuH/hHbCW8nRuLoxgEKYWCnd7
         YdbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9LluvVKKcfJBIuFEldKgTxkv1kXnIh/Kn+l5F/0wOEw=;
        b=VnXit2oUoaxJD5CiywHVgohxB7zLFYlNSn9pxujZcCkXldEHDGyP5DeCGMsZ7kgCfM
         pdtTZMaeEyzpyl7KFY76hrbsSjbdXJJpsEUdKV6CUmnjJVY5OGRu3yG/5xj158RVfVT7
         CrhJvR5reKApR8ab2RZX8aWNR1D6D+zPWCim+mUV3INbMpFY+zNjvvNuIYcIwk4/pvhB
         rxEuk141e1Ye6wlLgDFHoDp/Tp/lXAIkuTamdYBejOviyVQGsqN48GKfsNqQ5K8id74o
         ADx8yk4dsyrkDsWtCY6Ew5q15vyP44j+OTXJ0n6+G1jsENSp1qYdwsqKyqvSIYAisL6/
         ri7g==
X-Gm-Message-State: AGi0PuYmgOWPYnmO6Hi6cDUXZGGLAk1p9sWDz+hO+J9A+u7bAZYkbThq
        Vv9Tmmv00aoXMxI7G2cwPECudJYLQO0dzFNEVxnk8MRR
X-Google-Smtp-Source: APiQypLkhexPgmSbI01m/Gf4VTWCon+nSh8v41DtL2J6A39tPBTF1Bv8y/hfATqViUjbMDn+Erxpo9WZulpoG0dSST8=
X-Received: by 2002:ac8:3f6d:: with SMTP id w42mr31591227qtk.171.1588138375173;
 Tue, 28 Apr 2020 22:32:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200429035841.3959159-1-songliubraving@fb.com> <20200429035841.3959159-3-songliubraving@fb.com>
In-Reply-To: <20200429035841.3959159-3-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 22:32:44 -0700
Message-ID: <CAEf4BzZsQxTW_aQp02cj3L3BofpQ3q76VOX_otA5q1v5EF7q6Q@mail.gmail.com>
Subject: Re: [PATCH v7 bpf-next 2/3] libbpf: add support for command BPF_ENABLE_STATS
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

On Tue, Apr 28, 2020 at 8:59 PM Song Liu <songliubraving@fb.com> wrote:
>
> bpf_enable_stats() is added to enable given stats.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  tools/lib/bpf/bpf.c      | 10 ++++++++++
>  tools/lib/bpf/bpf.h      |  1 +
>  tools/lib/bpf/libbpf.map |  5 +++++
>  3 files changed, 16 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 5cc1b0785d18..17bb4ad06c0e 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -826,3 +826,13 @@ int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf, __u32 *buf_len,
>
>         return err;
>  }
> +
> +int bpf_enable_stats(enum bpf_stats_type type)
> +{
> +       union bpf_attr attr;
> +
> +       memset(&attr, 0, sizeof(attr));
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

You forgot to pull and rebase. LIBBPF_0.0.9 is already in master.

> +               bpf_enable_stats;
> +} LIBBPF_0.0.8;
> \ No newline at end of file
> --
> 2.24.1
>
