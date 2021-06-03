Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAA039ADD2
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhFCWVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230265AbhFCWVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2E00E613DA;
        Thu,  3 Jun 2021 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622758806;
        bh=qb4IAshVkzkipeG2yL2ZgC3T6gjoePkoZYpLUcM5NAQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lXy6wffNvrPHv75WMQoNyh2qHptohqkK2mf9otK9BD72GOoSqsHa3VPvbFrxUjTde
         rn1rxW+LC3OS9/y3BbiXWyJoWRLkDhd/YTk6RfXLhyYsUgVE4KqgxQkeB9wpBItwKr
         mfiG6aNqmZzxRn2KD001TogNyOe9ddZ1B2hlfqSYjxcVYWEvAo1r3tOBs1I1ehOlyC
         13Wjdnetl/stQENVTMW4fLQfomMx1Itcj8JC5nehDJTjTyMub/rtvwGMOpXq2kzJel
         0W0mLJHtrkqUa35fEzymrmrHc4oUwAF9/Tn/C5LWcQJ3Xd/NEttAlRojJxnXgZGiHJ
         xR5WgGfgATuXA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1AAEA60BFB;
        Thu,  3 Jun 2021 22:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/4] net: caif: fix 2 memory leaks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275880610.4249.1070096143129152131.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:20:06 +0000
References: <cover.1622737854.git.paskripkin@gmail.com>
In-Reply-To: <cover.1622737854.git.paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        sjur.brandeland@stericsson.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  3 Jun 2021 19:37:27 +0300 you wrote:
> This patch series fix 2 memory leaks in caif
> interface.
> 
> Syzbot reported memory leak in cfserl_create().
> The problem was in cfcnfg_add_phy_layer() function.
> This function accepts struct cflayer *link_support and
> assign it to corresponting structures, but it can fail
> in some cases.
> 
> [...]

Here is the summary with links:
  - [1/4] net: caif: added cfserl_release function
    https://git.kernel.org/netdev/net/c/bce130e7f392
  - [2/4] net: caif: add proper error handling
    https://git.kernel.org/netdev/net/c/a2805dca5107
  - [3/4] net: caif: fix memory leak in caif_device_notify
    https://git.kernel.org/netdev/net/c/b53558a950a8
  - [4/4] net: caif: fix memory leak in cfusbl_device_notify
    https://git.kernel.org/netdev/net/c/7f5d86669fa4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


