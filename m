Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31666343098
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 03:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhCUCLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 22:11:06 -0400
Received: from [198.145.29.99] ([198.145.29.99]:50936 "EHLO mail.kernel.org"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhCUCLC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Mar 2021 22:11:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AE0B561956;
        Sun, 21 Mar 2021 02:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616292609;
        bh=uASA2fep9y4k38Q11/Otj7B0gfzJhBFpAuzNwj4l4II=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=et486X/LNYoLdsHBhlq4t+LtjnGQ+YaECRQF9nKWUwOA39G21GZYXCdGkHASdd22o
         3uKZkr/VgS4Y4nH1sOxFwb4aK1QnYJOzjQs3TZYsDyUYbT4kgh1TLj3n/r/efaRrYX
         vZoxdxN2jKB9v7S6NdBnGheMuY3NsmvcYqBYT8K8LKh4rGC8QDaS1btLpFTWEQ38mf
         EFTB2AYLJuaVT1jD+cEVrCJ5o1PnRD9Z6hX7d14z4T+a3T5Ylh4H9PZkVIKLZJxqzh
         yduG4oCFb7MYcM67krJFilKZ53iXI2npZq7fqHCK1fUKGze6wep905ck8qgJwcGVJD
         VF3nBIerIZR2Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A8841626ED;
        Sun, 21 Mar 2021 02:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: ipa: more configuration data updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161629260968.5230.12891165070069314304.git-patchwork-notify@kernel.org>
Date:   Sun, 21 Mar 2021 02:10:09 +0000
References: <20210320155707.2009962-1-elder@linaro.org>
In-Reply-To: <20210320155707.2009962-1-elder@linaro.org>
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

On Sat, 20 Mar 2021 10:57:02 -0500 you wrote:
> This series starts with two patches that should have been included
> in an earlier series.  With these in place, QSB settings are
> programmed from information found in the data files rather than
> being embedded in code.  Support is then added for reprenting
> another QSB property (supported for IPA v4.0+).
> 
> The third patch updates the definition of the sequencer type used
> for an endpoint.  Previously a set of 2-byte symbols with fairly
> long names defined the sequencer type, but now those are broken into
> 1-byte halves whose names are a little more informative.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: ipa: use configuration data for QSB settings
    https://git.kernel.org/netdev/net-next/c/8a81efac9417
  - [net-next,2/5] net: ipa: implement MAX_READS_BEATS QSB data
    https://git.kernel.org/netdev/net-next/c/b9aa0805ed31
  - [net-next,3/5] net: ipa: split sequencer type in two
    https://git.kernel.org/netdev/net-next/c/8ee5df6598ff
  - [net-next,4/5] net: ipa: sequencer type is for TX endpoints only
    https://git.kernel.org/netdev/net-next/c/1690d8a75d87
  - [net-next,5/5] net: ipa: update some comments in "ipa_data.h"
    https://git.kernel.org/netdev/net-next/c/b259cc2a036f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


