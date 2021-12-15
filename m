Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352EE475239
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbhLOFk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235611AbhLOFk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:40:58 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E0AC061574;
        Tue, 14 Dec 2021 21:40:58 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id n8so15482971plf.4;
        Tue, 14 Dec 2021 21:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kjNCbNe58uR7WK7clmqj8tgvXMlbRh3fhjB+Aq/w/qw=;
        b=LuWODWD7brLyz/Zz4yk3ZKU/s2UPMR5QdEoSl+TlDVe4mppMzlFLrxJLR4vvoXEto0
         QvqbSAyJZUDRcY2x7/is1NF9iapGVcS7qRxioiS0RWLqqGZEzFSU2BVPPDjpY422UAvl
         rASxNP1kNUPsFFtJH044Q2TLaCQZvCENVU41jJNFSFYH8U65h1Chtjxgezk1sY576o+D
         5GHAH3/nscKhgGQvBOy4aYyUbSRpWwGLwNYY9Hv/xfnuQetKmwvkLflPPBf9UjiOfBcF
         YLcCUPHrg1vKDJ8A3zp8U9guI3t77LCHXebPnKRpOIzGlcV14L0VajWCOU+Ggn6xckuR
         XXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kjNCbNe58uR7WK7clmqj8tgvXMlbRh3fhjB+Aq/w/qw=;
        b=GbmN0iTMLaJXQedL3whzidnhMu4rn4E/YfF2nn0O4nXCNTXuxocDWmxsFog2AbohZZ
         4RBY7pYGGv9WzKB7QK/sEtYMATa5SIRi+ucDsEN0cNW9sqPwbOcrC1I2kurqeimeCF1m
         DfZQIVuzRoEWBE6jORF5GzkCxPEsXkiWftKXyV//5LS8h1kuLrd36lAk/seipaMubt16
         fiK3KIXxMDiFp3YKLShGeEcBNG/pATbWy2DKJa1J64llfvmsEvVjzf3Hv0dTZJathpLx
         kaM2N4La8Uck5Wab9yM7dTw/uVIyHrbqkheWLKGKV8vavJQBJW1v9KJOIKzKT5FytWnI
         jd4g==
X-Gm-Message-State: AOAM532pzy1Afwp/R2xjLzmij7726BjBBw8bp64T0OnNNfZofidg/IKv
        pWKITPmirjKN9QpGvYPJr0BJ4fAsH/+b/wG2Keg84xNthjA=
X-Google-Smtp-Source: ABdhPJxm8eM6TyZAxK2eNHRGWdkpzEGPze/xftSE032sJeFIafjR0E1Shkh7bi2j9rSZNx5+W05zieudyOO/JDkne1Y=
X-Received: by 2002:a17:90b:4c03:: with SMTP id na3mr9954036pjb.62.1639546857494;
 Tue, 14 Dec 2021 21:40:57 -0800 (PST)
MIME-Version: 1.0
References: <20211214140402.288101-1-hch@lst.de> <20211214140402.288101-4-hch@lst.de>
In-Reply-To: <20211214140402.288101-4-hch@lst.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 Dec 2021 21:40:46 -0800
Message-ID: <CAADnVQKakFTQTnW6q-9eWsmgLcc7eTGbPM=a4A9PWNdXGrgKjA@mail.gmail.com>
Subject: Re: [PATCH 3/4] bpf, docs: Only document eBPF in instruction-set.rst
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 6:04 AM Christoph Hellwig <hch@lst.de> wrote:
>  Three LSB bits store instruction class which is one of:
>
> -  ===================     ===============
> -  Classic BPF classes     eBPF classes
> -  ===================     ===============
> -  BPF_LD    0x00          BPF_LD    0x00
> -  BPF_LDX   0x01          BPF_LDX   0x01
> -  BPF_ST    0x02          BPF_ST    0x02
> -  BPF_STX   0x03          BPF_STX   0x03
> -  BPF_ALU   0x04          BPF_ALU   0x04
> -  BPF_JMP   0x05          BPF_JMP   0x05
> -  BPF_RET   0x06          BPF_JMP32 0x06
> -  BPF_MISC  0x07          BPF_ALU64 0x07
> -  ===================     ===============

I don't want to lose the classic vs extended visual comparison.
These were one the most valuable tables to me.
Maybe instead of intro.rst call it classic_vs_extended.rst ?
or history.rst ?

That would be patch 2 as-is plus extra tables and text
that this patch removes.
There will be a bit of overlap between history.rst
and instruction-set.rst.
I think it's ok.

The rest makes sense to me.

Maybe Daniel has better ideas.
