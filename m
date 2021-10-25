Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6AD439739
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbhJYNMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233231AbhJYNMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 09:12:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DB7BD61029;
        Mon, 25 Oct 2021 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635167412;
        bh=morEASi0Zdmv6otgj+vYkYm3PhJeDbtXfPdksqkpOEQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XOlIhmEMMPyEoZfAJADnlmXlXilXWqZakEm2rAk8fV5bafC3c4ybeInjgDqoDuGXj
         hukNhLP8wRsIsICqjcDv4eWYtmfAW70ZbucYt6ev6SqYfjoCN+0Jyh1KYJRZ+8HtbU
         scxh3Woy817ScN0aqi6A+JxVpmYhmPa9cZ67oi/2gFsGm1iJUcK2JXl/aWKyDpF3/L
         o0VmfyN1v5Y1uqDN/zM3XSU+/mJ3suNnVF8JI7zkTkwsVDDkiYy/zYwLtBlR4oHCAm
         15GmzerbqoqtLB+p0DPYdSmR4RgS6MVsKUyKUCWbVPLwGATgSVkH2T/f4iv050+MSM
         gqalxIkKcHd3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C71C660AA5;
        Mon, 25 Oct 2021 13:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/8] net: hns3: updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163516741281.29679.7104225166491558566.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 13:10:12 +0000
References: <20211024094115.42158-1-huangguangbin2@huawei.com>
In-Reply-To: <20211024094115.42158-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 24 Oct 2021 17:41:07 +0800 you wrote:
> This series includes some updates for the HNS3 ethernet driver.
> 
> #1 debugfs support for dumping interrupt coalesce.
> #2~#3 improve compatibility of mac statistic and add pause/pfc durations
>       for it.
> #5~#6 add update ethtool advertised link modes for FIBRE port when autoneg
>       off.
> #7~#8 add some error types for ras.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] net: hns3: add debugfs support for interrupt coalesce
    https://git.kernel.org/netdev/net-next/c/c99fead7cb07
  - [net-next,2/8] net: hns3: modify mac statistics update process for compatibility
    https://git.kernel.org/netdev/net-next/c/0bd7e894dffa
  - [net-next,3/8] net: hns3: device specifications add number of mac statistics
    https://git.kernel.org/netdev/net-next/c/4e4c03f6ab63
  - [net-next,4/8] net: hns3: add support pause/pfc durations for mac statistics
    https://git.kernel.org/netdev/net-next/c/c8af2887c941
  - [net-next,5/8] net: hns3: modify functions of converting speed ability to ethtool link mode
    https://git.kernel.org/netdev/net-next/c/58cb422ef625
  - [net-next,6/8] net: hns3: add update ethtool advertised link modes for FIBRE port when autoneg off
    https://git.kernel.org/netdev/net-next/c/6eaed433ee5f
  - [net-next,7/8] net: hns3: add new ras error type for roce
    https://git.kernel.org/netdev/net-next/c/b566ef60394c
  - [net-next,8/8] net: hns3: add error recovery module and type for himac
    https://git.kernel.org/netdev/net-next/c/da3fea80fea4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


