Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA7437034F
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 00:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhD3WBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 18:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhD3WBA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 18:01:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 25C6A61419;
        Fri, 30 Apr 2021 22:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619820012;
        bh=FY1tDsZz8Rb3CV+bXDy7seY4GnTo85SwVz4Rq7HBSTM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OZ5DJu9jqaf/tgAndPyZnwf9AF7Iv7jxTVDWs9axWlOfApug6fwtMPWfEoyoSpie/
         zUHch1z8ilDZcGj0Ms4NwPGJm26T3l4aqKIZCz60ImcA/WZPerNAQ7kCvl/qC2KzfJ
         l1Uoi+OmUE4dny6BPqEGPs6kJHhxG5k3HcnL+/VaYi2fikYFrYbrhj3T26QCTxltXE
         aYaToinuDzA74ImQKuz5Hg8/tz5zNGNPzGqJoGpeJMvu7oCP22GWDt7BZvGu+9Gxne
         2FiQTA66GkMST95XJfEpwOxi7y+MArF/bvmcYPI+r1s41mCU4eZ3cI161RacCpaosy
         WkCyXIqed7jQg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 178E960A3A;
        Fri, 30 Apr 2021 22:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: hns3: fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161982001209.17924.4267012680088204712.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Apr 2021 22:00:12 +0000
References: <1619773582-17828-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1619773582-17828-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 30 Apr 2021 17:06:18 +0800 you wrote:
> This series adds some bugfixes for the HNS3 ethernet driver.
> 
> Hao Chen (1):
>   net: hns3: fix for vxlan gpe tx checksum bug
> 
> Peng Li (1):
>   net: hns3: use netif_tx_disable to stop the transmit queue
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: hns3: fix for vxlan gpe tx checksum bug
    https://git.kernel.org/netdev/net/c/905416f18fe7
  - [net-next,2/4] net: hns3: use netif_tx_disable to stop the transmit queue
    https://git.kernel.org/netdev/net/c/b416e872be06
  - [net-next,3/4] net: hns3: clear unnecessary reset request in hclge_reset_rebuild
    https://git.kernel.org/netdev/net/c/8c9200e38772
  - [net-next,4/4] net: hns3: disable phy loopback setting in hclge_mac_start_phy
    https://git.kernel.org/netdev/net/c/472497d0bdae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


