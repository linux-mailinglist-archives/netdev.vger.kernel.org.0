Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481A21D021B
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 00:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731915AbgELWYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 18:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731906AbgELWYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 18:24:13 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D992FC061A0E;
        Tue, 12 May 2020 15:24:12 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b6so14314933qkh.11;
        Tue, 12 May 2020 15:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0gsgXfpO/9cmDJi7+0s57BUI1RZGgREph3URgrueDqY=;
        b=N5Sxfr47uQ75uctlunXOoTprbQZpqUGlibabRGaoQxs3Nyu6SekmQRE4hHvpVCL+UM
         FFAGbyYKzOjQ9xH0LYskSE4a0xY2eY2nfMGfcLnhMDRO+erat/ZqAZKj9yuUQtBKEb2f
         eabD0TfKPMvMbvfJfxawOUWcWyc1JdN1Y9xk7RQGpJzx+q9EZlwgUZ8DjDDPdXOyjGgv
         tjbckZFc6qwp3cos1nFU0SoOz+B686qhk4hSbr/JEh7JIsHfe37vRBKcqdjvEe86NxxV
         V1J1etK6ejgfs37mi4hCxQG62I991wxQgelpH3kU0PZC+AaiUotj0NaPwZhghs3p6hdG
         4zzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0gsgXfpO/9cmDJi7+0s57BUI1RZGgREph3URgrueDqY=;
        b=qGUiomcnmO9RR4jFJWuvNxCg4LZAlpNy/dVgshnYgq69x4MFbtM1Czll0TFYf/fIZA
         IgrkRKxi5de5X9NaVlLRjuJuS21w3sMh8tytpmDj6nXREQ+268o0BbRzNS1iyZT8rud9
         I0Bff6E8u2RUxhmmHvG7KLEIuQtOE0ZG20YG8ZbgqE2gXlzLsuiz+w7oNxYqXorh+rDe
         16pEMfKwF/vSWIPuQB5gB+zexIfE/l1VKEW2lQzkhQhAYO0gOH0xUB9SFugFHCDO0Qz9
         QXWsHeh1OEbCcChlCQFMEVC9tjz8jcoSl+oimMG1JXKhYzo5VHNeCI/EDUaAEXfwfOs5
         TgVQ==
X-Gm-Message-State: AGi0PuY0CV2WQiv363Yt0HwyJRCJ8D+8edRSdjUn3CoS3Kq+GMDscCDZ
        zcOcEtWG0RAyH5YMVm0E1XQpuEM7UeDvbVqg8N8=
X-Google-Smtp-Source: APiQypLqhks82McDNb8HCjaPT3uA87hgJea181KEywUCA0EnOD/OFgSzPBtGPI6ZghAXiz6KoWE5MDliywJCrA9vY94=
X-Received: by 2002:ae9:efc1:: with SMTP id d184mr24813626qkg.437.1589322252128;
 Tue, 12 May 2020 15:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200512155232.1080167-1-yhs@fb.com> <20200512155238.1080615-1-yhs@fb.com>
In-Reply-To: <20200512155238.1080615-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 May 2020 15:24:01 -0700
Message-ID: <CAEf4BzYAi8yoF0avR=V0h+5Y3ScGtAy6qYoPCPQyo0tWjbcuhQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/8] bpf: change func bpf_iter_unreg_target() signature
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

On Tue, May 12, 2020 at 8:53 AM Yonghong Song <yhs@fb.com> wrote:
>
> Change func bpf_iter_unreg_target() parameter from target
> name to target reg_info, similar to bpf_iter_reg_target().
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h   | 2 +-
>  kernel/bpf/bpf_iter.c | 4 ++--
>  net/ipv6/route.c      | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index ab94dfd8826f..ad1bd13cd34c 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1154,7 +1154,7 @@ struct bpf_iter_meta {
>  };
>
>  int bpf_iter_reg_target(struct bpf_iter_reg *reg_info);
> -void bpf_iter_unreg_target(const char *target);
> +void bpf_iter_unreg_target(struct bpf_iter_reg *reg_info);
>  bool bpf_iter_prog_supported(struct bpf_prog *prog);
>  int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
>  int bpf_iter_new_fd(struct bpf_link *link);
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index 1d203dc7afe2..041f97dcec39 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c
> @@ -254,14 +254,14 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>         return 0;
>  }
>
> -void bpf_iter_unreg_target(const char *target)
> +void bpf_iter_unreg_target(struct bpf_iter_reg *reg_info)

const, otherwise LGTM:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  {
>         struct bpf_iter_target_info *tinfo;
>         bool found = false;
>
>         mutex_lock(&targets_mutex);
>         list_for_each_entry(tinfo, &targets, list) {
> -               if (!strcmp(target, tinfo->reg_info->target)) {
> +               if (reg_info == tinfo->reg_info) {
>                         list_del(&tinfo->list);
>                         kfree(tinfo);
>                         found = true;
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 48e8752d9ad9..bb8581f9b448 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -6412,7 +6412,7 @@ static int __init bpf_iter_register(void)
>
>  static void bpf_iter_unregister(void)
>  {
> -       bpf_iter_unreg_target("ipv6_route");
> +       bpf_iter_unreg_target(&ipv6_route_reg_info);
>  }
>  #endif
>  #endif
> --
> 2.24.1
>
