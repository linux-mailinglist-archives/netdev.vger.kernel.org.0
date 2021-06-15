Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92E43A878E
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 19:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhFORcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 13:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230506AbhFORcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 13:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1FFAF61410;
        Tue, 15 Jun 2021 17:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623778204;
        bh=ruOmnkYu+/y18YVU7ZKGdWrKmlayBFEh1kkkhqIsZO8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vI/fEfbW0SLojT9pSYbswEYYNCDELgxZL61hER3AxpTTFTowSzbRljJtUFfsn+T7I
         SXyQl4T6uY2tGSKchtKkkfw/WrD4atokEfsLDE+ze5/ZjxHhZJ9rZI3wTHnybTE+qc
         VO4vACN+xjOnMMMlZVcHvhSSCcFThht5/OHCo93hPMIXxadoHdQCGOCgyfDofAXeJF
         rdUrp8fSltrFlf84qX1sDO8qrDD+hG/B4/iUJxdNu23aKYkgTEUAWDRHix16SuNbtn
         76S7BnA9zzNAEOvuqB5c0j8K3jY147QBTH8Pv7pRAqYMiC4QKgP3eQ+x85TeFHJ6ps
         ojsp+gNBCVfbQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 103DE6095D;
        Tue, 15 Jun 2021 17:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] stmmac: align RX buffers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162377820406.32202.2352789207444259585.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Jun 2021 17:30:04 +0000
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
In-Reply-To: <20210614022504.24458-1-mcroce@linux.microsoft.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, davem@davemloft.net, kuba@kernel.org,
        palmer@dabbelt.com, paul.walmsley@sifive.com, drew@beagleboard.org,
        kernel@esmil.dk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Jun 2021 04:25:04 +0200 you wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> On RX an SKB is allocated and the received buffer is copied into it.
> But on some architectures, the memcpy() needs the source and destination
> buffers to have the same alignment to be efficient.
> 
> This is not our case, because SKB data pointer is misaligned by two bytes
> to compensate the ethernet header.
> 
> [...]

Here is the summary with links:
  - [net-next] stmmac: align RX buffers
    https://git.kernel.org/netdev/net-next/c/a955318fe67e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


