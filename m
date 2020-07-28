Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5EF2313D2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgG1UYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729063AbgG1UYE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:24:04 -0400
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA68E20829;
        Tue, 28 Jul 2020 20:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595967844;
        bh=5YUBNTR6kYnSRFgnb9uK5M5vzWu1wDoO3UjTjmNNR+E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Voba7APY6X4jIMHLUPRkvVLxVwLMCE0ussUB7/B3nVeH6eGBzckcdamFuSQiX/zFZ
         reWh/KAXgwe4/bqTFLJet8T0D6jLM8Gn7LSlzYSTUbJbPyL5H/aQ7noTJg/88Ygcjb
         7OAArA+zIQEGirQXuDT++t8kQ9cRwuJ0OOsx7u5I=
Received: by mail-lj1-f182.google.com with SMTP id q7so22608898ljm.1;
        Tue, 28 Jul 2020 13:24:03 -0700 (PDT)
X-Gm-Message-State: AOAM5316ycIZl3KtqXe413g5/Rjzkofb9rsXyhEaw+vLgef74sc0huWV
        zcMZqyPZhM+Y7GIyFOGwGJOjLojt11cadQyNtfc=
X-Google-Smtp-Source: ABdhPJx7n+jT+T49UfNdqpU6nld4hX9C++G+lHCUWkNG1ItG/NNfosAfqCmmqbchzsagbFzJjB1tDpHV020xHV/MAqU=
X-Received: by 2002:a2e:88c6:: with SMTP id a6mr13266449ljk.27.1595967842119;
 Tue, 28 Jul 2020 13:24:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200728190527.110830-1-andriin@fb.com> <416c8ef6-3459-8710-2eb5-870e2c695ceb@infradead.org>
In-Reply-To: <416c8ef6-3459-8710-2eb5-870e2c695ceb@infradead.org>
From:   Song Liu <song@kernel.org>
Date:   Tue, 28 Jul 2020 13:23:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW63iuBcMiw0TKRSBH68F7GRC9o4JUC6JLx0ij4WK6KX7w@mail.gmail.com>
Message-ID: <CAPhsuW63iuBcMiw0TKRSBH68F7GRC9o4JUC6JLx0ij4WK6KX7w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix build without CONFIG_NET when using BPF
 XDP link
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 1:08 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 7/28/20 12:05 PM, Andrii Nakryiko wrote:
> > Entire net/core subsystem is not built without CONFIG_NET. linux/netdevice.h
> > just assumes that it's always there, so the easiest way to fix this is to
> > conditionally compile out bpf_xdp_link_attach() use in bpf/syscall.c.
> >
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Fixes: aa8d3a716b59 ("bpf, xdp: Add bpf_link-based XDP attachment API")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Acked-by: Song Liu <songliubraving@fb.com>
