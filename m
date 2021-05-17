Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6FB383989
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345409AbhEQQVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 12:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238677AbhEQQS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 12:18:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A2B160FE9;
        Mon, 17 May 2021 16:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621268260;
        bh=N+mpCk+mQz/P22fRH6HdBrfNddDO4XUGzA5apz0Tuik=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nLMPV+wXjFiPdSYmoMtwoPcDtD4azw73AIj4ctyro9mwBJsoHlOrd4Jsy6uoPk+zR
         X7nOKwvXjmlb8m4vLLPNVKJ4e1xfDM8AOGq0i/JXOdAPblJEJwPdLnjXwXVLdQ7YOG
         vP248xJdNhj6CeYPxfxM/NlxbXqAbTdZm1DQ96h5rDKHef8vnve/KzydTby0Usdwty
         8FBIyP5XgsVUrs7GhRu+ZTrZapVZik03t9Gf4/atT2k5fEtNvr2b1Ex0h+IMNB7vvN
         cWTkt08edEK32f9OT+I+YghYYYU8GHHRfgZCnRDeyirkSN4bQAS9s8mpiO8B0hCe0z
         t3gL9krK8XqJA==
Received: by mail-lf1-f44.google.com with SMTP id q7so8332984lfr.6;
        Mon, 17 May 2021 09:17:40 -0700 (PDT)
X-Gm-Message-State: AOAM532wkrUJbyW6PpoRtj3T1moG+aqf47X4YY+c+LAwgorrYc10RHTe
        I5vCq+VRtiJCtvWWBGJlfvy9qfoObRUCHdiJ4q4=
X-Google-Smtp-Source: ABdhPJxh6EdWbws2fVp+x0SWstzHJX7NNwNnvu77wYqT7NT6HVVQuv0i+VP+Jw9qokCLy+EP2nPe5o3k/e70AyYq9cs=
X-Received: by 2002:a19:5e5d:: with SMTP id z29mr449934lfi.281.1621268258815;
 Mon, 17 May 2021 09:17:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210517022348.50555-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210517022348.50555-1-xiyou.wangcong@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 17 May 2021 09:17:27 -0700
X-Gmail-Original-Message-ID: <CAPhsuW51LJAwOT_LjgYxx3n80hGZm6Tm=QSRQzXUuWXhsNsKSg@mail.gmail.com>
Message-ID: <CAPhsuW51LJAwOT_LjgYxx3n80hGZm6Tm=QSRQzXUuWXhsNsKSg@mail.gmail.com>
Subject: Re: [Patch bpf] skmsg: remove unused parameters of sk_msg_wait_data()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 16, 2021 at 8:33 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> 'err' and 'flags' are not used, we can just get rid of them.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

Acked-by: Song Liu <song@kernel.org>

[...]
