Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824E43CB1A8
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 06:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhGPEp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 00:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhGPEp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 00:45:56 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E6BC06175F;
        Thu, 15 Jul 2021 21:43:01 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id y38so12842436ybi.1;
        Thu, 15 Jul 2021 21:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PIl1Fw5KR3VFhFZN5uMgR/f+HO3oLdMTMy69W8uQI1w=;
        b=p9S203gnpka34CU5RHrMDahkLMagbCycT+2Z0ubYaclI8nDutRLoerCbiDfzXiWy21
         R23PiGXE4OMpOXTkORuVNuk2osy8IbdIvDSTg3Twh7BmWCJf5wYdJ9GnjpwyaMH6wGbj
         +5PD0h5ikqFjwmnk8UD74Tvhc2foWBwKn2QEGAUiSy0h85MhrJC37PZKJ6Npm7RnaF7Q
         KL30dVm4eDrCVrL+8eZbm7eX1/QCvJcwD3XDNhYy2Rey93E0UMNt+9LXoqodoJnINlcd
         eY7vtQxr7KpDID4i/RW6KFwfQu+XJ4d4TlI8YBqD2xbVabcS1XO0zwLdMpryX5oYSmHi
         86Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PIl1Fw5KR3VFhFZN5uMgR/f+HO3oLdMTMy69W8uQI1w=;
        b=b3GvhWSgbyQlZFAPi8jRzp25ULG4ycar0/8GGki3wIDVpKl5Aljee/nT8IRybmORNh
         892xVtLMfDpgPkDrE8UuqTGpbukVUfSIVzgkkLafYdF4qnVhR1pyQG+isRCM9VV6/zSe
         OYcbNmaPlICLqpljm+k8QA6cKcHE0HythBm2HvHWWJkbLRfOyRctC2aN1sNsppqDadEa
         Ok+pSrY/kvcfvt05FO/qgjEktLSjqdQ4rglbrcgcbj4G77/RLu4YPw2Y6cHPlHEq2q78
         Eh9ZWBJyJH2HIuS66O0BeBD8PwFtaudHZqqUQKPz5h+xci2S0dfq0krIGRpzB3gEQRCw
         ss5g==
X-Gm-Message-State: AOAM530eOdyzqYaTtd0k+p0pKCyD0o18oa0ukJmYsHGSqYLHxTBSvZKk
        duIkwqEqBTNyB8y7tqKBR+peaSjSPZ2qM8csn5o=
X-Google-Smtp-Source: ABdhPJzFfJXHDV0tSnZQGkH2WAegz/Pj/Wop5sb1pWe+n29n4Qs5rmjnfZr6BT9Ob2NgAep1i2mK6OU6gE9B00YSJGU=
X-Received: by 2002:a25:b203:: with SMTP id i3mr10187994ybj.260.1626410580903;
 Thu, 15 Jul 2021 21:43:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210714141532.28526-1-quentin@isovalent.com> <20210714141532.28526-5-quentin@isovalent.com>
In-Reply-To: <20210714141532.28526-5-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Jul 2021 21:42:50 -0700
Message-ID: <CAEf4BzbXA5ZQCzLoY+r8XjSXNzBYtUiYh1aXo0O+TvO8JXvDQQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/6] libbpf: explicitly mark btf__load() and
 btf__get_from_id() as deprecated
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 7:15 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Now that we have replacement functions for btf__load() and
> btf__get_from_id(), with names that better reflect what the functions
> do, and that we have updated the different tools in the repository
> calling the legacy functions, let's explicitly mark those as deprecated.
>
> References:
>
> - https://github.com/libbpf/libbpf/issues/278
> - https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/lib/bpf/btf.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index 0bd9d3952d19..522277b16a88 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -45,7 +45,8 @@ LIBBPF_API struct btf *btf__parse_raw(const char *path);
>  LIBBPF_API struct btf *btf__parse_raw_split(const char *path, struct btf *base_btf);
>
>  LIBBPF_API int btf__finalize_data(struct bpf_object *obj, struct btf *btf);
> -LIBBPF_API int btf__load(struct btf *btf);
> +LIBBPF_API LIBBPF_DEPRECATED("the name was confusing and will be removed in the future libbpf versions, please use btf__load_into_kernel() instead")
> +int btf__load(struct btf *btf);

So I learned from my previous attempts to deprecate libbpf API to
never do that in the same release that introduces a replacement API.
So I'll postpone this change till the next libbpf release, otherwise
it causes too much churn and frustration for existing users.

And I'd probably keep the message short, like "use
btf__load_into_kernel() instead".

>  LIBBPF_API int btf__load_into_kernel(struct btf *btf);
>  LIBBPF_API __s32 btf__find_by_name(const struct btf *btf,
>                                    const char *type_name);
> @@ -67,7 +68,8 @@ LIBBPF_API void btf__set_fd(struct btf *btf, int fd);
>  LIBBPF_API const void *btf__get_raw_data(const struct btf *btf, __u32 *size);
>  LIBBPF_API const char *btf__name_by_offset(const struct btf *btf, __u32 offset);
>  LIBBPF_API const char *btf__str_by_offset(const struct btf *btf, __u32 offset);
> -LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
> +LIBBPF_API LIBBPF_DEPRECATED("the name was confusing and will be removed in the future libbpf versions, please use btf__load_from_kernel_by_id() instead")
> +int btf__get_from_id(__u32 id, struct btf **btf);
>  LIBBPF_API int btf__load_from_kernel_by_id(__u32 id, struct btf **btf);
>  LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
>                                     __u32 expected_key_size,
> --
> 2.30.2
>
