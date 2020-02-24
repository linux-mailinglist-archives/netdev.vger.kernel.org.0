Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948EC16B313
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgBXVrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:47:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgBXVrI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 16:47:08 -0500
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22BA4222C2;
        Mon, 24 Feb 2020 21:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582580827;
        bh=iNtRJwz9wlMRsiahuz/KF1yWpwEFtdXT3kziG8T5g6o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WMg+aYz1pqfBf40N7HwxHgQpeCL0z5WsTj4AbdBOu5Qf4JPsNW4o/ftranmD03CLS
         3aQ4zGauKMZhe6n6sPY8dsd/Lv4qk4vcsHr8kdnVV5e98E3ApwKd3g2YjZ2Vc86bsS
         3N4Gd+iAZnwNydBCjMv7weJyQcdqMV8pTKKZVIPg=
Received: by mail-lf1-f44.google.com with SMTP id c23so7943508lfi.7;
        Mon, 24 Feb 2020 13:47:07 -0800 (PST)
X-Gm-Message-State: APjAAAULrZXbP80U8GZpGfJ1NR38DakqrRBafpKQeMeY6H9BlVrKxVCz
        KdiYWmMSYuS7A8wvDLpJmBJTZSHrnYQsFkCNZ2A=
X-Google-Smtp-Source: APXvYqzaaG/6z/a+I+9wcWjT9K03hUBnD02phL7AqptSQe39nY1F/hXEGG8n2WvCSqtYN3l8Vad/TDDs2i+ojPEZagA=
X-Received: by 2002:ac2:5682:: with SMTP id 2mr12461494lfr.138.1582580825266;
 Mon, 24 Feb 2020 13:47:05 -0800 (PST)
MIME-Version: 1.0
References: <20200220041608.30289-1-lukenels@cs.washington.edu>
In-Reply-To: <20200220041608.30289-1-lukenels@cs.washington.edu>
From:   Song Liu <song@kernel.org>
Date:   Mon, 24 Feb 2020 13:46:54 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6c9g9QRKZWVLXZN27SKOxMBM2tPV3F+QM5sb6mtvseow@mail.gmail.com>
Message-ID: <CAPhsuW6c9g9QRKZWVLXZN27SKOxMBM2tPV3F+QM5sb6mtvseow@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] RV32G eBPF JIT
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Jiong Wang <jiong.wang@netronome.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 8:21 PM Luke Nelson <lukenels@cs.washington.edu> wrote:
>
> This is an eBPF JIT for RV32G, adapted from the JIT for RV64G and
> the 32-bit ARM JIT.

I found a lot of common code between RV32G and RV64G. Can we move
these code into a header file?

Thanks,
Song
