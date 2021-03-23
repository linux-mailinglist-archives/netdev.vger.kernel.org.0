Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D82C3453E4
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhCWAat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhCWAaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 20:30:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9F577619B0;
        Tue, 23 Mar 2021 00:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616459411;
        bh=c0+shOHvsvUpwlJgTN5HJd949jssva7jT1wPpik5BwI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GbdSNv4HdI5RV7EBOEx6V77ShBIvqbvTBP6xF07f25z71tciuQpRhR6V+zXqb5kbZ
         yZpXD49o61J3EK1jgvZgwLsOlfBb5DYoi9QmwRl5bKe4JrF7Q8Y5RMGz5YmXlU734j
         8sD6rgc1aRkgTX1JZD4NeNIvmsfzVp6D+QK0vUbHEtoL/SU8GSGcQuXFizKCcn5+2A
         M0u3YWg5exokrb9vaOWprtK3fi5c6Vp+enbiU8DVcbz6r//NxCtzaWfz4Lza7ycMhM
         osmIpLZ8+H3ebg5BjCe1NMuWkEp4y6bZTV9CV3kBrHV+bwvrWAzCVnyVFSfQuy8/rL
         Fz/MWK0E2yhBQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9B1DA60A3E;
        Tue, 23 Mar 2021 00:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: set initial device refcount to 1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161645941163.31154.6407604141530690232.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Mar 2021 00:30:11 +0000
References: <20210322182145.531377-1-eric.dumazet@gmail.com>
In-Reply-To: <20210322182145.531377-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, groeck@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 11:21:45 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> When adding CONFIG_PCPU_DEV_REFCNT, I forgot that the
> initial net device refcount was 0.
> 
> When CONFIG_PCPU_DEV_REFCNT is not set, this means
> the first dev_hold() triggers an illegal refcount
> operation (addition on 0)
> 
> [...]

Here is the summary with links:
  - [net-next] net: set initial device refcount to 1
    https://git.kernel.org/netdev/net-next/c/add2d7363107

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


