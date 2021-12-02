Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9182E466370
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357865AbhLBMXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357837AbhLBMXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:23:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB000C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 04:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A50DCB8234E
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 12:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1599BC5674A;
        Thu,  2 Dec 2021 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638447611;
        bh=X+LK0LEdmoDQwPZ6GRJFHVG5GIefxiS5d9hE38Wzuuc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WHLeCwa+Tiut9azJpCnG4Vx6CJ2APwjJG7ndsDnHW4Hsqh2J4zFtENeiARYsg+Sda
         2zYD0BEp/2pd2t3B+FbD/zcvw+0cvhe4d4pnE+EMTuTLmJFXIsls+BFX006YZKWxUp
         1N0pMZgXwHAsGX7QIiYjT/IshLJ/D2B5jGyaJOhCKOb4PH+qS6BsLc5dWf004Hp8Kb
         JuJ7C+1If1eiCwLLob3tSq+z+voQdNqaeSYiP7ror8vCa++jyNG3GeEsDjBpE/Ibie
         IO+D79kWxEV8ZIrVWyZYGpPhyo5J1mIa7rLBmtsSLgBXxmpYazRWsxyhGnjJjF4gR0
         1eTHLJIBSHODw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DFBEE60C85;
        Thu,  2 Dec 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] ibmvnic: drop bad optimization in reuse_rx_pools()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844761091.9736.15252201622939218179.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:20:10 +0000
References: <20211201054836.3488211-1-sukadev@linux.ibm.com>
In-Reply-To: <20211201054836.3488211-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, brking@linux.ibm.com, drt@linux.ibm.com,
        ricklind@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 21:48:35 -0800 you wrote:
> When trying to decide whether or not reuse existing rx/tx pools
> we tried to allow a range of values for the pool parameters rather
> than exact matches. This was intended to reuse the resources for
> instance when switching between two VIO servers with different
> default parameters.
> 
> But this optimization is incomplete and breaks when we try to
> change the number of queues for instance. The optimization needs
> to be updated, so drop it for now and simplify the code.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ibmvnic: drop bad optimization in reuse_rx_pools()
    https://git.kernel.org/netdev/net/c/0584f4949609
  - [net,2/2] ibmvnic: drop bad optimization in reuse_tx_pools()
    https://git.kernel.org/netdev/net/c/5b08560181b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


