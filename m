Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EF235D679
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 06:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhDMEaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 00:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhDME3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 00:29:55 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15427C061574;
        Mon, 12 Apr 2021 21:29:34 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 65so16719967ybc.4;
        Mon, 12 Apr 2021 21:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j5372T7oiTYIcSbokwY9txcLYb4l3MFl5tmPs5Qu1g4=;
        b=BFfi9g7cTyM4uAYGsM8ghUZhjP3ucL5jxhFX0bLofyQI2XfE9XFq9dDaNQ1DQKpBqC
         6LxmdhThUqD6gDMy9szjRZxc4ntZFhaYMjeGrNh52rsoO5TWEF8EPLQrDoR74rVYSUGr
         c2GdHiiXS6r349VFN1VfeA6MAxz8CMgcev7EVBBYdm3Z0uJKxa92HuHBpBUT2sPeADsz
         PtuyEc7k8AoNYeJOBX0z2QCfW8AstnLaw3y3VgUBLXCcj15EFReyU1FXHhTEUOwdTJy7
         y/mJWr1ooUu7lSgFZvfYPba2o2p5q4vENaMeW5BSpH3ceb7lxubBCA8rozstp6g3iQ71
         dnOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j5372T7oiTYIcSbokwY9txcLYb4l3MFl5tmPs5Qu1g4=;
        b=I73oLMgYd+aJ6EUB2Idh7bO3KcAwM0YNZl2Rc/MM2aavnlKR7o9cimqXehKPFJVVMS
         nBFGDWURWZEkjNSacHv23ZQuj4Wwb6rg6XbY0w8MhaOIRZPsy6x4X3Xebi6+7vujixaF
         4PtfA1aKJwC4frH7pNZZnhoZ4dcDpzxPFv1nHM9iuAqVdsxW7W0J9UZ+f2ZfJQYGDSiX
         ONDJ8vJS+/a9rSpm1yiC1yxYiWIdywXHlaWOtQNcqJhFiW4DuXvaQeouldr6ygv6jYwg
         j10ihOVnh3fBzAS1h2d1tfxgPJlZ43NpN8LfzHDOhSEOR1UxSIyWtINY/N6OTikF9/7o
         HjOA==
X-Gm-Message-State: AOAM533CY/O0Wrrgl8sSni1wAJ3yKvqq+CebAlhtQGqimqRRDExXfx05
        V2J4IPWYKwL8p0b7nNhR7FWcdkSjtXujNNaAbnM=
X-Google-Smtp-Source: ABdhPJxmxLvgoFC3aQ/40OwrDREnq0pYuJ7z8XoASt89RE+IV+WjOoaCUu/FFJSRmfSX62tkNvGadIpC+rwMTx85t0o=
X-Received: by 2002:a25:9942:: with SMTP id n2mr41399080ybo.230.1618288173358;
 Mon, 12 Apr 2021 21:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210412192434.944343-1-pctammela@mojatatu.com>
In-Reply-To: <20210412192434.944343-1-pctammela@mojatatu.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 12 Apr 2021 21:29:22 -0700
Message-ID: <CAEf4BzYrK+TbYT6_rjZHjeDQ5Nea15Zk2JYU4Dqp_g8MPVup8g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: clarify flags in ringbuf helpers
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 12:25 PM Pedro Tammela <pctammela@gmail.com> wrote:
>
> In 'bpf_ringbuf_reserve()' we require the flag to '0' at the moment.
>
> For 'bpf_ringbuf_{discard,submit,output}' a flag of '0' might send a
> notification to the process if needed.
>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---

Great, thanks! Applied to bpf-next.

>  include/uapi/linux/bpf.h       | 16 ++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 16 ++++++++++++++++
>  2 files changed, 32 insertions(+)
>

[...]
