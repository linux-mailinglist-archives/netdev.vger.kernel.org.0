Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741A933A41D
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 11:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbhCNKPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 06:15:41 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:42922 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235134AbhCNKPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 06:15:17 -0400
Date:   Sun, 14 Mar 2021 10:15:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615716915; bh=bM7cn3Afzu5HwMEmA8LHq+iVZuDxZxEEQbnZuhdZvEg=;
        h=Date:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=jpFMl4hp7PYW0YfoBbb27jcEpamNRG53Kbe0U4P2zNXtu+ZXg4SYVY5cMuyC+d0Hn
         V28lFAHmNlil0dmG4Z1dDYZggrLQpnNsWqRSRCBKEFBdDMVfIrEDaT79OzsUEUyHNd
         RVZ6sE83S0YPfPROa9KrfykjYGmNqzQIS6FstZTSYR9ufeNuJcPKk//7GfNDWbBmSl
         7nNb9EOCDNOCpfI+HiVZglkkQOAylsmb//HzrFHW/aTb2mcIoEa+XOYenZH/w3+YFJ
         8hiSEYw7zShjXaIgNe4u7UipqQ4QT/Y1UNl0s+//0XNgxY+1weKsbVWeeqNLqXR2YO
         fHCM1UpjZ+8SQ==
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        jonathan.lemon@gmail.com, edumazet@google.com, willemb@google.com,
        haokexin@gmail.com, pablo@netfilter.org, jakub@cloudflare.com,
        elver@google.com, decui@microsoft.com, vladimir.oltean@nxp.com,
        lariel@mellanox.com, wangqing@vivo.com, dcaratti@redhat.com,
        gnault@redhat.com, eranbe@nvidia.com, mchehab+huawei@kernel.org,
        ktkhai@virtuozzo.com, bgolaszewski@baylibre.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 net-next 0/6] skbuff: micro-optimize flow dissection
Message-ID: <20210314101452.2482-1-alobakin@pm.me>
In-Reply-To: <20210313.181000.1671061556553245861.davem@davemloft.net>
References: <20210313113645.5949-1-alobakin@pm.me> <20210313.181000.1671061556553245861.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 13 Mar 2021 18:10:00 -0800 (PST)

> None of these apply to net-next as per the patchwork automated checks.  A=
ny idea why?

No unfortunately. That'why I sent a follow-up mail. All of them
successfully apply to pure net-next on my machine.
Can it be a Git version conflict? I use 2.30.2, but also tried 2.30.1
and the latest development snapshot, and in either case they got
applied with no problems.

I could have more clue if NIPA provided more detailed log, but didn't
find any. And apply_patches stage doesn't seem to be present on NIPA
GitHub repo, so I couldn't reproduce it 1:1.

I can try again on Monday, not sure if it will help.
I also sent another series yesterday, and it has 15 green lights on
Patchwork, so this problem seems to take place only with this
particular series.

> Thanks.

Thanks,
Al

