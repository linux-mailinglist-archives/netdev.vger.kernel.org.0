Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAD64650AB
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 16:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239205AbhLAPDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 10:03:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57316 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbhLAPDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 10:03:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A0CAB81DF7
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 15:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42743C53FCC;
        Wed,  1 Dec 2021 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638370812;
        bh=E+TvqxTnujw5hkNDeyBFgT96PNp8YZnui8e5/zqw9bk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z6DGJxuu3xupO5F3X67mok4uk1Ha1qt6V0CJdFWvDMdKH6gGqLYC3uoYSgpmZGgvF
         MLc9jOQLy+J4v49C2+N0+LgMiJQ+Ac3k4rKSIfeoOEclp0otHE3xrMpB7QnIMDdnL8
         DL0sMPex1UqBt/AuyZkzdrrzq3Er+wh8L2A3nH8+bfZIKANekWZ3LYmAQZMf4GKO6v
         ezy3VMsX6g2voImYtMYQpqgFT2+41oNBKtgB7ytQSdL1qeLF8GLk0k0aVzPDwVT6Hs
         6oLdVDL4vB7v9mqmO4Sr+U0JtwQ61HDd28yRVUCyLcQGm2d2ZknG6mjvahIIvw+UE9
         +lhNTbOVbE70g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 253F260A88;
        Wed,  1 Dec 2021 15:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/13] net/mlx5e: IPsec: Fix Software parser inner l3 type
 setting in case of encapsulation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163837081214.15182.14162375624201338855.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Dec 2021 15:00:12 +0000
References: <20211201063709.229103-2-saeed@kernel.org>
In-Reply-To: <20211201063709.229103-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        raeds@nvidia.com, maord@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 30 Nov 2021 22:36:57 -0800 you wrote:
> From: Raed Salem <raeds@nvidia.com>
> 
> Current code wrongly uses the skb->protocol field which reflects the
> outer l3 protocol to set the inner l3 type in Software Parser (SWP)
> fields settings in the ethernet segment (eseg) in flows where inner
> l3 exists like in Vxlan over ESP flow, the above method wrongly use
> the outer protocol type instead of the inner one. thus breaking cases
> where inner and outer headers have different protocols.
> 
> [...]

Here is the summary with links:
  - [net,01/13] net/mlx5e: IPsec: Fix Software parser inner l3 type setting in case of encapsulation
    https://git.kernel.org/netdev/net/c/c65d638ab390
  - [net,02/13] net/mlx5e: Fix missing IPsec statistics on uplink representor
    https://git.kernel.org/netdev/net/c/51ebf5db67f5
  - [net,03/13] net/mlx5e: Sync TIR params updates against concurrent create/modify
    https://git.kernel.org/netdev/net/c/4cce2ccf08fb
  - [net,04/13] net/mlx5: Move MODIFY_RQT command to ignore list in internal error state
    https://git.kernel.org/netdev/net/c/e45c0b34493c
  - [net,05/13] net/mlx5: Lag, Fix recreation of VF LAG
    https://git.kernel.org/netdev/net/c/ffdf45315226
  - [net,06/13] net/mlx5: E-switch, Respect BW share of the new group
    https://git.kernel.org/netdev/net/c/1e59b32e45e4
  - [net,07/13] net/mlx5: E-Switch, fix single FDB creation on BlueField
    https://git.kernel.org/netdev/net/c/43a0696f1156
  - [net,08/13] net/mlx5: E-Switch, Check group pointer before reading bw_share value
    https://git.kernel.org/netdev/net/c/5c4e8ae7aa48
  - [net,09/13] net/mlx5: E-Switch, Use indirect table only if all destinations support it
    https://git.kernel.org/netdev/net/c/e219440da0c3
  - [net,10/13] net/mlx5: Fix use after free in mlx5_health_wait_pci_up
    https://git.kernel.org/netdev/net/c/76091b0fb609
  - [net,11/13] net/mlx5: Fix too early queueing of log timestamp work
    https://git.kernel.org/netdev/net/c/924cc4633f04
  - [net,12/13] net/mlx5: Fix access to a non-supported register
    https://git.kernel.org/netdev/net/c/502e82b91361
  - [net,13/13] net/mlx5e: SHAMPO, Fix constant expression result
    https://git.kernel.org/netdev/net/c/8c8cf0382257

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


