Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1003C43B26C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235953AbhJZMce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230308AbhJZMcd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 08:32:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1727360ED4;
        Tue, 26 Oct 2021 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635251410;
        bh=+9NWkDl0SxMmp7IYuKzt6vmsnp8lWT2PmpWJqLLd0PY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HYxIcfHKTXQZkrkbW8sGGEZQLM19sJb2253E96qEsC058Fabb6uwWKJ3UXDuREWh9
         JynwihIZplHkAHtixBKbPjZfgoWGsYhtf/kVoXly3ltBmZi0Ok8/synCA6od9h8epo
         1r791ZtPseDUF1csTdwanhq00lbbukzjVeq2Nve/eBdXy/HnWlunEultTBab6i+sCK
         964yjDGsXJ5Za8oWQe0gIOvgCUKP96T7+wBSouPSdkLT7W+lUgd9PUph1h6rEAjJ1w
         BG3w5qXQvdDjpmD1Yceg1nFKk8gsmeQ2VeU3Ahoq+/5ed01KacMcsKea5yC0myn518
         GSsR/YxQJv9Dw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 11102609CC;
        Tue, 26 Oct 2021 12:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/14] net/mlx5e: don't write directly to netdev->dev_addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525141006.31388.1281671672248612333.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 12:30:10 +0000
References: <20211025205431.365080-2-saeed@kernel.org>
In-Reply-To: <20211025205431.365080-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Mon, 25 Oct 2021 13:54:18 -0700 you wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> Use a local buffer and eth_hw_addr_set()
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] net/mlx5e: don't write directly to netdev->dev_addr
    https://git.kernel.org/netdev/net-next/c/537e4d2e6fe3
  - [net-next,02/14] net/mlx5: Remove unnecessary checks for slow path flag
    https://git.kernel.org/netdev/net-next/c/a64c5edbd20e
  - [net-next,03/14] net/mlx5: Fix unused function warning of mlx5i_flow_type_mask
    https://git.kernel.org/netdev/net-next/c/038e5e471874
  - [net-next,04/14] net/mlx5: Reduce flow counters bulk query buffer size for SFs
    https://git.kernel.org/netdev/net-next/c/2fdeb4f4c2ae
  - [net-next,05/14] net/mlx5: Extend health buffer dump
    https://git.kernel.org/netdev/net-next/c/cb464ba53c0c
  - [net-next,06/14] net/mlx5: Print health buffer by log level
    https://git.kernel.org/netdev/net-next/c/b87ef75cb5c9
  - [net-next,07/14] net/mlx5: Add periodic update of host time to firmware
    https://git.kernel.org/netdev/net-next/c/5a1023deeed0
  - [net-next,08/14] net/mlx5: Bridge, extract code to lookup and del/notify entry
    https://git.kernel.org/netdev/net-next/c/2deda2f1bf4e
  - [net-next,09/14] net/mlx5: Bridge, support replacing existing FDB entry
    https://git.kernel.org/netdev/net-next/c/3518c83fc96b
  - [net-next,10/14] net/mlx5: Let user configure io_eq_size param
    https://git.kernel.org/netdev/net-next/c/46ae40b94d88
  - [net-next,11/14] net/mlx5: Let user configure event_eq_size param
    https://git.kernel.org/netdev/net-next/c/a6cb08daa3b4
  - [net-next,12/14] net/mlx5: Let user configure max_macs param
    https://git.kernel.org/netdev/net-next/c/554604061979
  - [net-next,13/14] net/mlx5: SF, Add SF trace points
    https://git.kernel.org/netdev/net-next/c/b3ccada68b2d
  - [net-next,14/14] net/mlx5: SF_DEV Add SF device trace points
    https://git.kernel.org/netdev/net-next/c/d67ab0a8c130

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


