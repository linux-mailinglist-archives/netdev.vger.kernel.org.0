Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D7F3F6267
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 18:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhHXQKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 12:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhHXQKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 12:10:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DCFEA6135F;
        Tue, 24 Aug 2021 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629821406;
        bh=NFYBQsug1qLmGOJIHQ8wXjC+JoH4ajtAMvdSJrtjmsM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iV3WfeZI8igQJtUGCVVqcrn8Vq1CBraKDta5QtIDiXHYe+BE6syjR1C3dZHwjnJSZ
         ij1EC+gX/Q093IMNxO0Kr+HZGVW4bkYseO17SWSEV2gA1doCowuZdWZiREZcWCoJ5g
         B7jhRwSOG142U5H4pErMHVsF8DlRo3VHAWAGPo66B+IRYBmpKy6iJoweuqMjtm1YHo
         0aNS2JH7DEl8hSgg0ElEWQ88IRotqLMe6rzvFQzg7kVHPmQXKjVQNPQ2TN3S+DK6j+
         /knl/bHS3SGC+z8DrJfzcqMcuP7AYlXmmfiz1yKANpks/6miMiZeDCTrSs8KJzeGfr
         1HyZjtAWm9Wag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CAD696096F;
        Tue, 24 Aug 2021 16:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 net-next 0/4] ethtool: extend coalesce uAPI
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162982140682.5804.10398853408532337419.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Aug 2021 16:10:06 +0000
References: <1629444920-25437-1-git-send-email-moyufeng@huawei.com>
In-Reply-To: <1629444920-25437-1-git-send-email-moyufeng@huawei.com>
To:     moyufeng <moyufeng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        shenjian15@huawei.com, lipeng321@huawei.com,
        yisen.zhuang@huawei.com, linyunsheng@huawei.com,
        huangguangbin2@huawei.com, chenhao288@hisilicon.com,
        salil.mehta@huawei.com, linuxarm@huawei.com,
        linuxarm@openeuler.org, dledford@redhat.com, jgg@ziepe.ca,
        netanel@amazon.com, akiyano@amazon.com, thomas.lendacky@amd.com,
        irusskikh@marvell.com, michael.chan@broadcom.com,
        edwin.peer@broadcom.com, rohitm@chelsio.com,
        jacob.e.keller@intel.com, ioana.ciornei@nxp.com,
        vladimir.oltean@nxp.com, sgoutham@marvell.com, sbhatta@marvell.com,
        saeedm@nvidia.com, ecree.xilinx@gmail.com,
        grygorii.strashko@ti.com, merez@codeaurora.org,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 20 Aug 2021 15:35:16 +0800 you wrote:
> In order to support some configuration in coalesce uAPI, this series
> extend coalesce uAPI and add support for CQE mode.
> 
> Below is some test result with HNS3 driver:
> 1. old ethtool(ioctl) + new kernel:
> estuary:/$ ethtool -c eth0
> Coalesce parameters for eth0:
> Adaptive RX: on  TX: on
> stats-block-usecs: 0
> sample-interval: 0
> pkt-rate-low: 0
> pkt-rate-high: 0
> 
> [...]

Here is the summary with links:
  - [V3,net-next,1/4] ethtool: add two coalesce attributes for CQE mode
    https://git.kernel.org/netdev/net-next/c/029ee6b14356
  - [V3,net-next,2/4] ethtool: extend coalesce setting uAPI with CQE mode
    https://git.kernel.org/netdev/net-next/c/f3ccfda19319
  - [V3,net-next,3/4] net: hns3: add support for EQE/CQE mode configuration
    https://git.kernel.org/netdev/net-next/c/9f0c6f4b7475
  - [V3,net-next,4/4] net: hns3: add ethtool support for CQE/EQE mode configuration
    https://git.kernel.org/netdev/net-next/c/cce1689eb58d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


