Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B7F364DD1
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhDSWul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229842AbhDSWuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 18:50:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F2CDE61354;
        Mon, 19 Apr 2021 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618872610;
        bh=XcdhX/zVABgqjsjuRJjpKnVHW5Mr8B9vGq63JoXUaCc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SSUfrhZWAfN8q8L1sndVT5OMRb6tD4Ano+U5T8L/E631pJBYnsQd56I28vkSy1qiT
         UUYaogQMwOYTnERU4ewa+KpY+XgndK04mh6SAOafD3nvuFokUxMOqCmHc2+K7JcyKe
         HKHuiHjUtgUJtYmdPi5owhQAzmo52ODM1ooo17R0zhnNUKdxbMXHoHebErYkhWHnWr
         H1k3qgqhdGaqJheLT4MXjfayx02moKMb6ulhCm2elKRkFG1A1Uo7A+TzHJ3O+Y6w46
         KUs/JkCuTlW5A2JSCM2vfnyKRXTnVkaoUUgve+4ZIe5waKrqAbe+cBsXd94HZ0ipBv
         APx+jywz5nVMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ED0AF60A0B;
        Mon, 19 Apr 2021 22:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: hns3: misc updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887260996.25363.5916234572551024850.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 22:50:09 +0000
References: <1618643364-64872-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1618643364-64872-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 17 Apr 2021 15:09:21 +0800 you wrote:
> This series includes some misc updates for the HNS3 ethernet driver.
> 
> Huazhong Tan (3):
>   net: hns3: remove a duplicate pf reset counting
>   net: hns3: cleanup inappropriate spaces in struct hlcgevf_tqp_stats
>   net: hns3: change the value of the SEPARATOR_VALUE macro in
>     hclgevf_main.c
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: hns3: remove a duplicate pf reset counting
    https://git.kernel.org/netdev/net-next/c/1c5a2ba67989
  - [net-next,2/3] net: hns3: cleanup inappropriate spaces in struct hlcgevf_tqp_stats
    https://git.kernel.org/netdev/net-next/c/8ed64dbe0bdf
  - [net-next,3/3] net: hns3: change the value of the SEPARATOR_VALUE macro in hclgevf_main.c
    https://git.kernel.org/netdev/net-next/c/e407efdd94cd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


