Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7868843CB2A
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 15:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbhJ0Nwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 09:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231458AbhJ0Nwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 09:52:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 972CF60F92;
        Wed, 27 Oct 2021 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635342609;
        bh=ynKsqX4KC6p9Dy4EoCgcGjH3Zd+CVxHkC0lBcohHyR8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qVxgogj/jV9H9c6ceM3X+BZ8QFpmVYe/3KQ2jvK5L7KmexkJ+Yf4UvqB2IBGCcZiE
         AfmbPJSYr0NC34R+SMwopKXs71bqm5BcoN69xnrdsRL4Fd6CKrygD5e0dh6GLR31T1
         4uI1+TfL0lAuk/R9LI1J0s5yz2vNdV7IxMOT/5dTnsvMA/a+DQFznUV3i8MZlftlwe
         xPz34dZRip/VlHr38esXvnUrZpX3FXn9zf6/a8nCet4ccokyQvjioc+V9O4Z1bUpXf
         ajppAUmpfV5hz0+cHwgkEMK/EXUFl2DEKFsJVfk6jOTix+qbiI5YRlZStqNFxwooNS
         ZRJrsTQ4Nu9Aw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 903D460A25;
        Wed, 27 Oct 2021 13:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/7] net: hns3: add some fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163534260958.9048.4634038154065865089.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Oct 2021 13:50:09 +0000
References: <20211027121149.45897-1-huangguangbin2@huawei.com>
In-Reply-To: <20211027121149.45897-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Oct 2021 20:11:42 +0800 you wrote:
> This series adds some fixes for the HNS3 ethernet driver.
> 
> Guangbin Huang (4):
>   net: hns3: fix pause config problem after autoneg disabled
>   net: hns3: ignore reset event before initialization process is done
>   net: hns3: expand buffer len for some debugfs command
>   net: hns3: adjust string spaces of some parameters of tx bd info in
>     debugfs
> 
> [...]

Here is the summary with links:
  - [net,1/7] net: hns3: fix pause config problem after autoneg disabled
    https://git.kernel.org/netdev/net/c/3bda2e5df476
  - [net,2/7] net: hns3: change hclge/hclgevf workqueue to WQ_UNBOUND mode
    https://git.kernel.org/netdev/net/c/f29da4088fb4
  - [net,3/7] net: hns3: ignore reset event before initialization process is done
    https://git.kernel.org/netdev/net/c/0251d196b0e1
  - [net,4/7] net: hns3: fix data endian problem of some functions of debugfs
    https://git.kernel.org/netdev/net/c/2a21dab594a9
  - [net,5/7] net: hns3: add more string spaces for dumping packets number of queue info in debugfs
    https://git.kernel.org/netdev/net/c/6754614a787c
  - [net,6/7] net: hns3: expand buffer len for some debugfs command
    https://git.kernel.org/netdev/net/c/c7a6e3978ea9
  - [net,7/7] net: hns3: adjust string spaces of some parameters of tx bd info in debugfs
    https://git.kernel.org/netdev/net/c/630a6738da82

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


