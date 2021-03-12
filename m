Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8B3338215
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCLAKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhCLAKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 19:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7533164F94;
        Fri, 12 Mar 2021 00:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615507809;
        bh=uOVYYV1YCWAEMC/RvrT1HZxGF1JSq+39rFFp7YjAv1o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MOyXw279zvTmU5E7WRv1EUeZOtGF0810I00sVy8l8LHww8Wzpt89AWNC8/84FtJbD
         u1n6vTDmwXomCqfXcYlDOhCPiYRE20iL9VfKXEYSzas9UaehFGp6NkGiZ3vWVISWmM
         HgQI73X8TKT4nRB3jJwpZbpuLyouK4TX7uYlB1EtYRMYF5J0/iY/HHPLTKJkvUFKf2
         lC4EBjGiHyqanMIsUxRkZHsp/X3YAVHGHZbHX5d01eZQHDGN5Yn1r+/axfHrNZp4p8
         VVXdvoXrK6pm06eZ7KSrRTurqqdR0+ppj4natPgsgU8c2vs2zl6LqYMDsoOqRlMyjV
         f+HIqsfDlgeBg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 69C06609CD;
        Fri, 12 Mar 2021 00:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: hns3: two updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161550780942.9767.14297288301053264586.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Mar 2021 00:10:09 +0000
References: <1615428852-2637-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1615428852-2637-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Mar 2021 10:14:10 +0800 you wrote:
> This series includes two updates for the HNS3 ethernet driver.
> 
> Yufeng Mo (2):
>   net: hns3: use FEC capability queried from firmware
>   net: hns3: use pause capability queried from firmware
> 
>  drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  4 ++++
>  drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  3 +++
>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  8 +++++++
>  .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  9 +++++++-
>  .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  2 ++
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 26 +++++++++++++++-------
>  6 files changed, 43 insertions(+), 9 deletions(-)

Here is the summary with links:
  - [net-next,1/2] net: hns3: use FEC capability queried from firmware
    https://git.kernel.org/netdev/net-next/c/433ccce83504
  - [net-next,2/2] net: hns3: use pause capability queried from firmware
    https://git.kernel.org/netdev/net-next/c/e8194f326205

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


