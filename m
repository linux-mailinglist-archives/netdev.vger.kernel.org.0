Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E1A434C19
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhJTNc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230061AbhJTNcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AC3AD61391;
        Wed, 20 Oct 2021 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634736610;
        bh=M+4PQ+7k7nniQ24/ls1I3+8EoaNomf958sOxAUMoCM0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Oget6Te01ZFvMy2CEmlzfLxxYH3jhQGIbRsiArzpFYP3v7fB8p7Ead0ENAPra8p7R
         xjSuiJZu1CxWWPDlAdSA6SibsuiCym6vYakh8Ey1o9Hk1pGzleqa+PJHR5DL5qDgy2
         5bZUk4BYPOyB2VGikf5qjHQivKI4kxqm4JTxrqBwvbC61CXp+oLw+1eOaiKDSGVucq
         TWyLvFn11aVQb4EAFEY4n9vuXmW5eGgvmFciJfVx7+V2sIW2DRBvydepgonEfXrSp8
         fwRcKq/E0mPBI+KHtu2LhAoYlMCL4Nbet5rYSM2vl1KtOWTWyOg1O5KVt4aAI0uSVM
         IxKsSVT3cd92A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A19F9609D1;
        Wed, 20 Oct 2021 13:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] batman-adv: prepare for const netdev->dev_addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163473661065.3411.17859623036163871066.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 13:30:10 +0000
References: <20211019163007.1384352-1-kuba@kernel.org>
In-Reply-To: <20211019163007.1384352-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        b.a.t.m.a.n@lists.open-mesh.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 09:30:07 -0700 you wrote:
> netdev->dev_addr will be constant soon, make sure
> the qualifier is propagated thru batman-adv.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: mareklindner@neomailbox.ch
> CC: sw@simonwunderlich.de
> CC: a@unstable.cc
> CC: sven@narfation.org
> CC: b.a.t.m.a.n@lists.open-mesh.org
> 
> [...]

Here is the summary with links:
  - batman-adv: prepare for const netdev->dev_addr
    https://git.kernel.org/netdev/net-next/c/47ce5f1e3e4e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


