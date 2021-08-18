Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02A53F00BF
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhHRJkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231569AbhHRJkm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 05:40:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CA1BE60FBF;
        Wed, 18 Aug 2021 09:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629279607;
        bh=etsauiwRgbWUUiyXYTrfTXaZgodtb9GAtxkxu52BJUA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u+kl/GIy8ocJ/HKLOMYsnTq0xY+MJs1POt/HXwDvgckpq7RFmqkCgbnvjIKpfG1S3
         cV1F934E35pZefzuTDGf2iAzny9SkOEnXmsLaYEU7vCadk+V1J2rtvrajkmBcV6ViK
         ybwX5fC2bYsTL1JizyYc4kdmMyF+C/bJYtVlJxyFMmDx2pjyPt0CMlvE/pift0SWeQ
         l/ImVn70XAnfLYDXJX0Z46+g/PgS4tp8CKovYM4FXHFnygDE5Jy90JiBLDFNTJek4k
         ykiCCbI9uVVV781jmtdADq3UkhzphIaBei5SdcLt8mSr8zD2A8PsaT3489RBMBlc9s
         nazPL9QT3OQDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BFA4C60A25;
        Wed, 18 Aug 2021 09:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: net_namespace: Optimize the code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162927960778.17257.3680341376846353102.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 09:40:07 +0000
References: <20210817152300.10698-1-yajun.deng@linux.dev>
In-Reply-To: <20210817152300.10698-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 17 Aug 2021 23:23:00 +0800 you wrote:
> There is only one caller for ops_free(), so inline it.
> Separate net_drop_ns() and net_free(), so the net_free()
> can be called directly.
> Add free_exit_list() helper function for free net_exit_list.
> 
> ====================
> v2:
>  - v1 does not apply, rebase it.
> ====================
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: net_namespace: Optimize the code
    https://git.kernel.org/netdev/net-next/c/41467d2ff4df

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


