Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD3D357747
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbhDGWAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhDGWAU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:00:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 479F46115B;
        Wed,  7 Apr 2021 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617832810;
        bh=UThaC7RCv3pc3KfZy53Pw2iEN2Mu8e3d1NPA328me9U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NFlWepllqIzw0Ns6s6JZ6TQ/qMNlED9lg1CGGZEpwmB8GKMVnOIKsy59FbhhsnisR
         NSdBXKE1m1i2y+ceWRZluUJT/nsYBXxTFsdPXrZ0c9U4YJKfDaPMdevFq4wlhYCz1v
         AjqUQsnTzkHJIy+Khb3MNWSxGUmjc2yL40CXq2MnPk2pugBWjgCe1hnWIwY+TtPKFg
         qntLajI2ggdHpgRnKtcc0noq1Iq7QRV9Dbb1F36DZYrCl7uRiG0AUu6MJwMHASH616
         Qxo9WJe62/a34sQey0enx9ihdpeT6Gga4ALlSF4UpfiVoD6Dn/QVXQ0lfx2IGNmagx
         rB2wcFHldmMkg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3726F60A71;
        Wed,  7 Apr 2021 22:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/5] net/mlx5: Fix HW spec violation configuring uplink
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783281022.1764.17622121780034514784.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:00:10 +0000
References: <20210407040620.96841-2-saeed@kernel.org>
In-Reply-To: <20210407040620.96841-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, elic@nvidia.com, roid@nvidia.com,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue,  6 Apr 2021 21:06:16 -0700 you wrote:
> From: Eli Cohen <elic@nvidia.com>
> 
> Make sure to modify uplink port to follow only if the uplink_follow
> capability is set as required by the HW spec. Failure to do so causes
> traffic to the uplink representor net device to cease after switching to
> switchdev mode.
> 
> [...]

Here is the summary with links:
  - [net,1/5] net/mlx5: Fix HW spec violation configuring uplink
    https://git.kernel.org/netdev/net/c/1a73704c82ed
  - [net,2/5] net/mlx5: Fix placement of log_max_flow_counter
    https://git.kernel.org/netdev/net/c/a14587dfc5ad
  - [net,3/5] net/mlx5: Fix PPLM register mapping
    https://git.kernel.org/netdev/net/c/ce28f0fd670d
  - [net,4/5] net/mlx5: Fix PBMC register mapping
    https://git.kernel.org/netdev/net/c/534b1204ca46
  - [net,5/5] net/mlx5: fix kfree mismatch in indir_table.c
    https://git.kernel.org/netdev/net/c/d5f9b005c306

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


