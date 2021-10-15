Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8D742E670
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbhJOCWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229845AbhJOCWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 22:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 70496610D2;
        Fri, 15 Oct 2021 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634264408;
        bh=CAOvE/9B9p05I3vAwzzh6nlLz8jGs76e37bgySMkjMc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NdwcOzyLafKduactLmaBeSnmaAZPZ7Q8azYl52JwyHOyOe4EFnGcZscnKp1DpFCEQ
         lf6KBZHYKyWxu341GTLzCU1Ho3JCbssvvHZjGMP1j5rXS6gRRKeGdPwkTou6LulRO1
         DQm5/qQFvHeQZFEHFJ+mYpayslpqqkAE3b6L055kLj0oOst3UvUF7AmkENzGTK63zu
         8Cv7tCrNnK1UMen7MZ2/fUkVQIVsxUHMmzj6hFsaYCM/lvvaCYjsKlKRz4va2lfzmv
         5GjXv/J8l9ZKh0Vma9rSWYEsMu0iPDJ2+eZFliqJwurr4yM9kGMBQxwDlpxjzhcB0t
         yHZBcvmxU8kxw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 64D7B60A89;
        Fri, 15 Oct 2021 02:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mvneta: Delete unused variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163426440840.28081.6950790415175997547.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 02:20:08 +0000
References: <20211013064921.26346-1-yshaia@marvell.com>
In-Reply-To: <20211013064921.26346-1-yshaia@marvell.com>
To:     Yuval Shaia <yshaia@marvell.com>
Cc:     thomas.petazzoni@bootlin.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 09:49:21 +0300 you wrote:
> The variable pp is not in use - delete it.
> 
> Signed-off-by: Yuval Shaia <yshaia@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)

Here is the summary with links:
  - net: mvneta: Delete unused variable
    https://git.kernel.org/netdev/net-next/c/20d446f24f37

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


