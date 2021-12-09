Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBF546ECD2
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbhLIQNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:13:50 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:55908 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhLIQNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:13:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D0B00CE26DA;
        Thu,  9 Dec 2021 16:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02DCEC341CD;
        Thu,  9 Dec 2021 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639066210;
        bh=GArFYqa9vglTclhOiJ0GItI+agrBFi41MZa9MyWDgyQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r/KMVLKQGo8gHBqB9Yb5/Q+eJNj+w8/5fN7J/+RyskhmQzH1W9Ss/NVns/NbGp65c
         /5ZuzmsPowg6nXXIioW1mEBmSF1avSfVY+EVblYdNVkBJ3XHMKZs+ZkWdhwGo1XqQ7
         +fgUyh9mhbohVRh4+sf7hQ7M/ptD3jM2dVxxFibGrwS9xAZwJlzzMOLBulapbvSBkL
         1XYdvcu2+1zFbvcop6cWa6M9GSwCCtV2OK+6j5QunQWEM9CrpBKM12SIbYt7bPcSqA
         W1C6VX3ClEIQck+12BcP8jbRmjFT9iLCekGHmA6du1/9Xs6927OYLIjcK5qwzxxkwY
         ZkYKGOK07R5Lw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A3EE660A37;
        Thu,  9 Dec 2021 16:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfp: Fix memory leak in nfp_cpp_area_cache_add()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163906620966.18129.17437066396344562752.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 16:10:09 +0000
References: <20211209061511.122535-1-niejianglei2021@163.com>
In-Reply-To: <20211209061511.122535-1-niejianglei2021@163.com>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        libaokun1@huawei.com, oss-drivers@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 14:15:11 +0800 you wrote:
> In line 800 (#1), nfp_cpp_area_alloc() allocates and initializes a
> CPP area structure. But in line 807 (#2), when the cache is allocated
> failed, this CPP area structure is not freed, which will result in
> memory leak.
> 
> We can fix it by freeing the CPP area when the cache is allocated
> failed (#2).
> 
> [...]

Here is the summary with links:
  - nfp: Fix memory leak in nfp_cpp_area_cache_add()
    https://git.kernel.org/netdev/net/c/c56c96303e92

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


