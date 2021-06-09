Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8413A2088
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhFIXMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 19:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFIXL7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 19:11:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AF792613EE;
        Wed,  9 Jun 2021 23:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623280204;
        bh=eNgzYvBQDIPXLygVpH2eOXGfTsPlfSr5iuav7vW4i5Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r4fen7UTfmMveKwYQB3FljtPOn+P9O3OsJYRsNX3e3RqZg9F6/m1VU17OA23wZlot
         kj+6Tfp/bPVvQFlCXPHqE19Jl0lihOkISSqRk0DmaKfm5yX4T/Wooe7FwtBRDfE6lO
         lVQm6nVrm4T/Gfv5hAjc4wYGSnRZ3JjM/WXuoKVmUQIAP6W2nPO/Rzf40KCVkwXUoG
         jQuQYasZWxovQeXAJbqrB8YZHjJGZV8Wwe/GmGpEKK+Z7Ks+uk4Hr+1cqHuvxwEoSq
         LY0usN7fw8Z3DM8UcKuzbBegythuzJOklGgrS8YQRMGEQzAhFy9/IxO+2SBOv7mGJk
         qPSRvv0yBDcrA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9B37460A4D;
        Wed,  9 Jun 2021 23:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] net: ipa: memory region rework, part 1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162328020463.6274.14788072203026589858.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 23:10:04 +0000
References: <20210609223503.2649114-1-elder@linaro.org>
In-Reply-To: <20210609223503.2649114-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  9 Jun 2021 17:34:52 -0500 you wrote:
> This is the first portion of a very long series of patches that has
> been split in two.  Once these patches are accepted, I'll post the
> remaining patches.
> 
> The combined series reworks the way memory regions are defined in
> the configuration data, and in the process solidifies code that
> ensures configurations are valid.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] net: ipa: define IPA_MEM_END_MARKER
    https://git.kernel.org/netdev/net-next/c/f636a83662ff
  - [net-next,02/11] net: ipa: store memory region id in descriptor
    https://git.kernel.org/netdev/net-next/c/14ab6a208c11
  - [net-next,03/11] net: ipa: validate memory regions unconditionally
    https://git.kernel.org/netdev/net-next/c/0300df2d9d24
  - [net-next,04/11] net: ipa: separate memory validation from initialization
    https://git.kernel.org/netdev/net-next/c/98334d2a3ba4
  - [net-next,05/11] net: ipa: separate region range check from other validation
    https://git.kernel.org/netdev/net-next/c/5e57c6c5a349
  - [net-next,06/11] net: ipa: validate memory regions at init time
    https://git.kernel.org/netdev/net-next/c/2f9be1e90860
  - [net-next,07/11] net: ipa: pass memory configuration data to ipa_mem_valid()
    https://git.kernel.org/netdev/net-next/c/1eec767746e5
  - [net-next,08/11] net: ipa: introduce ipa_mem_id_optional()
    https://git.kernel.org/netdev/net-next/c/d39ffb97079b
  - [net-next,09/11] net: ipa: validate memory regions based on version
    https://git.kernel.org/netdev/net-next/c/75bcfde6c113
  - [net-next,10/11] net: ipa: flag duplicate memory regions
    https://git.kernel.org/netdev/net-next/c/eadf7f937614
  - [net-next,11/11] net: ipa: use bitmap to check for missing regions
    https://git.kernel.org/netdev/net-next/c/6857b02392ab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


