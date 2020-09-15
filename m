Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE0426AFDB
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgIOVqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728039AbgIOVqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 17:46:13 -0400
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC1F02078E;
        Tue, 15 Sep 2020 21:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600206339;
        bh=ABO82mts5nM3TIDHabvdMa6Lu89g2lxW//DekJQN3sI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lpJM6v5gln7UPseNFO1kEyhfOQWZhRGg/0Us3J2MY7Utt41YPGejkC0+DqRiNfhYL
         58ugG7zikfF/d0O16LiHqmgs4w17t1ZsabLQD9PBJXD/NQJ8ssFDnr03+EOdtV981W
         FMb2w1KLKojd9VRgY2PV7/+Ff0Mu5c/I/h6xrsJY=
Received: by mail-lj1-f182.google.com with SMTP id a22so4097951ljp.13;
        Tue, 15 Sep 2020 14:45:38 -0700 (PDT)
X-Gm-Message-State: AOAM530OdAJ6u9SfDHwOna8ghOY+9E0jDqUfS4hXkP6B2fUA/JSHPdi/
        Qw4ING6bw5Q/aQKVvaA5NaFDDkkWzyPp0xQhgSk=
X-Google-Smtp-Source: ABdhPJxy0f+UQrcOiRM36neEKe54grnKyDt4O7nHzMMmZUen0Fhk4jrRtUVHboHkjWZlS2jhPpTIoAWDt1muzOesD2I=
X-Received: by 2002:a2e:98cf:: with SMTP id s15mr7935962ljj.446.1600206337180;
 Tue, 15 Sep 2020 14:45:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200915182959.241101-1-kafai@fb.com>
In-Reply-To: <20200915182959.241101-1-kafai@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 15 Sep 2020 14:45:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7b6oMHgOn0Oyq1Fk-xOws=8tK0Bfmbh-UvZUYUFE-zCQ@mail.gmail.com>
Message-ID: <CAPhsuW7b6oMHgOn0Oyq1Fk-xOws=8tK0Bfmbh-UvZUYUFE-zCQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: bpf_skc_to_* casting helpers require a NULL
 check on sk
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 11:32 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The bpf_skc_to_* type casting helpers are available to
> BPF_PROG_TYPE_TRACING.  The traced PTR_TO_BTF_ID may be NULL.
> For example, the skb->sk may be NULL.  Thus, these casting helpers
> need to check "!sk" also and this patch fixes them.
>
> Fixes: 0d4fad3e57df ("bpf: Add bpf_skc_to_udp6_sock() helper")
> Fixes: 478cfbdf5f13 ("bpf: Add bpf_skc_to_{tcp, tcp_timewait, tcp_request}_sock() helpers")
> Fixes: af7ec1383361 ("bpf: Add bpf_skc_to_tcp6_sock() helper")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
