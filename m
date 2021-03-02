Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B822532B3B3
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449947AbhCCEFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:05:03 -0500
Received: from mail-yb1-f171.google.com ([209.85.219.171]:37573 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350351AbhCBSpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 13:45:25 -0500
Received: by mail-yb1-f171.google.com with SMTP id p193so21780902yba.4;
        Tue, 02 Mar 2021 10:44:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MpNiiFnvCV60eMMYrHSzbuK2BLlpKg0lToCXPm/qLyA=;
        b=QvJEHr7HWt4e+jVHbZgJaXGflGcW7fdQZNaTxNwSDMzgnYd8aYzeJyQHSJ1Jyt/mfl
         t0cVQAVDroHTjIJ4V0B/qv/0BdeEqZcZPnpk3CJCqAJCDRhGNNtFf6C0LQ9V4U1Xd4OO
         /Ioe99pRlmUYhX6dxb6ysVCpKgcEMY7u7OKR9y7PIWNhoqyMThBS3XT0xK6muOoyiqog
         Xa60sH4FwpfYPq3Fgwnca9P5akyC6cBWTBM2TNPKuiliAnSIfa3s177LFmzXfOyNxycA
         1W9J5kA2NJhUzEJRrLjs4xSIC1+XhIHL3z6l12bdq9yvurOMXxjME1KfkoLxGj6H06TO
         g6VQ==
X-Gm-Message-State: AOAM531FBE/2aT9ABo6tBjP/p+ZfTtBngPQU/zaK3UfPkrQo+4OjSLcb
        Kaw9iQOtcQq1/G5Coym2E6JuU4UFGToapqHFhSOePrH4C1I=
X-Google-Smtp-Source: ABdhPJzaIVG+VBlnAnse4ZYp+F3Z5KTEhgQqGDYqpX+qx+pYEUwpPZIuu6q8OUSkjXLzaWEJYGrfrE5E3BAI2t8nHxc=
X-Received: by 2002:ab0:60b8:: with SMTP id f24mr12577728uam.58.1614702747813;
 Tue, 02 Mar 2021 08:32:27 -0800 (PST)
MIME-Version: 1.0
References: <7009ba70-4134-1acf-42b9-fa7e59b5d15d@omprussia.ru> <161463420785.14233.15454498386680107579.git-patchwork-notify@kernel.org>
In-Reply-To: <161463420785.14233.15454498386680107579.git-patchwork-notify@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 2 Mar 2021 17:32:16 +0100
Message-ID: <CAMuHMdU_v=0MDqR5rU6eqA0e7C16WN6g3zE2AKmB7JsNqa=xdw@mail.gmail.com>
Subject: Re: [PATCH net 0/3] Fix TRSCER masks in the Ether driver
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 1, 2021 at 10:38 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
> This series was applied to netdev/net.git (refs/heads/master):
>
> On Sun, 28 Feb 2021 23:24:16 +0300 you wrote:
> > Here are 3 patches against DaveM's 'net' repo. I'm fixing the TRSCER masks in
> > the driver to match the manuals...
> >
> > [1/3] sh_eth: fix TRSCER mask for SH771x
> > [2/3] sh_eth: fix TRSCER mask for R7S72100
> > [3/3] sh_eth: fix TRSCER mask for R7S9210
>
> Here is the summary with links:
>   - [net,1/3] sh_eth: fix TRSCER mask for SH771x
>     https://git.kernel.org/netdev/net/c/8c91bc3d44df
>   - [net,2/3] sh_eth: fix TRSCER mask for R7S72100
>     https://git.kernel.org/netdev/net/c/75be7fb7f978
>   - [net,3/3] sh_eth: fix TRSCER mask for R7S9210
>     https://git.kernel.org/netdev/net/c/165bc5a4f30e

That was quick.  And as they're queued in net, not net-next, they
missed today's renesas-drivers release, and all related testing...

I applied them manually, and boot-tested rskrza1 (R7S72100) and
rza2mevb (R7S9210) using nfsroot. Worked fine.

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Review will take a bit longer...

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
