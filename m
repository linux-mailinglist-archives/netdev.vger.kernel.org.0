Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03BA2E9FA2
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 22:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbhADVut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 16:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:42232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbhADVut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 16:50:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BBA71221F8;
        Mon,  4 Jan 2021 21:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609797008;
        bh=sEjZsIY7NIjVcoXVyaImQyJSox3VgCIlR0SohfJnZxM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aiuk5sXyq84BdqdXD22k8IixLKOpp1VtBmb8CYbzYI0Lj4x57saHsfev/UxaJ6OXr
         LhVpeE+pC3bCMygruxFcP+IET62nrXz9Q90EkmpTPhOQTnUzRr5AogXeKyt73ezqIZ
         IohYfVfyD1lyKGVE68mD/qS/Z6kHXMB1YWNjamxUOePpnzbnF88udaBecmCDkcl+Ni
         qZQ55uEAQZh1UVaYG4vl82Hm6t10YAkwlxZy8vHsjDlFHB2tyUPmKieg4SNxa8rjhe
         bPMhXEqPfMff5NsfbF7AOHRN1H/RHoos7TCakGNt3zwW5LELqaZ/EUiDsK8XkISDs0
         +DmclHiqoTe/A==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id B1041604FC;
        Mon,  4 Jan 2021 21:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] r8169: work around power-saving bug on some chip versions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160979700872.8172.10618458139955948898.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jan 2021 21:50:08 +0000
References: <a1c39460-d533-7f9e-fa9d-2b8990b02426@gmail.com>
In-Reply-To: <a1c39460-d533-7f9e-fa9d-2b8990b02426@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 30 Dec 2020 19:33:34 +0100 you wrote:
> A user reported failing network with RTL8168dp (a quite rare chip
> version). Realtek confirmed that few chip versions suffer from a PLL
> power-down hw bug.
> 
> Fixes: 07df5bd874f0 ("r8169: power down chip in probe")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] r8169: work around power-saving bug on some chip versions
    https://git.kernel.org/netdev/net/c/e80bd76fbf56

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


