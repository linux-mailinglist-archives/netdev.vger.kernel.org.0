Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251931EAF3C
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbgFATAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728690AbgFATAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 15:00:18 -0400
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 093C320870;
        Mon,  1 Jun 2020 19:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591038018;
        bh=pr9PvQnF5zAiRXt8e86klZuiScWhu0KwXsqnQcYEQeE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=k7+p2DW48kROSbsdG/WEAWOeJX8zb/7dCbdnmUSfEs9GbzPfYmetHfPLxxDhRMI3H
         lPi/06u2YdyrhsczgP24IWd9etQdyC+pNitb/i2zJYWZSzVbHdV3h0/OBOrtUxkB++
         Kay9T5Bkk9A6uMQ72JSAfzIAsaCeDd6HR6qXnCPI=
Received: by mail-lj1-f175.google.com with SMTP id z18so9454188lji.12;
        Mon, 01 Jun 2020 12:00:17 -0700 (PDT)
X-Gm-Message-State: AOAM530/ZXxT+IWcCHoQOK1KnLoO2V2mFknVnigcD6Klme4ksvo0rp/P
        8aJv+teIHUgxVYTeHLyTYwAXCA4a3+x9Zpc1LF8=
X-Google-Smtp-Source: ABdhPJx/0j4LHk4TcYUV2BrcdD/1vRTTWF+DxCAFwu3W4r44pv+1FFUhqrggwYBZjbbcm05UY81vfYmCOvALFt1XRXQ=
X-Received: by 2002:a2e:99da:: with SMTP id l26mr4281002ljj.446.1591038016255;
 Mon, 01 Jun 2020 12:00:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200531154255.896551-1-jolsa@kernel.org>
In-Reply-To: <20200531154255.896551-1-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Mon, 1 Jun 2020 12:00:05 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7HevOVgEe-g3RH_OmRqzWedXzGkuoNNzJfSwKhtzGxFw@mail.gmail.com>
Message-ID: <CAPhsuW7HevOVgEe-g3RH_OmRqzWedXzGkuoNNzJfSwKhtzGxFw@mail.gmail.com>
Subject: Re: [PATCH] bpf: Use tracing helpers for lsm programs
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 31, 2020 at 8:45 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Currenty lsm uses bpf_tracing_func_proto helpers which do
> not include stack trace or perf event output. It's useful
> to have those for bpftrace lsm support [1].
>
> Using tracing_prog_func_proto helpers for lsm programs.

How about using raw_tp_prog_func_proto?

Thanks,
Song

PS: Please tag the patch with subject prefix "PATCH bpf" for
"PATCH bpf-next". I think this one belongs to bpf-next, which means
we should wait after the merge window.
