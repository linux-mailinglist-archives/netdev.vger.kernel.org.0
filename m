Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C75F396CB8
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhFAFWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232744AbhFAFWM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:22:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 13D6260FF1;
        Tue,  1 Jun 2021 05:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622524805;
        bh=CzQags+F5o0/Apoy9lwYQTIaCJ4cyLY+pvrSw4+O4dE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JMB1npHKHWLmXIsHpQXFs461Xut8UoM+wHIoL53z1PxZklui3+L7cwU13BRauA9Xt
         IPIHTQIsESpezW3sJosXKybpbBVFX9y5veZ7gRY+T2VMb4b6mdVfi0jX11ZFZrxuM1
         68YkEJx8oQZkzdXG1O1mkXa3jEaYVA0BVoOFFsy8FCwo5UUnszcPaZ+6ZRe2AS9GaQ
         5vmOmLB9oD2vJP7nATJ8whxefuyO5CRnBnc4Ul9raY0mkIoffxNaZjCz4Z3Xgt+bH7
         DstluKNoqCApShnO5KJtZQxq2zmsWuOVtk42WYEN96PV9l2lHC1PXbPb+eMburBTLE
         I6mBAg7dXxuxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 060A360CD1;
        Tue,  1 Jun 2021 05:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: align code with context
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162252480501.23898.10631295560871610587.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 05:20:05 +0000
References: <20210530113811.8817-1-rocco.yue@mediatek.com>
In-Reply-To: <20210530113811.8817-1-rocco.yue@mediatek.com>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        Rocco.Yue@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 30 May 2021 19:38:11 +0800 you wrote:
> The Tab key is used three times, causing the code block to
> be out of alignment with the context.
> 
> Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
> ---
>  net/ipv6/addrconf.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - ipv6: align code with context
    https://git.kernel.org/netdev/net-next/c/12e64b3bb9a8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


