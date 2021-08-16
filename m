Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5C43ED220
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbhHPKkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231979AbhHPKkg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:40:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6CF9461BCF;
        Mon, 16 Aug 2021 10:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629110405;
        bh=DFkUJSwFq/sKEvM/uJ3/IoukYt3e/1DeBZUMlHLMSmI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nw1eY3uDzOnBvhkVgkpSnpinqpNxHfvA64/fB7D6xGAHIZIuybfeSVu1JFSyDQZXN
         9WFuX3Fx0+5W3rbzPN0poDgd4I1v1CDiJe5rxA5oE7drABSO2/7snXCeTqua2AJw3W
         EVCtEYbAmKwwLu1M2To3d+7b9FxeUybarnDOUGfmvzpH9EVhtlIc6y/7RXtK2T0X1y
         omoWpPOW8oww0x8eoTGYnGhyrzUunabav6PZFmgm33FwWmGKt3FmnrZWeBUGaa92Z3
         zVqywemlSP00nvfuq1x+H+j8kmUFpYkFc81X9mTo0Lp7/kW0QrEt399eSfTz3rjNod
         FrXk5pAvdeb1Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5D310609CF;
        Mon, 16 Aug 2021 10:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] bnxt_en: 2 bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162911040537.4961.4125494121255611046.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:40:05 +0000
References: <1629058537-23284-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1629058537-23284-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sun, 15 Aug 2021 16:15:35 -0400 you wrote:
> The first one disables aRFS/NTUPLE on an older broken firmware version.
> The second one adds missing memory barriers related to completion ring
> handling.
> 
> Michael Chan (2):
>   bnxt_en: Disable aRFS if running on 212 firmware
>   bnxt_en: Add missing DMA memory barriers
> 
> [...]

Here is the summary with links:
  - [net,1/2] bnxt_en: Disable aRFS if running on 212 firmware
    https://git.kernel.org/netdev/net/c/976e52b718c3
  - [net,2/2] bnxt_en: Add missing DMA memory barriers
    https://git.kernel.org/netdev/net/c/828affc27ed4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


