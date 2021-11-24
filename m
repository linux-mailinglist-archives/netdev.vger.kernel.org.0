Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608B745C75C
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 15:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355045AbhKXOd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 09:33:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355022AbhKXOdT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 09:33:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0854960273;
        Wed, 24 Nov 2021 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637764210;
        bh=hzij1PTVKwykaHlENjrWj0gL3uLeAp7fu3hxPDAcIIo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nGYYCEk7nQWadWlli4bvqJjk3EeLuM7SwM+Rk0kwSrGN9clc4rJj+u7ZhycUmjoyF
         +NnQWRdt8sJTkBeFevkqJZ3Lc9elq7UXkthVqu6yQEj9/TvZ3N1qGlZrmz4U63gdoq
         xoXh0Oym8tDiJuPVyP/qr1B0cHlEK9w/Dq4UCOJlyJtv1Q5cPlOBFsfOWexBoIaKKT
         5AOgzJWtMns1tIGCeXf6/T+xO8mEwbI3Z7GS9w8FVQdzqh4OCCPpK9FrgrUBrPPQX5
         njsuVe8MZ46POLWICGXoXntwqBmoHPwwyTdw77F4ZeFUe8rSnW1mA3kHNO79dCkr37
         KWsvmzQuOU+fw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F0A2D609D5;
        Wed, 24 Nov 2021 14:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: hns3: updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163776420998.4552.2505811247513302335.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Nov 2021 14:30:09 +0000
References: <20211124010654.6753-1-huangguangbin2@huawei.com>
In-Reply-To: <20211124010654.6753-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 24 Nov 2021 09:06:50 +0800 you wrote:
> This series includes some updates for the HNS3 ethernet driver.
> 
> Jie Wang (1):
>   net: hns3: debugfs add drop packet statistics of multicast and
>     broadcast for igu
> 
> Yufeng Mo (3):
>   net: hns3: add log for workqueue scheduled late
>   net: hns3: format the output of the MAC address
>   net: hns3: add dql info when tx timeout
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: hns3: add log for workqueue scheduled late
    https://git.kernel.org/netdev/net-next/c/d9069dab2075
  - [net-next,2/4] net: hns3: format the output of the MAC address
    https://git.kernel.org/netdev/net-next/c/4f331fda35f1
  - [net-next,3/4] net: hns3: debugfs add drop packet statistics of multicast and broadcast for igu
    https://git.kernel.org/netdev/net-next/c/8488e3c68214
  - [net-next,4/4] net: hns3: add dql info when tx timeout
    https://git.kernel.org/netdev/net-next/c/db596298edbf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


