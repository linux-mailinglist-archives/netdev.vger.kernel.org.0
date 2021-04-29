Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3835136F2BC
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 00:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhD2Wu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 18:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhD2Wu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 18:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 07A2561469;
        Thu, 29 Apr 2021 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619736611;
        bh=v6m9gsBEw1/qW/wbawxF9ncZ1zWCjqz/4SZ5loIH2dY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CAZEGrOjQVcjkX9HSK76ZGiuCt4U145ddsPCWDMDaGMg5hfpfskGjPz3GIKxiN7c0
         Ww2q8mwmPxvtw1h5PA1X4kt+3qqunKfta8qrnjndSHglAl3r2zcx5sP2rfqkflJWi0
         5+Wqn1JBPBVnsY4Q2xpRCmYQpqlxFOOD0Len/TZQvotStg7lzEAfAELfLE6gnia+yE
         KCA9nUWInXliltbIwgRMC0lD7QdL6YFaP1ZrQVKNt8fByxoyHUFc05zT/1UBAeQTeR
         A0I+R2/F6Eg5AkDBxkIs+vzg65lqPF2N1bYoklumOl3kB9yuaPy0SlO7pZ2CuHSce9
         +dwSR4MWUR+pA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EF1EA60A3A;
        Thu, 29 Apr 2021 22:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] net: hns3: add some fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161973661097.21217.1221925214079457312.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Apr 2021 22:50:10 +0000
References: <1619685292-46644-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1619685292-46644-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 29 Apr 2021 16:34:49 +0800 you wrote:
> This series adds some fixes for the HNS3 ethernet driver.
> 
> Jian Shen (1):
>   net: hns3: add check for HNS3_NIC_STATE_INITED in
>     hns3_reset_notify_up_enet()
> 
> Yufeng Mo (2):
>   net: hns3: fix incorrect configuration for igu_egu_hw_err
>   net: hns3: initialize the message content in hclge_get_link_mode()
> 
> [...]

Here is the summary with links:
  - [net,1/3] net: hns3: fix incorrect configuration for igu_egu_hw_err
    https://git.kernel.org/netdev/net/c/2867298dd49e
  - [net,2/3] net: hns3: initialize the message content in hclge_get_link_mode()
    https://git.kernel.org/netdev/net/c/568a54bdf70b
  - [net,3/3] net: hns3: add check for HNS3_NIC_STATE_INITED in hns3_reset_notify_up_enet()
    https://git.kernel.org/netdev/net/c/b4047aac4ec1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


