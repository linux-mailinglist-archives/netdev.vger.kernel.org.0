Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4552F33A19A
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 23:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhCMWUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 17:20:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234377AbhCMWUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Mar 2021 17:20:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C813264ECD;
        Sat, 13 Mar 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615674007;
        bh=DfVE1ejHstZHRVGiQjUltVmQGPdFMqOzjDngNqPStb0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QDK0zudY8qhWtXC90bqwIwSJh0Z97RuP/2YXVSwRnHbe1zxmASt0m+57MpY2ycmZG
         gKs8aWC0dAgh92Y2pwmvJWwMUUMFrGpPiCAXlmcbRdrM9NOoEoJOVVKjj0V8mIeYz4
         +wHep/2IWUbzMMUwSSlmy9j3HmnYK4Qo9nxwY90zXVasap5Ta3rnJ4crZTdv/qhper
         nfkGicr1FElteR5krg+3Bde/lIzY0YkW876eylPCF3CYn4GqcY1jurzcVjRwgBNRa9
         k46paRMwNrWE7fjPu6dO80zo5YrEkWAU8BAOaYNMziCKEhTW3e3N3mEH6c73O+hIBg
         raVwUgwmwr4cA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B8A3B60A5C;
        Sat, 13 Mar 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: hns3: support imp-controlled PHYs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161567400775.23306.13076986984276879100.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Mar 2021 22:20:07 +0000
References: <1615539016-45698-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1615539016-45698-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Mar 2021 16:50:12 +0800 you wrote:
> This series adds support for imp-controlled PHYs in the HNS3
> ethernet driver.
> 
> Guangbin Huang (4):
>   net: hns3: add support for imp-controlled PHYs
>   net: hns3: add get/set pause parameters support for imp-controlled
>     PHYs
>   net: hns3: add ioctl support for imp-controlled PHYs
>   net: hns3: add phy loopback support for imp-controlled PHYs
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: hns3: add support for imp-controlled PHYs
    https://git.kernel.org/netdev/net-next/c/f5f2b3e4dcc0
  - [net-next,2/4] net: hns3: add get/set pause parameters support for imp-controlled PHYs
    https://git.kernel.org/netdev/net-next/c/57a8f46b1bd3
  - [net-next,3/4] net: hns3: add ioctl support for imp-controlled PHYs
    https://git.kernel.org/netdev/net-next/c/024712f51e57
  - [net-next,4/4] net: hns3: add phy loopback support for imp-controlled PHYs
    https://git.kernel.org/netdev/net-next/c/b47cfe1f402d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


