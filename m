Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741343EBEA3
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbhHMXUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:32996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235029AbhHMXUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 19:20:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B1FA1610EA;
        Fri, 13 Aug 2021 23:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628896806;
        bh=SeS0zTDfvPPBfy7uB+l8Uek61TbA+ZKecwg4/Wd0T7Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BZo6E5lB9xpRxJyc9qlpxg26OUZe4HKuR9bb71kft3VKJz5ciz4qM2ZFcWlpjBXM8
         rDECO2O2KTSKJ+T5t12FdrBtxi5neveom58Px1mIEme4CpKoiHFUPaYFXD4T6fc+/U
         CBmESuYcwjHshjZ/oJOOsR3R5hoNyhWRHRLKEqaJssxNHZBpECxGxaqZnQPCzxjjF6
         eNMozkC+IKkloyNzZCTGW0eFJlEhyC5kBVEExiPfszeNFoaNmmsy320hQl4l94mJDm
         61Ez0SPzUichq2TsVzUsvUd5cbHsMD7Kj/4AsumWgkJQByPtZ4vXIBEqeV2LumBoLF
         NsqMC05oGl5Gw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A2F3A60A69;
        Fri, 13 Aug 2021 23:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ravb: Remove checks for unsupported internal delay
 modes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162889680666.8729.6362809405452590677.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Aug 2021 23:20:06 +0000
References: <2037542ac56e99413b9807e24049711553cc88a9.1628696778.git.geert+renesas@glider.be>
In-Reply-To: <2037542ac56e99413b9807e24049711553cc88a9.1628696778.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     s.shtylyov@omp.ru, davem@davemloft.net, kuba@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 11 Aug 2021 17:49:00 +0200 you wrote:
> The EtherAVB instances on the R-Car E3/D3 and RZ/G2E SoCs do not support
> TX clock internal delay modes, and the EtherAVB driver prints a warning
> if an unsupported "rgmii-*id" PHY mode is specified, to catch buggy
> DTBs.
> 
> Commit a6f51f2efa742df0 ("ravb: Add support for explicit internal
> clock delay configuration") deprecated deriving the internal delay mode
> from the PHY mode, in favor of explicit configuration using the now
> mandatory "rx-internal-delay-ps" and "tx-internal-delay-ps" properties,
> thus delegating the warning to the legacy fallback code.
> 
> [...]

Here is the summary with links:
  - [net-next] ravb: Remove checks for unsupported internal delay modes
    https://git.kernel.org/netdev/net-next/c/44e5d0881280

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


