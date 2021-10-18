Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2280B432723
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 21:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhJRTMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 15:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229924AbhJRTMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 15:12:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 27AB86128B;
        Mon, 18 Oct 2021 19:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634584207;
        bh=FnkTef3pvIv3pH9n1Py6dZhuyAWZWEpiOypxxMd888g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uV9aM9GacyR3+qFKEXwohoGf53RBYb31KtQU6UDs2SbK2jyVnq3+/wSq4vy/9ONsG
         N3gif77UDpmk19h2cC983903r5vPtZA97FkXDCKEN1mdUUvo6jDCtGBzP2+LUCm2iK
         7EL2HNNQWs4cmNm6AwsxsC2p+SWnZ/4GPgt2rx+g+r1LRn7ZDJ6zBgyhOPj1YLU3Hd
         yrGKhR4fE4lc4wjP9LldOcFMIKLsbH83VWZ20sK8ZQQjAy27YI7rXAqo1GHFCuP9le
         1wqehcsCCmdmdr9wOynpMsuUpZDXNuDJqTV1Yj96erPlBUkhFONyAUIiMnpAeC0nJO
         ElE6nWvdoCmCA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1528F609E8;
        Mon, 18 Oct 2021 19:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mlx5: prevent 64bit divide
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163458420708.16347.9719520147453300349.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 19:10:07 +0000
References: <20211018172608.1069754-1-kuba@kernel.org>
In-Reply-To: <20211018172608.1069754-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, saeedm@nvidia.com,
        amirtz@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 18 Oct 2021 10:26:08 -0700 you wrote:
> mlx5_tout_ms() returns a u64, we can't directly divide it.
> This is not a problem here, @timeout which is the value
> that actually matters here is already a ulong, so this
> implies storing return value of mlx5_tout_ms() on a ulong
> should be fine.
> 
> This fixes:
> 
> [...]

Here is the summary with links:
  - [net-next] mlx5: prevent 64bit divide
    https://git.kernel.org/netdev/net-next/c/ac6b7e0d9679

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


