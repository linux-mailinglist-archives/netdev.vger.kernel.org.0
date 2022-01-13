Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F10648DC95
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 18:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbiAMRHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 12:07:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46012 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiAMRHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 12:07:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5545861CE3;
        Thu, 13 Jan 2022 17:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B475BC36AEF;
        Thu, 13 Jan 2022 17:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642093664;
        bh=Dx0IclD0tXg+B85btv+baN4OXf8B48NeAIY0q+sv920=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EOCCUQVHJTxVv7/QtyIHGEaxPkCkQNEN8CVjaOSKRx/z9bjFVCfp9TsvgYAi24Fco
         HmdxBL5cICZ1H0R4hkSHMk4/g+YevWqLOl8s24G7rik9jlVjiMRS3EbLtPrUMEUe6k
         fydjEb7Lu5xKexGm3vxwEXFq8WIgcLHjP6UbR0XFKajVUO0lVVUiaT/O8RIwn4Vosx
         NTGS1Nw3IXBc11B5/iPNu10ZvQVT1K/KEGP3qDjbgQBmnCi/evXOVWPi9cFgDQXB+h
         8+G2G6mT89UEHf0f44Fkx4qarggQhgumCRfv5aSOU+YBsLiKDnQhIexRX/H+WFr4aJ
         A2nigoTxZpftg==
Received: by mail-yb1-f181.google.com with SMTP id c10so16967795ybb.2;
        Thu, 13 Jan 2022 09:07:44 -0800 (PST)
X-Gm-Message-State: AOAM530LvruR4aahudg7Gr9f3DGMBX99HtcRmR881oNI+g8a1kXCihSe
        5ZaQjzmESEtfdH43UUT0yxVUhh6bhrj8Up+m1xI=
X-Google-Smtp-Source: ABdhPJx5751HYvm6d/DQxy//XcTquoSjPD2H5p3LnBRwIC5C70ChPpnQLrQMSJYixxSRVsf4oaRMoG1NcBL8zTNVs6M=
X-Received: by 2002:a25:fd6:: with SMTP id 205mr7112590ybp.654.1642093663795;
 Thu, 13 Jan 2022 09:07:43 -0800 (PST)
MIME-Version: 1.0
References: <20220113031658.633290-1-imagedong@tencent.com>
In-Reply-To: <20220113031658.633290-1-imagedong@tencent.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 13 Jan 2022 09:07:32 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5HLK=DoNWmROXrce+9AcNBDLhjuoXQy2T0A_DQ34PBfQ@mail.gmail.com>
Message-ID: <CAPhsuW5HLK=DoNWmROXrce+9AcNBDLhjuoXQy2T0A_DQ34PBfQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] test: selftests: remove unused various in sockmap_verdict_prog.c
To:     menglong8.dong@gmail.com
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, davemarchevsky@fb.com,
        linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, imagedong@tencent.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 7:17 PM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> 'lport' and 'rport' in bpf_prog1() of sockmap_verdict_prog.c is not
> used, just remove them.
>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/testing/selftests/bpf/progs/sockmap_parse_prog.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
> index 95d5b941bc1f..c9abfe3a11af 100644
> --- a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
> +++ b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
> @@ -7,8 +7,6 @@ int bpf_prog1(struct __sk_buff *skb)
>  {
>         void *data_end = (void *)(long) skb->data_end;
>         void *data = (void *)(long) skb->data;
> -       __u32 lport = skb->local_port;
> -       __u32 rport = skb->remote_port;
>         __u8 *d = data;
>         int err;
>
> --
> 2.34.1
>
