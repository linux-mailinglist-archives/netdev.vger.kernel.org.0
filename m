Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30913DF705
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhHCVkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232809AbhHCVkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 17:40:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6EDB261050;
        Tue,  3 Aug 2021 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628026806;
        bh=5JMHB0yY8QqUV9gku+h/QydoqaLTh51fWRTu1crjXPU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=erYr+K5AsO4XU0JtM8UkxPc8/gD65ijpSIUqmWNbdFDm6t/JgS8O8Me71HvyzIRNf
         hjrxXDJ2xAg+qUGlkJ+oKEFGakSy3vjsaMm+ilXQrvKQXcUpQvyVQbGBeZD2M2s0Eo
         Z4CtsJ7J6kAdBgBYH1GCLMmD3TTGT4Yl0fb9OCpOtUZ3rAURxtNKreWuZz1751PDRq
         /AZsJYDYYOeizIQwxYGpCY1EIenTWdO3eEKCXFkjY0QJkS6jaHs0WsTMtVuTDtt/Ee
         MlSTZHfBJhAWc32FrYDwWfAo6Tmlu7fFOtIUE/rnsdci4NTcfbESCrrEZ1Kt+6waMc
         LLwfbyAH7pz5Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 69FB860A6A;
        Tue,  3 Aug 2021 21:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2] net: fec: fix MAC internal delay doesn't work
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162802680642.18812.6472367485133674143.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 21:40:06 +0000
References: <20210803052424.19008-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210803052424.19008-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  3 Aug 2021 13:24:24 +0800 you wrote:
> This patch intends to fix MAC internal delay doesn't work, due to use
> of_property_read_u32() incorrectly, and improve this feature a bit:
> 1) check the delay value if valid, only program register when it's 2000ps.
> 2) only enable "enet_2x_txclk" clock when require MAC internal delay.
> 
> Fixes: fc539459e900 ("net: fec: add MAC internal delayed clock feature support")
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net-next,V2] net: fec: fix MAC internal delay doesn't work
    https://git.kernel.org/netdev/net-next/c/b820c114eba7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


