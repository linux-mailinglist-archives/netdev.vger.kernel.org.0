Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA3E20BC17
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgFZWCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZWC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:02:28 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFC8C03E979;
        Fri, 26 Jun 2020 15:02:28 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id j10so8616071qtq.11;
        Fri, 26 Jun 2020 15:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8WIKkmkw+zJ2eirAiqoKIREjztn56T5W1fT71uuN8TE=;
        b=Txofs5OWaYLB9cmfw2Ok2XpEXQGf2YraycZiLYYlQ+ZHAnxXy4QmbONusW/btRdRC2
         ykTIQYg2/+1KmnQgDtUKtI8laPJ2gBOGRNHnBmNXYMBjAisBTJJgTa8AEU3Q+Lm4U0/s
         lhOtlatI8x+ggwuChjqOgp+/9atMHxdc2NY7Jxh3wPENFep5ahuRluRxDUEyOuM5ose1
         4wSL+7LyvjCbUiqvIq3moskvJ+crFxGgelkgEmF4ufTMobuMOFLu1z4WLB39wF94li2L
         NHUiCE7HyyKdzI+V0ssVw/2/pXFmdGaaRRYn+85jaj0304Jatjpb7blEw7nYRPYexr3x
         SBAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8WIKkmkw+zJ2eirAiqoKIREjztn56T5W1fT71uuN8TE=;
        b=QjmiTkNyvLIwypJu2RwdQVNWil24CxgoTY9zNplD1WnjjvUidr4zPA6S43dGvpRFnu
         RqbdV8VG/cPm0e3QGMujYuiF37wlYipmZIbNjgfKJ2FvALZg5BdAVtLfUQRUVpH06FYZ
         /OhTWl/jtijg1wkPfEj0L7H8f0Kk8vWghKSliYCH67XN71iRyncDQW8CnozTd2CPxyw6
         WxwjktOmNgi37IlnlNGP+FIP5+qBkzBSjaeWanYMfrRi6Mj3IkLZwWeWPmZt8KgnUjrE
         iSIQBllwaVG6eP/n5FGty1gzNau5taGB1xdbNXcjMOFhFx+vWuFqO9vaUxdQWh6kTpId
         ORzg==
X-Gm-Message-State: AOAM5311rNrT4kmrSL1HGjuIaVXrbwTRYHeaBKVts9wPyZAuK/ssbbLi
        D1z7ksnn8VS7UUmkEcPO+l8oBK5xLRbtqR2MGsg=
X-Google-Smtp-Source: ABdhPJx6yw1UL6PXyiP69OS+m9EzYL17y6eIW2RYq+0ln3CCZdvxJ21a78JpMZ2s201gHVKH3AsxbDDpJPpAt+la4ec=
X-Received: by 2002:ac8:2bba:: with SMTP id m55mr4970417qtm.171.1593208947777;
 Fri, 26 Jun 2020 15:02:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200626000929.217930-1-sdf@google.com> <20200626000929.217930-2-sdf@google.com>
In-Reply-To: <20200626000929.217930-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 15:02:16 -0700
Message-ID: <CAEf4Bza+j4KsuCs3pyRGNUvUTWmJ=qc4GRUYNkca3F6XFvrvAQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] libbpf: add support for BPF_CGROUP_INET_SOCK_RELEASE
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 5:13 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Add auto-detection for the cgroup/sock_release programs.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  tools/include/uapi/linux/bpf.h | 1 +
>  tools/lib/bpf/libbpf.c         | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index c65b374a5090..d7aea1d0167a 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -226,6 +226,7 @@ enum bpf_attach_type {
>         BPF_CGROUP_INET4_GETSOCKNAME,
>         BPF_CGROUP_INET6_GETSOCKNAME,
>         BPF_XDP_DEVMAP,
> +       BPF_CGROUP_INET_SOCK_RELEASE,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7f01be2b88b8..acbab6d0672d 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6670,6 +6670,8 @@ static const struct bpf_sec_def section_defs[] = {
>         BPF_APROG_SEC("cgroup_skb/egress",      BPF_PROG_TYPE_CGROUP_SKB,
>                                                 BPF_CGROUP_INET_EGRESS),
>         BPF_APROG_COMPAT("cgroup/skb",          BPF_PROG_TYPE_CGROUP_SKB),
> +       BPF_EAPROG_SEC("cgroup/sock_release",   BPF_PROG_TYPE_CGROUP_SOCK,
> +                                               BPF_CGROUP_INET_SOCK_RELEASE),
>         BPF_APROG_SEC("cgroup/sock",            BPF_PROG_TYPE_CGROUP_SOCK,

might want to add another alias to match _release: "cgroup/sock_create"?

>                                                 BPF_CGROUP_INET_SOCK_CREATE),
>         BPF_EAPROG_SEC("cgroup/post_bind4",     BPF_PROG_TYPE_CGROUP_SOCK,
> --
> 2.27.0.111.gc72c7da667-goog
>
