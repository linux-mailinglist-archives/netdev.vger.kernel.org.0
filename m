Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755B031A6C4
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhBLVVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 16:21:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232068AbhBLVUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 16:20:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 78E1864E08;
        Fri, 12 Feb 2021 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613164810;
        bh=LqTjPafDoU9bS6JV9UqVsOkKo1KXIyuaMm7S+DlDx9k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W3tiSyZK9dmAPd4JK/c2uekcyBp0MP8fxvFKuT2VLoksDK3AqoW7xY4vwEnAZWoEK
         moyylG1imne+EaX4a1zTec90e9krbldn46mMUk+Dfw4ndyciCT+JqhZmkBrpNX5x/m
         ysKrYqqXMhSsRJ8oWBvyP/bIrDMxtqbUFGoca2U97ptulmGves7aEK7qVKb8iRzHrc
         1oIXl/PpuLMOlVH5aTWGnqzsuIgkltg15RTtvE/OKvnXDsrXlm9n9LrAUUeqJIPnOY
         ueHVXYatp4k/pdzBkT5mGvdTBmHfllvblBRmKm2C2/GSoLmA5K32zL9Sy4VH5V7uHT
         JJWStQQkQuumg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6CDBC60A2A;
        Fri, 12 Feb 2021 21:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 00/13] net: hns3: some cleanups for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161316481044.12385.10525514068157683118.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Feb 2021 21:20:10 +0000
References: <20210212032113.5384-1-tanhuazhong@huawei.com>
In-Reply-To: <20210212032113.5384-1-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Feb 2021 11:21:00 +0800 you wrote:
> To improve code readability and maintainability, the series
> refactor out some bloated functions in the HNS3 ethernet driver.
> 
> change log:
> V2: remove an unused variable in #5
> 
> previous version:
> V1: https://patchwork.kernel.org/project/netdevbpf/cover/1612943005-59416-1-git-send-email-tanhuazhong@huawei.com/
> 
> [...]

Here is the summary with links:
  - [V2,net-next,01/13] net: hns3: refactor out hclge_cmd_convert_err_code()
    https://git.kernel.org/netdev/net-next/c/1c9a98b0ba1f
  - [V2,net-next,02/13] net: hns3: refactor out hclgevf_cmd_convert_err_code()
    https://git.kernel.org/netdev/net-next/c/433e2802775c
  - [V2,net-next,03/13] net: hns3: clean up hns3_dbg_cmd_write()
    https://git.kernel.org/netdev/net-next/c/c318af3f5684
  - [V2,net-next,04/13] net: hns3: use ipv6_addr_any() helper
    https://git.kernel.org/netdev/net-next/c/eaede835675c
  - [V2,net-next,05/13] net: hns3: refactor out hclge_set_vf_vlan_common()
    https://git.kernel.org/netdev/net-next/c/88936e320c1a
  - [V2,net-next,06/13] net: hns3: refactor out hclge_get_rss_tuple()
    https://git.kernel.org/netdev/net-next/c/405642a15cba
  - [V2,net-next,07/13] net: hns3: refactor out hclgevf_get_rss_tuple()
    https://git.kernel.org/netdev/net-next/c/73f7767ed0f9
  - [V2,net-next,08/13] net: hns3: split out hclge_dbg_dump_qos_buf_cfg()
    https://git.kernel.org/netdev/net-next/c/b3712fa73d56
  - [V2,net-next,09/13] net: hns3: split out hclge_cmd_send()
    https://git.kernel.org/netdev/net-next/c/76f82fd9b123
  - [V2,net-next,10/13] net: hns3: split out hclgevf_cmd_send()
    https://git.kernel.org/netdev/net-next/c/eb0faf32b86e
  - [V2,net-next,11/13] net: hns3: refactor out hclge_set_rss_tuple()
    https://git.kernel.org/netdev/net-next/c/e291eff3bce4
  - [V2,net-next,12/13] net: hns3: refactor out hclgevf_set_rss_tuple()
    https://git.kernel.org/netdev/net-next/c/5fd0e7b4f7bf
  - [V2,net-next,13/13] net: hns3: refactor out hclge_rm_vport_all_mac_table()
    https://git.kernel.org/netdev/net-next/c/80a9f3f1fa81

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


