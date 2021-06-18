Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E193AD2B2
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbhFRTWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235336AbhFRTWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 78812613E2;
        Fri, 18 Jun 2021 19:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624044006;
        bh=eaesH0rU8L/78a2RrPwncEIIlrB4iY2N8ZsCl6xI6EI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sNaNf6h/Kbue8FxIoorCWl6HXNWbmDMMDJ2wi8zSlczJw9W4fjB2p9GjBzgUG6fPj
         TW+rEmUav2urY/77LzusoueB5r2okOvh+bi6bQPw3C2iA5T6a3He2eAFCiWomYjOzm
         qvLiQb5mA+mfvNfqrFMOeQhgnIkVr3FDp5WbL1YWgl3HQzRcUZUmCvYntsUauPffO6
         zpRtopdH02TryYhIkTRfCGi4eeA6KAWxt1mMt9liA/haozOlQypFgurkUZuwA+Ddbw
         pp4YnkyohXXfrItMLipANfCCBs0sLoib6jCjrR7vOwMXPsg9YxE1+uYEjy1ffeCoWD
         mXG0JzMUJXpZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 72C0060A17;
        Fri, 18 Jun 2021 19:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qlcnic: remove redundant continue statement
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404400646.12339.12450707599661304526.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:20:06 +0000
References: <20210618101919.101934-1-colin.king@canonical.com>
In-Reply-To: <20210618101919.101934-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 11:19:19 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The continue statement at the end of a for-loop has no effect,
> it is redundant and can be removed.
> 
> Addresses-Coverity: ("Continue has no effect")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - qlcnic: remove redundant continue statement
    https://git.kernel.org/netdev/net-next/c/60ae9f883138

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


