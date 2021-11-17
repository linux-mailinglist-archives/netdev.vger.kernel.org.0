Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7DF453EF6
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhKQDdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:33:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhKQDdG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 22:33:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1F7D6613A3;
        Wed, 17 Nov 2021 03:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637119809;
        bh=PtzhUfn7bXK4j7af+kNRfPgnlZRUjJywXDhtbWAzhuY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bB1ezkpehjjWQkQ8JG+uo8pPCwNwfjDQnH1R2uMk7MXQEGDUERNoUx+IkGRm8ZUhy
         l5OPZzqWvynQOLV3AF4DU1hVLo3rFwfMP6GKUQXNabI6ek/jxNrY/TikwijKF/6mxG
         hejQzoeZ+aXc1YStWmZCFdBFuD75QB5Lz8vEOWf8d2hoBxd+CgIni905fk68F2FEYk
         mgCbBpBZ3k11t1dou4jaY7+gjgqfOIdjWskhycznPDld6Tfm+Klg631QWihb+bvd9H
         IsoWN42IzqoPpsS9zO6gZFwb75BmWqCX1HCBdRgYvMMYVpZAN1Zb0fx1+V1hkP0Z2a
         cR3wnLiIbYVIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 168AB60A0C;
        Wed, 17 Nov 2021 03:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] amt: cancel delayed_work synchronously in amt_fini()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163711980908.5825.9169772862051371831.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 03:30:09 +0000
References: <20211116160923.25258-1-ap420073@gmail.com>
In-Reply-To: <20211116160923.25258-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 16 Nov 2021 16:09:23 +0000 you wrote:
> When the amt module is being removed, it calls cancel_delayed_work()
> to cancel pending delayed_work. But this function doesn't wait for
> canceling delayed_work.
> So, workers can be still doing after module delete.
> 
> In order to avoid this, cancel_delayed_work_sync() should be used instead.
> 
> [...]

Here is the summary with links:
  - [net] amt: cancel delayed_work synchronously in amt_fini()
    https://git.kernel.org/netdev/net/c/b0024a04e488

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


