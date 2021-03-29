Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1786034D923
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhC2Ukg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhC2UkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:40:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0877261990;
        Mon, 29 Mar 2021 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617050410;
        bh=bjTMgR6IJ+pke6CYMseFAobc/TlJiwTIpg3Yafh9SKM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A+CHRog8eB2nM1U0XUzoA6Xi2FSqrtju80VEVkOZU/Fw3rINd++tUb1eeagwQPifP
         29+gNfwfCnmiVyXYIp8e3IGnAOdwmTJ0h0oYwrtxR8xYokg5Ws3A/pN9RK1fMgyZy7
         Qr6NxQ5LRMBITEq9CpSrl0HOLAhjDa5DglpV+e2jo1BDDP+fdjw4kq2thTPE14BEIZ
         xovZDoMkCB5/7Zi7jNqXEkmXk+rEzFPnczPpS2N7uQXSX30z/s4KggY1IlohYDltUs
         KCUC11WK7Nr2WCkoEyWaHUqSHfh/fNCV1UmYx91KBme3w/htqc9I8n4UkEbM64pRZs
         eIw31hiB3QTeA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 032C460A48;
        Mon, 29 Mar 2021 20:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: marvell: fix some coding style
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161705041000.15223.7724570525686809883.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 20:40:10 +0000
References: <1617004872-38974-1-git-send-email-liweihang@huawei.com>
In-Reply-To: <1617004872-38974-1-git-send-email-liweihang@huawei.com>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        sebastian.hesselbarth@gmail.com, thomas.petazzoni@bootlin.com,
        mlindner@marvell.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 16:01:08 +0800 you wrote:
> Do some cleanups according to the coding style of kernel.
> 
> Yangyang Li (4):
>   net: marvell: Delete duplicate word in comments
>   net: marvell: Fix the trailing format of some block comments
>   net: marvell: Delete extra spaces
>   net: marvell: Fix an alignment problem
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: marvell: Delete duplicate word in comments
    https://git.kernel.org/netdev/net-next/c/b52f6425481c
  - [net-next,2/4] net: marvell: Fix the trailing format of some block comments
    https://git.kernel.org/netdev/net-next/c/df4a17a98d7f
  - [net-next,3/4] net: marvell: Delete extra spaces
    https://git.kernel.org/netdev/net-next/c/9abcaa96ce6d
  - [net-next,4/4] net: marvell: Fix an alignment problem
    https://git.kernel.org/netdev/net-next/c/9568387c9f51

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


