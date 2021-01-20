Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4EA2FCEF6
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbhATLPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729818AbhATJzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 04:55:10 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCAFC061575;
        Wed, 20 Jan 2021 01:54:30 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id i17so189767ljn.1;
        Wed, 20 Jan 2021 01:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Dzgt9eOErv7DRncKnAq6YJRbBsHovoN+K2WQNL3Z+8=;
        b=i4L+8exRf8lZaHTBzZPCPFSzSc+e00vaZuS4BnMHCc5zLodWr1iZ3wAYs11U8kBWDx
         Ql6TFIOJbwSFm2uj9IBHnVmfV+wN94OZ2XezIkgDorrGD43fsxSJUUMQFhwHtM6zM670
         RBcCKg8s964NGEL+12NSQamZqWozbLnwsJmNTUrpm4HTrvgt29zioadEOhGUgScFoxI6
         XI8YR1CgfbPAxLAmq43FmO/1nkYF/Ycm3m+EkiKvV8mjlveoDtrBZqzoF5kSEdMYbooG
         xoypAOB2q3SaksfogjIGkMoLn0Ym0MkofVA2IqCZB6MEfHfKi8ynpRDAZNt6oK1fbLeQ
         J+dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Dzgt9eOErv7DRncKnAq6YJRbBsHovoN+K2WQNL3Z+8=;
        b=SC1Kqe9fBk1AXgIUNNJEqWhuYs6aTV+wPeRvtZgNvEYKfv/FLO1UhkBWii3q+xm741
         0tcFgEaI7kGRy7OD5REs3toMN6bzCxjkVtXN1i27+q+Ivt+YImcUDNGDoD00efAmeQn2
         wWFOGjSCLHSzIJI5jYY0xX1shIaFc52Fo+jtN5k0bVkQHMKDyniHoHKrd6eOe7XMi/Sp
         FsRtj71zRFPv1Rh9SGC+tJgVqEtoVXuMCyJCf1vCoflXeOCitBzJFLedQr5ypAMXyOS+
         +ATFoc9g5+X9CLfVrOGdsJTe51YYS+3EQdaaCl86ZIT2HHqan9UaF/G8dtN7/xvIb4zQ
         Evig==
X-Gm-Message-State: AOAM532iRM3xLJW+Wphb/i8DSJXikPMdHSTwRZfaSMjXStdqaM16H14I
        eLNBT0MgA879+EFS8iFKvB6Z6A4oJxh/BYl00sw=
X-Google-Smtp-Source: ABdhPJwvMiO84gkALjBZYV/Z8117B5Fi5UzzquECd8v/xmJfuxLrV4PrxacoLeKawiqrEkSVrrKWWYw6Pxw4PasRCAU=
X-Received: by 2002:a2e:bc1e:: with SMTP id b30mr4263478ljf.18.1611136468818;
 Wed, 20 Jan 2021 01:54:28 -0800 (PST)
MIME-Version: 1.0
References: <20210118205522.317087-1-bongsu.jeon@samsung.com> <161110440860.4771.13780876306648585886.git-patchwork-notify@kernel.org>
In-Reply-To: <161110440860.4771.13780876306648585886.git-patchwork-notify@kernel.org>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Wed, 20 Jan 2021 18:54:17 +0900
Message-ID: <CACwDmQBZ-LVursCYmtngyv3yFCQ9_Jkip03VZ8cd1auNu86V8A@mail.gmail.com>
Subject: Re: [PATCH net] net: nfc: nci: fix the wrong NCI_CORE_INIT parameters
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 10:00 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This patch was applied to netdev/net.git (refs/heads/master):
>
> On Tue, 19 Jan 2021 05:55:22 +0900 you wrote:
> > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> >
> > Fix the code because NCI_CORE_INIT_CMD includes two parameters in NCI2.0
> > but there is no parameters in NCI1.x.
> >
> > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> >
> > [...]
>
> Here is the summary with links:
>   - [net] net: nfc: nci: fix the wrong NCI_CORE_INIT parameters
>     https://git.kernel.org/netdev/net/c/4964e5a1e080
>
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
>
>

Could you merge this patch to net-next repo??
NCI selftest that i will send will fail if this patch isn't merged.
