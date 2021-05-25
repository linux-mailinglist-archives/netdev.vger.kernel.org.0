Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1D0390C58
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 00:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhEYWll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 18:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229952AbhEYWlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 18:41:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4C1366140E;
        Tue, 25 May 2021 22:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621982409;
        bh=SutcKpjotpBSn5LplW68SZMXYsYXhFGUqJKx0g83yBg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bMuQDeQbAj/CpUGa9pDlij+GYWXWzVf0e9UXm0Jy7QCf6JxsToL503UYfde9Dy23h
         kHYltrt5WVeL/na1Qri4GItJeSvQ+utLuGdcRwBCz2UPQwe7BwxcTfictgKjd4aD/e
         6W04zXZdR1VKczAgNz4rk17pBys6ihdNLgGaTrUcdh5lI2+fRnwAONuByKdVB1cctG
         byMfcQFbfJaIKY6eW8piXZCRZ4AJjrcWfvAhjDzl5GfnFwsa5DZC/hgXJwEmDB/tUm
         tZHNQP+xtTovzhXR3m/TLkzpSne3NFjbs2AKuuYhhtbqZkIjavB+lbHuf1UhXO5Viu
         3/ZmFsOBKNUoQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3F14160A39;
        Tue, 25 May 2021 22:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: zero-initialize tc skb extension on allocation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162198240925.22762.3522660607313028652.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 22:40:09 +0000
References: <20210525132152.2589420-1-vladbu@nvidia.com>
In-Reply-To: <20210525132152.2589420-1-vladbu@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, saeedm@mellanox.com,
        fw@strlen.de, wenxu@ucloud.cn, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 25 May 2021 16:21:52 +0300 you wrote:
> Function skb_ext_add() doesn't initialize created skb extension with any
> value and leaves it up to the user. However, since extension of type
> TC_SKB_EXT originally contained only single value tc_skb_ext->chain its
> users used to just assign the chain value without setting whole extension
> memory to zero first. This assumption changed when TC_SKB_EXT extension was
> extended with additional fields but not all users were updated to
> initialize the new fields which leads to use of uninitialized memory
> afterwards. UBSAN log:
> 
> [...]

Here is the summary with links:
  - [net,v2] net: zero-initialize tc skb extension on allocation
    https://git.kernel.org/netdev/net/c/9453d45ecb6c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


