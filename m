Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963993D67E2
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 22:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhGZT0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhGZT0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:26:37 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDBFC061757;
        Mon, 26 Jul 2021 13:07:04 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id g76so16846009ybf.4;
        Mon, 26 Jul 2021 13:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pX9TFSQHRUSepht592Dmqm7GH5fSK0Oa3W1uWu4gfBo=;
        b=Io1wcyj08+pGUXbpk31hwSbVXToVKBqFHy+PxUI9sp15gbxL6csBrSieoRJJ1YOGUt
         80ZP0/OIwMRbcraA02MdMUihVvPgi69PwFPHh/yhWcJSkJoHHYanR7npaF6pgMN8S/s8
         2huCHfOUeah+iPUhgrXNWOBgqnPfLv1Ko0yMbdTTLr/t41v8m/LBtRfUDR2KmfElQbfF
         eQ1XIaIokGzHmhiZfp+WoeSLvwTZFcuCBCJ3DsPG60ZhTq1gHETn6jN9y54UmA9z5WDx
         rUzaqMGyHUvQOWierYk8IRHt4t9PKkRV4hdmoT1inaecS14TxB24YG/vzhv3SJlyD1Wk
         lMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pX9TFSQHRUSepht592Dmqm7GH5fSK0Oa3W1uWu4gfBo=;
        b=oCZWjxrhYRDHmWiM+jqwjZRNv4ld7QD1Xw81spe6hoJqG8wiEiC79eHZVUAB33Xlb7
         WlnudlRNQhzwdaaCIuT6xgNFL9KOIBTT/nxYp8b091lQkhRJGgD41QAaZnzDhULjSzkw
         XKR8iSetZqkA2CU5sFo8Dem8pRFyTjnBIWBRJ5tfd0tId7DB8v3XdNVILUPvI5l8l5fW
         t70Fdc2xV+M9/cRgt4uTbMDlKnjzErAcOTnuQ+/G+nJWbcyw6pWzUBEFFCsyfiA1iEIP
         imkurg/aGVMbqUd9DWT4QUhh/UnqsRED7mO/JQ+8+Vv8pEOyi9l38cpm7eamCNZcyytP
         pgGg==
X-Gm-Message-State: AOAM530N6JW1P/OItrEYwgaWsbzO1Q8BS4jJgOISQPlZmGVEFCa5smBl
        KyKm4FtK/TKNL/mnG+ZzL5GnLFwEPv1TAnpFy6o=
X-Google-Smtp-Source: ABdhPJw39JDCpY8ns09WCeqPFfKS7TdGz2NUsNF7pMk26i+ZB3kbR1g2y4+fVlmIckyUCRl4WSIRI5bnzhllAY208XU=
X-Received: by 2002:a25:a045:: with SMTP id x63mr15591363ybh.27.1627330024004;
 Mon, 26 Jul 2021 13:07:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210721104058.3755254-1-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20210721104058.3755254-1-johan.almbladh@anyfinetworks.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Jul 2021 13:06:52 -0700
Message-ID: <CAEf4BzaT0kTdk3zzVK3SrVzHgYvfQw0ZsWcbyYdnvHdT7xySxA@mail.gmail.com>
Subject: Re: [PATCH] bpf/tests: fix copy-and-paste error in double word test
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 3:41 AM Johan Almbladh
<johan.almbladh@anyfinetworks.com> wrote:
>
> This test now operates on DW as stated instead of W, which was
> already covered by another test.
>
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---

Don't know why patchbot didn't send notification, but this got applied
last Friday to bpf-next.

>  lib/test_bpf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index baff847a02da..f6d5d30d01bf 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -4286,8 +4286,8 @@ static struct bpf_test tests[] = {
>                 .u.insns_int = {
>                         BPF_LD_IMM64(R0, 0),
>                         BPF_LD_IMM64(R1, 0xffffffffffffffffLL),
> -                       BPF_STX_MEM(BPF_W, R10, R1, -40),
> -                       BPF_LDX_MEM(BPF_W, R0, R10, -40),
> +                       BPF_STX_MEM(BPF_DW, R10, R1, -40),
> +                       BPF_LDX_MEM(BPF_DW, R0, R10, -40),
>                         BPF_EXIT_INSN(),
>                 },
>                 INTERNAL,
> --
> 2.25.1
>
