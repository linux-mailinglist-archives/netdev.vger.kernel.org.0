Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3633D206BF5
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 07:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388946AbgFXFtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 01:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388280AbgFXFtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 01:49:13 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB429C061573;
        Tue, 23 Jun 2020 22:49:13 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id z1so830916qtn.2;
        Tue, 23 Jun 2020 22:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ShBKJ5keCGjO85LfMFG5uvPBt0RApJJ415V16FVa8lY=;
        b=US423nVi5aKM1j92nsirmLWseieDRI/RfjX0Vom/oyRdR70u/NHtE/6J/bzX1NIdol
         e7YMz+aS/1UgKb/NEQVRsnUdMeGkwWHYNPtyRzZAj3IDLMdx24jubmqpi2C13RvbZs3m
         V/f490C8vdbEbmBufbqE/J7Q3JTXhif7RChf0Ucetwnugyb+5oV9mmOjoqm4ACxvZJDh
         hHmEB7+YLloLTyuhkRMw1AX2IgMvrxjDu/M2V1zlhXlTKw4ELM6/VoJEFMvH6Xjo65IT
         37uiw+RJ/HuISYBIjCh+u7NqhlWB/UTg3RWNCdM5kOnrJ0qqCDe9ipyzSb3scR31xfVn
         5KPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ShBKJ5keCGjO85LfMFG5uvPBt0RApJJ415V16FVa8lY=;
        b=A3XjHBwNoo3lGNefNAYas7K5ecm19VnhJ6lSzT7A885HEOPgo4n1nXDxAwhdMX8jQo
         Awozj0kbY75F3MJa6GNTUSiQSvjnzH8UQPX//x4kwNJHLqvXtjnzOlAKiaOFmyAeyyzI
         gzOdmvSe2mbNpge2Y5ttEOVzmC6noX5TnF7bby3deKBNygGsFrCAhPzeDUh0rh6Dl509
         lVEEIIDGKKZ4UleHtOdPIAodQd+bVKsRVWGxx4WoiM/LVU63FA+NiaR9jC3dw9ESQSQw
         r6uexs86SCEAitwHTOuhkqvQVC2Naki7ziBk74/ZfbX/Wwq5wyIZYr9bwcSwYBQH3Mum
         TbTQ==
X-Gm-Message-State: AOAM530/OpSRGg1/TJdSlZ3miPaltr6zNtJn7sEOH4sTlUNy6DViYfHf
        gZDseWzsnZRUfDtiHK8LBDVWly9s+dL6G7KMlvW6/Fuf
X-Google-Smtp-Source: ABdhPJxPTNbM7vq7EcJ2YWjjVsaLih0edfJdV7moTXHap+OsWLU1RsQ/YrNYz8pKZBYBHmpvE2qhB4Tg0zAH3pQWHAQ=
X-Received: by 2002:ac8:5306:: with SMTP id t6mr1543904qtn.59.1592977753090;
 Tue, 23 Jun 2020 22:49:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592947694.git.lorenzo@kernel.org> <372755fa10bdbe9b5db4e207db6b0829e18513fe.1592947694.git.lorenzo@kernel.org>
In-Reply-To: <372755fa10bdbe9b5db4e207db6b0829e18513fe.1592947694.git.lorenzo@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 22:49:02 -0700
Message-ID: <CAEf4BzbiZLtr8Vhwef=Zjd_=OVqKBozyg76Djae7qw3rgd7q8g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 7/9] libbpf: add SEC name for xdp programs
 attached to CPUMAP
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        lorenzo.bianconi@redhat.com, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 2:40 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> As for DEVMAP, support SEC("xdp_cpumap*") as a short cut for loading
> the program with type BPF_PROG_TYPE_XDP and expected attach type
> BPF_XDP_CPUMAP.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 18461deb1b19..16fa3b84ac38 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6866,6 +6866,8 @@ static const struct bpf_sec_def section_defs[] = {
>                 .attach_fn = attach_iter),
>         BPF_EAPROG_SEC("xdp_devmap",            BPF_PROG_TYPE_XDP,
>                                                 BPF_XDP_DEVMAP),
> +       BPF_EAPROG_SEC("xdp_cpumap/",           BPF_PROG_TYPE_XDP,
> +                                               BPF_XDP_CPUMAP),
>         BPF_PROG_SEC("xdp",                     BPF_PROG_TYPE_XDP),
>         BPF_PROG_SEC("perf_event",              BPF_PROG_TYPE_PERF_EVENT),
>         BPF_PROG_SEC("lwt_in",                  BPF_PROG_TYPE_LWT_IN),
> --
> 2.26.2
>
