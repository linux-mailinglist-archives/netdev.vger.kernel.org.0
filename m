Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F054C358E6E
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 22:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbhDHUas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 16:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231852AbhDHUak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 16:30:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E7A3961107;
        Thu,  8 Apr 2021 20:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617913828;
        bh=zlEt8sfa9ikpx5DLVmtrNwvgiI64gsixBO0bA3L3vds=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EMszeg0NjcT6elLZ8MKGYXdlb+6xS3mg6cDCmoQiz4l/EBdcwoLJvatt47PFa8myI
         b6MV4J+6YDP7QfkqyApfcipUrfanIVDO9x6LblmFImWjp+N09czaXiwmEQxvnkhPF/
         1M70x+6KwblWyGA+NAgKjsbEKJWRy1CAwUCsC0gH6WkyjrRMPo2D4MgegMMYkEsEax
         4dVIhBwvF7+7VP/5GU0tgrzZNO5Zd0DdwtM1a/j3mcLlAUppTxPywOyt1M86dWLlly
         F4VHZvpeekjJsMjW8IBgZdfzXjyri8UiboLmbFPQfSH5mt4pkZHtLgulRP2JHbDMca
         STJvCFtVr7RQw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D72C860BE6;
        Thu,  8 Apr 2021 20:30:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: hns3: add support for pm_ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161791382887.22924.15976610448512026787.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Apr 2021 20:30:28 +0000
References: <1617853205-32760-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1617853205-32760-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 8 Apr 2021 11:40:03 +0800 you wrote:
> This series adds support for pm_ops in the HNS3 ethernet driver.
> 
> Jiaran Zhang (2):
>   net: hns3: change flr_prepare/flr_done function names
>   net: hns3: add suspend and resume pm_ops
> 
>  drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  5 +--
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 37 +++++++++++++++++++---
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 29 ++++++++++-------
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 27 +++++++++-------
>  4 files changed, 68 insertions(+), 30 deletions(-)

Here is the summary with links:
  - [net-next,1/2] net: hns3: change flr_prepare/flr_done function names
    https://git.kernel.org/netdev/net-next/c/bb1890d5f974
  - [net-next,2/2] net: hns3: add suspend and resume pm_ops
    https://git.kernel.org/netdev/net-next/c/715c58e94f0d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


