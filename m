Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185204349CC
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhJTLMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhJTLMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 07:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DAD83613DA;
        Wed, 20 Oct 2021 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634728208;
        bh=2ikCybl+SX3tc4V/4XkEaPPXo4CBWl30eoBMDR8u3zg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uur1Rut0PajUINEAh0dDphD42xLTHTTHBcWc+XsLcG9ZVt4wZyP8sGAa82qbJKoMK
         7+TfjbuesbafsAeIpXqMyY9a8Si9px4Jya4POnE4Nq+VUA8XJ/R3mYb9LCxBPBcYAR
         eJTr5ppuU3UKmhfHqn9hmr+MGJaLzKf4KwCyIJHrGj6SHhKciZ5CCrI4DU2yg7jvk7
         XfSz9oO47YhQYRpfkmBjdbaQosndNEVJdJtGjBZ85HwXiXQ4hlttg2iHAh1LF5JM9P
         pi+sNTDHDlsVzzaZguYmfWJkHLpfLkrJROfCfT8+/r0QfL+mRtYKb3S7zTNMWm42Kv
         c6YlfACiPfBZQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CE27A60A47;
        Wed, 20 Oct 2021 11:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/8] net: hns3: add some fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163472820883.2036.5031929864760580084.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 11:10:08 +0000
References: <20211019141635.43695-1-huangguangbin2@huawei.com>
In-Reply-To: <20211019141635.43695-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 22:16:27 +0800 you wrote:
> This series adds some fixes for the HNS3 ethernet driver.
> 
> Guangbin Huang (2):
>   net: hns3: reset DWRR of unused tc to zero
>   net: hns3: add limit ets dwrr bandwidth cannot be 0
> 
> Jiaran Zhang (1):
>   net: hns3: Add configuration of TM QCN error event
> 
> [...]

Here is the summary with links:
  - [net,1/8] net: hns3: Add configuration of TM QCN error event
    https://git.kernel.org/netdev/net/c/60484103d5c3
  - [net,2/8] net: hns3: reset DWRR of unused tc to zero
    https://git.kernel.org/netdev/net/c/b63fcaab9598
  - [net,3/8] net: hns3: add limit ets dwrr bandwidth cannot be 0
    https://git.kernel.org/netdev/net/c/731797fdffa3
  - [net,4/8] net: hns3: fix the max tx size according to user manual
    https://git.kernel.org/netdev/net/c/adfb7b4966c0
  - [net,5/8] net: hns3: fix for miscalculation of rx unused desc
    https://git.kernel.org/netdev/net/c/9f9f0f19994b
  - [net,6/8] net: hns3: schedule the polling again when allocation fails
    https://git.kernel.org/netdev/net/c/68752b24f51a
  - [net,7/8] net: hns3: fix vf reset workqueue cannot exit
    https://git.kernel.org/netdev/net/c/1385cc81baeb
  - [net,8/8] net: hns3: disable sriov before unload hclge layer
    https://git.kernel.org/netdev/net/c/0dd8a25f355b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


