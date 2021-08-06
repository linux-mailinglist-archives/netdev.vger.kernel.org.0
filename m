Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8153E2923
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 13:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245328AbhHFLKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 07:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245327AbhHFLKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 07:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B128561184;
        Fri,  6 Aug 2021 11:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628248205;
        bh=Forx3ImztBpSG2TKZ1Gvy+15tskdGHf8cQn36yqEqVE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N+vwUn7ZyTkosISZkElxXFKvIjlZHtRib32n8DB8vLb1jsLVZmkT1dSWts7QVwZ7/
         mEAPFKnsT2KiUFuXak7a+ih0MUi2ADEB4LySyc16J5KxVEp4cNO7swlEBgknxnl40F
         oIHK/hb6X+5Zacxfs3tM+xqqp+zGjtOxxdiknQkGAsSwekM6rP17P8C0BEGa90KUT5
         y53indSuv1t0dvV9Y7QR0b1rTyqwTkcSz4BuoPxfs+Uy04meXksPV1jJfs0d6hNswY
         hP3IXImv1MBLV1XiXI0/v2aOF6RFxy82MxmopEL2lj0pWvuzuEpbTu1NAWOONuawps
         EdjQ51qjjwOfw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A5C4160A7C;
        Fri,  6 Aug 2021 11:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mt7530: add the missing RxUnicast MIB counter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162824820567.31954.9014839863327381261.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Aug 2021 11:10:05 +0000
References: <20210806040528.735606-1-dqfext@gmail.com>
In-Reply-To: <20210806040528.735606-1-dqfext@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  6 Aug 2021 12:05:27 +0800 you wrote:
> Add the missing RxUnicast counter.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  drivers/net/dsa/mt7530.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] net: dsa: mt7530: add the missing RxUnicast MIB counter
    https://git.kernel.org/netdev/net/c/aff51c5da320

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


