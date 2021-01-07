Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73712EC72F
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 01:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbhAGAAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 19:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727288AbhAGAAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 19:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0B05923333;
        Thu,  7 Jan 2021 00:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609977609;
        bh=1HeUlOzYotjETGFvwZe4YbBNiJiIsrVk1GcNwNYlWPY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=osNVXRqFZwgVP709+3PAS3T+V2uqkfo+RjLQLElV+VbIpm0hYmoQrr5YRBbIkuFxK
         tZYavr/4rtXmOxZQ9IIsXwl4tGc/6O1E3VwyanHZMHwacWEOy22EuFflFTGsi3lxO+
         +HA2cTU9cYQdnnhY7ukJtDNKaiuoDm/fUEp8M0ovsr9YYG2T7QaekxL1Rb3tLz2v2r
         OAAaIdKVefD6Be4ua+PEA7EbKBOZmlmUvMrfXPr/SocY4AhkxBii3YPtBSn+rpWwyJ
         wuqonziLA0EbaK0GT30MjHk1Jjq9w7LyY8LN65F/dG27+XiXVphGmn2D5EQBYc0OVm
         XYYczsIH98eYA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id F272460385;
        Thu,  7 Jan 2021 00:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: mvneta: fix error message when MTU too large
 for XDP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160997760898.9755.5088554197643994120.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jan 2021 00:00:08 +0000
References: <20210105172333.21613-1-kabel@kernel.org>
In-Reply-To: <20210105172333.21613-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        lorenzo@kernel.org, thomas.petazzoni@bootlin.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  5 Jan 2021 18:23:33 +0100 you wrote:
> The error message says that "Jumbo frames are not supported on XDP", but
> the code checks for mtu > MVNETA_MAX_RX_BUF_SIZE, not mtu > 1500.
> 
> Fix this error message.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Fixes: 0db51da7a8e9 ("net: mvneta: add basic XDP support")
> Cc: Lorenzo Bianconi <lorenzo@kernel.org>
> Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: mvneta: fix error message when MTU too large for XDP
    https://git.kernel.org/netdev/net/c/0d136f5cd9a7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


