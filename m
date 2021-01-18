Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AB42F9DC7
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 12:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389963AbhARLOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 06:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389036AbhARKrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 05:47:22 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C111C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 02:46:42 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id w18so31917564iot.0
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 02:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SlpVFG70d1haAhgfDosF+AGq4k9Rce7hROvWA+Bpu+o=;
        b=hyntPPIMGuqz6MhhQHoy89/WERg7VMJS9GpxnFwqrnQqmJSjwI/FL1NoEs7p6RdLa8
         /zAfa8lcN+DOqWaG0yXTNsYiFQQPoklAIcsBi1N0/WxUEWsmZilPPhPcdY8OfHWCbaV0
         CmVDttL80BxG1idnxWXuNA29VzJIGbhWehA6z05p3BXSpN+t/tj444WlB1DCzvKRj315
         2MM3cTivgnFW/Dyk5wW8Y3JY95QWtzMwpxxbTJ+pyLL3HrANPMc51u6XsJWw6R1C5BT/
         nRagJvkqkqrZWTQdMkFvbwusT88ggx8TW7jZ7wdLa5Q/Zu9VgCva94eHT7YnSD2RFOJr
         WkOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SlpVFG70d1haAhgfDosF+AGq4k9Rce7hROvWA+Bpu+o=;
        b=KAUhdbJIunFacO8JkfKD9FGam0hrVH4O4H0NKwqMQ2qEG7eGozaHUks9az6OA50D08
         3O7Xhm8UI1QEGD92q8td2nPaYr3BCfyVGsHqiJHZUv8nQmFud1QP6lRwspfPQijynB7S
         sjU0N7MnqNR+vkYYZDQJpxuobu8sqol/h/2Bs77Eb5IwuUg3Gg8LWY6JE+JS+b3S/YrD
         Wgbdt/iiDoQjABgMWDrIEriwgLDK0MTrVhfAHdcqg0gGTXWIQGwgmgpOS7ylWl2wHbOy
         +B7MNgEUR/k+CWZc6OprzDlhA/dN7vi14ViqJfzphRRLj/KT0s8fbKgw3jf94VZvBjdn
         2PbA==
X-Gm-Message-State: AOAM530edq+LeqxQptA6npD/KI5Kx5LBq/u8DLKNVB3QHxy+uYJDZqJN
        OqPljxuTX8AK7OlLXrU1V2i274Rs/LSg8ruoMmXXSA==
X-Google-Smtp-Source: ABdhPJwfSq1SQ7TLblWt7iM5zpWAuhnB5VJegpIITRV7IPSuwAx+odOBL7l3eFDnoUItHdT2zO82/C2n9A7nCVHfT90=
X-Received: by 2002:a05:6e02:194a:: with SMTP id x10mr20340034ilu.165.1610966801671;
 Mon, 18 Jan 2021 02:46:41 -0800 (PST)
MIME-Version: 1.0
References: <20210118080004.6367-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20210118080004.6367-1-lukas.bulwahn@gmail.com>
From:   Brendan Jackman <jackmanb@google.com>
Date:   Mon, 18 Jan 2021 11:46:30 +0100
Message-ID: <CA+i-1C3cEXqxcXfD4sibQfx+dtmmzvOzruhk8J5pAw3g5v=KgA@mail.gmail.com>
Subject: Re: [PATCH for bpf-next] docs: bpf: add minimal markup to address doc warning
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Lukas. Sorry I didn't get around to fixing it so far.

On Mon, 18 Jan 2021 at 09:00, Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
>
> Commit 91c960b00566 ("bpf: Rename BPF_XADD and prepare to encode other
> atomics in .imm") modified the BPF documentation, but missed some ReST
> markup.
>
> Hence, make htmldocs warns on Documentation/networking/filter.rst:1053:
>
>   WARNING: Inline emphasis start-string without end-string.
>
> Add some minimal markup to address this warning.
>
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Acked-By: Brendan Jackman <jackmanb@google.com>

>
> ---
> applies cleanly on next-20210118
>
> Brendan, please ack.
>
> Alexei, please pick this minor cleanup patch on your bpf-next.
>
>  Documentation/networking/filter.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/networking/filter.rst b/Documentation/networking/filter.rst
> index f6d8f90e9a56..45f6fde1776c 100644
> --- a/Documentation/networking/filter.rst
> +++ b/Documentation/networking/filter.rst
> @@ -1048,12 +1048,12 @@ Unlike classic BPF instruction set, eBPF has generic load/store operations::
>  Where size is one of: BPF_B or BPF_H or BPF_W or BPF_DW.
>
>  It also includes atomic operations, which use the immediate field for extra
> -encoding.
> +encoding::
>
>     .imm = BPF_ADD, .code = BPF_ATOMIC | BPF_W  | BPF_STX: lock xadd *(u32 *)(dst_reg + off16) += src_reg
>     .imm = BPF_ADD, .code = BPF_ATOMIC | BPF_DW | BPF_STX: lock xadd *(u64 *)(dst_reg + off16) += src_reg
>
> -The basic atomic operations supported are:
> +The basic atomic operations supported are::
>
>      BPF_ADD
>      BPF_AND
> --
> 2.17.1
>
