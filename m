Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1823A34FC
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhFJUmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230136AbhFJUmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:42:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 795CF6141E;
        Thu, 10 Jun 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623357607;
        bh=qFhXaY96x4J+r31WJzRT4/+8tv52N2bgggbVHaV854Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EdgOUKePhcflRBOEE5JtX4Sxu5xpzFbsNHTd9d2RgPCqP2rv0nl7oR4lpAjSKXkHC
         CCE8gmOU7VwvMPHfwJ1aQKLurSnml5V2QRbilHcOv2e0JV605yCi3DtWRzpI5vmj6h
         ucwUB1qSTNAWVK71yGZIP5VUkW2ef7dfXtOQEwmN0HneM+aVv4zqM2injkb0Cg8eBU
         0WrhKhVnAPEPdmaCaJHTpNNJBPSlh0Vx6B3bC7OG0UvKqbobR7wOt7IinB+T+wvOCz
         x3/uVqNUuV8FV7dDiB6judUF8pwSNfUg0jp8E5d0ETNRgjcqBu0JtimBNgwwQaoI1u
         iZSnO8Rnq5wFg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6E4AB60A0C;
        Thu, 10 Jun 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/16] net/mlx5: mlx5_ifc support for header insert/remove
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335760744.27474.17880453653334060115.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 20:40:07 +0000
References: <20210610025814.274607-2-saeed@kernel.org>
In-Reply-To: <20210610025814.274607-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kliteyn@nvidia.com, vladbu@nvidia.com, jianbol@nvidia.com,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  9 Jun 2021 19:57:59 -0700 you wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> 
> Add support for HCA caps 2 that contains capabilities for the new
> insert/remove header actions.
> 
> Added the required definitions for supporting the new reformat type:
> added packet reformat parameters, reformat anchors and definitions
> to allow copy/set into the inserted EMD (Embedded MetaData) tag.
> 
> [...]

Here is the summary with links:
  - [net-next,01/16] net/mlx5: mlx5_ifc support for header insert/remove
    https://git.kernel.org/netdev/net-next/c/67133eaa93e8
  - [net-next,02/16] net/mlx5: DR, Split reformat state to Encap and Decap
    https://git.kernel.org/netdev/net-next/c/28de41a4ba7b
  - [net-next,03/16] net/mlx5: DR, Allow encap action for RX for supporting devices
    https://git.kernel.org/netdev/net-next/c/d7418b4efa3b
  - [net-next,04/16] net/mlx5: Added new parameters to reformat context
    https://git.kernel.org/netdev/net-next/c/3f3f05ab8872
  - [net-next,05/16] net/mlx5: DR, Added support for INSERT_HEADER reformat type
    https://git.kernel.org/netdev/net-next/c/7ea9b39852fa
  - [net-next,06/16] net/mlx5: DR, Support EMD tag in modify header for STEv1
    https://git.kernel.org/netdev/net-next/c/ded6a877a3fc
  - [net-next,07/16] net/mlx5: Create TC-miss priority and table
    https://git.kernel.org/netdev/net-next/c/ec3be8873df3
  - [net-next,08/16] net/mlx5e: Refactor mlx5e_eswitch_{*}rep() helpers
    https://git.kernel.org/netdev/net-next/c/0781015288ec
  - [net-next,09/16] net/mlx5: Bridge, add offload infrastructure
    https://git.kernel.org/netdev/net-next/c/19e9bfa044f3
  - [net-next,10/16] net/mlx5: Bridge, handle FDB events
    https://git.kernel.org/netdev/net-next/c/7cd6a54a8285
  - [net-next,11/16] net/mlx5: Bridge, dynamic entry ageing
    https://git.kernel.org/netdev/net-next/c/c636a0f0f3f0
  - [net-next,12/16] net/mlx5: Bridge, implement infrastructure for vlans
    https://git.kernel.org/netdev/net-next/c/d75b9e804858
  - [net-next,13/16] net/mlx5: Bridge, match FDB entry vlan tag
    https://git.kernel.org/netdev/net-next/c/ffc89ee5e5e8
  - [net-next,14/16] net/mlx5: Bridge, support pvid and untagged vlan configurations
    https://git.kernel.org/netdev/net-next/c/36e55079e549
  - [net-next,15/16] net/mlx5: Bridge, filter tagged packets that didn't match tagged fg
    https://git.kernel.org/netdev/net-next/c/cc2987c44be5
  - [net-next,16/16] net/mlx5: Bridge, add tracepoints
    https://git.kernel.org/netdev/net-next/c/9724fd5d9c2a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


