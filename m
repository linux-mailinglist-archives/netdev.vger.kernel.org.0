Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED0A230233
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgG1GAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgG1GAV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 02:00:21 -0400
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36CB420658;
        Tue, 28 Jul 2020 06:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595916021;
        bh=azSZ1bVmxDJBdKb3nWRp5yqpa8NuzlmguBfvozlPmNE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HNEXXWnS6O0LFT/ROcZpFKckNs/pLB3ZHS0NH3WIpDzlfG26PvLoE7gTFhEjTDEhA
         9XY402f7Q4ua6dfuG0RUMjMILEp1mSfr7CIdWeG4xj0OHWArBAXyYz4TGC8yY91rUz
         SBKxsxo3sNuQYffP8YQ42NNrmaeLyJ0EPKAIF4iA=
Received: by mail-lj1-f177.google.com with SMTP id q6so19793198ljp.4;
        Mon, 27 Jul 2020 23:00:21 -0700 (PDT)
X-Gm-Message-State: AOAM531BqVfB6bjh3J0SvmzTw6D6T6UBz6eyCSUGAFhOp/3Tcins8+u1
        iiql6odvUJdKb4LPG1UTV+JV8xNEFfarN4ZtF/s=
X-Google-Smtp-Source: ABdhPJw1qzBRyXlZwNmoPmrg5fMkSCVQiRAj9B38xHZ8RdDz6yX6QOTXm2yJTRE/jN375CHY/LbUvP1TD3MY12/dmgc=
X-Received: by 2002:a2e:7c14:: with SMTP id x20mr11834077ljc.41.1595916019590;
 Mon, 27 Jul 2020 23:00:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-31-guro@fb.com>
In-Reply-To: <20200727184506.2279656-31-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 23:00:08 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7GANaQBha2-h-yQn0LxwafmQVs_RJ5Wm=tngEAGVNmtg@mail.gmail.com>
Message-ID: <CAPhsuW7GANaQBha2-h-yQn0LxwafmQVs_RJ5Wm=tngEAGVNmtg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 30/35] bpf: bpftool: do not touch RLIMIT_MEMLOCK
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
>
> Since bpf stopped using memlock rlimit to limit the memory usage,
> there is no more reason for bpftool to alter its own limits.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

I think we will need feature check for memcg based accounting.

Thanks,
Song
