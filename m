Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B493509E3
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhCaWA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231974AbhCaWAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 47FC161059;
        Wed, 31 Mar 2021 22:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617228011;
        bh=+aeUi6fehgzfijv/0PF1YnRsgs9pGyHxdhKzwUGz3mg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oAD+4lTnnvfMsxEJPXQc7qkqZ7TBWjQqovl3GdA+1ru4A0hKkKZ5Pznt5Y5OAQJpu
         jZhu+jzAWCphTElW3PRz1/H4FhBj89XCf8JEVTSLozCnwpYQ+0OVxr5vvJjInR74OY
         ao54RJLb2qrCWiqSlOCLRdMsVN0X4w49ZMA8O/VVzg4WqUekjZPNcYmXy34YVKAC9k
         l/Yec7KGTE7pkXgIOejDILCv4cfqEfrXZTB/RTSl5NjKXeQeQQwFGaLfY5v8eKJLsO
         /Lrn32BVHdhDXiJwVPdzzzkhEDC+eRr3T/RAh0HyO+4CqB57kB/1yO3samlfSL0uTM
         KjV8nxs0T3nFA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 379E060283;
        Wed, 31 Mar 2021 22:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/9] net/mlx5e: Fix mapping of ct_label zero
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722801122.26765.1069265901666026497.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 22:00:11 +0000
References: <20210331201424.331095-2-saeed@kernel.org>
In-Reply-To: <20210331201424.331095-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, lariel@nvidia.com, roid@nvidia.com,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 31 Mar 2021 13:14:16 -0700 you wrote:
> From: Ariel Levkovich <lariel@nvidia.com>
> 
> ct_label 0 is a default label each flow has and therefore
> there can be rules that match on ct_label=0 without a prior
> rule that set the ct_label to this value.
> 
> The ct_label value is not used directly in the HW rules and
> instead it is mapped to some id within a defined range and this
> id is used to set and match the metadata register which carries
> the ct_label.
> 
> [...]

Here is the summary with links:
  - [net,1/9] net/mlx5e: Fix mapping of ct_label zero
    https://git.kernel.org/netdev/net/c/d24f847e5421
  - [net,2/9] net/mlx5: Delete auxiliary bus driver eth-rep first
    https://git.kernel.org/netdev/net/c/1f90aedfb496
  - [net,3/9] net/mlx5e: Fix ethtool indication of connector type
    https://git.kernel.org/netdev/net/c/3211434dfe7a
  - [net,4/9] net/mlx5: E-switch, Create vport miss group only if src rewrite is supported
    https://git.kernel.org/netdev/net/c/e929e3da537e
  - [net,5/9] net/mlx5e: kTLS, Fix TX counters atomicity
    https://git.kernel.org/netdev/net/c/a51bce9698e9
  - [net,6/9] net/mlx5e: kTLS, Fix RX counters atomicity
    https://git.kernel.org/netdev/net/c/6f4fdd530a09
  - [net,7/9] net/mlx5: Don't request more than supported EQs
    https://git.kernel.org/netdev/net/c/a7b76002ae78
  - [net,8/9] net/mlx5e: Consider geneve_opts for encap contexts
    https://git.kernel.org/netdev/net/c/929a2faddd55
  - [net,9/9] net/mlx5e: Guarantee room for XSK wakeup NOP on async ICOSQ
    https://git.kernel.org/netdev/net/c/3ff3874fa0b2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


