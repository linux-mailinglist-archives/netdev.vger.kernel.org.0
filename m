Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E9E39AE0F
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhFCWbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231161AbhFCWbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:31:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C08716140F;
        Thu,  3 Jun 2021 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622759407;
        bh=cRg13y2KjZ3vh8Pmu/E2uZVlpUEmuiVviXdHjPjrVBE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NbaDOkuEJ7lhjqkNF6H7iXG+0YVdPl/CPjYtT+a7+nBLHEiuIp4Yvs2YNN/9breyC
         aJIqUPtrSt+dnmnXnsjVNQMBy8M2gwQGgQlUOHdVYzGzgqepmuTc1CAtPSXzX6dJDP
         t6UTP4SFrN3yWTpcbO+y03VlTPevoUizqiIaxGmghtOPiUJ3wr+P76OnyJvy4CcBOx
         L6TXH8dsRqgG3SRheOXvtJTW91qhOIwyI1l3KRRls+ICC4JvWw2mt0mYh+pHcXuNok
         rnDJguza6pAggJSWl648Uj54TAUz9tgGvQSQYXS3iXl5i2avV5bS+G4BvCubreFZIY
         P0FLZKK1EM9vQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B594960A6C;
        Thu,  3 Jun 2021 22:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/10] mlx5: count all link events
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275940773.8870.12252699296140225818.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:30:07 +0000
References: <20210603201155.109184-2-saeed@kernel.org>
In-Reply-To: <20210603201155.109184-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  3 Jun 2021 13:11:46 -0700 you wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> mlx5 devices were observed generating MLX5_PORT_CHANGE_SUBTYPE_ACTIVE
> events without an intervening MLX5_PORT_CHANGE_SUBTYPE_DOWN. This
> breaks link flap detection based on Linux carrier state transition
> count as netif_carrier_on() does nothing if carrier is already on.
> Make sure we count such events.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] mlx5: count all link events
    https://git.kernel.org/netdev/net-next/c/490dcecabbf9
  - [net-next,02/10] net/mlx5: Fix duplicate included vhca_event.h
    https://git.kernel.org/netdev/net-next/c/e6dfa4a54a90
  - [net-next,03/10] net/mlx5: check for allocation failure in mlx5_ft_pool_init()
    https://git.kernel.org/netdev/net-next/c/b74fc1ca6a45
  - [net-next,04/10] net/mlx5e: Remove the repeated declaration
    https://git.kernel.org/netdev/net-next/c/c4cf987ebe14
  - [net-next,05/10] net/mlx5e: IPoIB, Add support for NDR speed
    https://git.kernel.org/netdev/net-next/c/ab57a912befe
  - [net-next,06/10] net/mlx5e: Zero-init DIM structures
    https://git.kernel.org/netdev/net-next/c/771a563ea05b
  - [net-next,07/10] net/mlx5e: RX, Re-place page pool numa node change logic
    https://git.kernel.org/netdev/net-next/c/8ec5d438a3c2
  - [net-next,08/10] net/mlx5e: Disable TX MPWQE in kdump mode
    https://git.kernel.org/netdev/net-next/c/040ee6172e77
  - [net-next,09/10] net/mlx5e: Disable TLS device offload in kdump mode
    https://git.kernel.org/netdev/net-next/c/39e8cc6d757a
  - [net-next,10/10] net/mlx5e: Remove unreachable code in mlx5e_xmit()
    https://git.kernel.org/netdev/net-next/c/f68406ca3b77

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


