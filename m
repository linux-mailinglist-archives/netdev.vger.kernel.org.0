Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFA632DCE1
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhCDWUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:20:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230421AbhCDWUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 486F064FF9;
        Thu,  4 Mar 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614896407;
        bh=DanseyaJDS0X9RQp6uBLZbOQWB3ajvqIMiVhQc6nOOY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JDbSoR/li6h31szziZqmAj84Rk3X0lkFxEkpwM/C6TQeMs6jLvpp2x2xsZfoTD0MO
         XzUCKrGbgYGWWmu3r86COwDDhS2XvrDGE20nHdiwcQvBNajBvZwX+CqvevXNIhHYNC
         tkF7QjN9JH7NIE6AQVw2rOtPp1kJU2nEEGQBvbAiGgO32Ntsq2+nSbq90aAkY/hUpa
         Pw5pTKfY8xaDhXGM/f8sp4l+K0xhyWEhVltYEk/yNqZcF9dIy2MotunlENYOhAVD3A
         Ebe35w1PmAodbQUNYWCfI1GXSW/HW4qjxk3TtbYN+D5Gi/w7r0LtQPs1nZtfMDCx2M
         9NAfsNO0+qiEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3CBEE60A12;
        Thu,  4 Mar 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] nexthop: Do not flush blackhole nexthops when
 loopback goes down
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161489640724.7668.480896092445569577.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 22:20:07 +0000
References: <20210304085754.1929848-1-idosch@idosch.org>
In-Reply-To: <20210304085754.1929848-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, roopa@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  4 Mar 2021 10:57:52 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Patch #1 prevents blackhole nexthops from being flushed when the
> loopback device goes down given that as far as user space is concerned,
> these nexthops do not have a nexthop device.
> 
> Patch #2 adds a test case.
> 
> [...]

Here is the summary with links:
  - [net,1/2] nexthop: Do not flush blackhole nexthops when loopback goes down
    https://git.kernel.org/netdev/net/c/76c03bf8e262
  - [net,2/2] selftests: fib_nexthops: Test blackhole nexthops when loopback goes down
    https://git.kernel.org/netdev/net/c/3a1099d3147f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


