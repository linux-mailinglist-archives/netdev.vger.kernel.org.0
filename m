Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3905C3D8AA3
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbhG1JaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:30:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235584AbhG1JaN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 05:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 783F360FE4;
        Wed, 28 Jul 2021 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627464606;
        bh=y84CMWLeUXt+2/uxGbkmH9iLgL5hFQNM03oKJ/H8qS4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kwd+X9EbtPoZgIjrDDzn5e15VuggdOsk+1ui/+HofgDsOJQ6f54r2oKapC8X/so4Z
         33iDf+7WsSJC/8oaNGZPA+5cPa5Kk6gSA5H5XaeGhUzfi6BIuNjfrLwDvaKkBXyylL
         gnqyGalzKckEkr3gvRUMhzOVd886MXcaJvtPiwvCnlEmLwRmJJJYTNuTo2nsklQ4JQ
         s5xF/+jxLxzaCmB3N0WO63ahXw04gh/FRniWslbjlxvmdOaPJ/vSOCwSGjKgPoydZo
         3RIlICRlmomvBOSQOzXHVvZYFZB1WjnvrB0wJjFkAXNSgYpOYyqsFJzp6X9Z/kENUI
         NIOkfqzAnTgCQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7140760A6C;
        Wed, 28 Jul 2021 09:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 0/3] Remove duplicated devlink registration check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162746460645.7734.12377729175647857455.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Jul 2021 09:30:06 +0000
References: <cover.1627456849.git.leonro@nvidia.com>
In-Reply-To: <cover.1627456849.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     kuba@kernel.org, jiri@nvidia.com, davem@davemloft.net,
        leonro@nvidia.com, netdev@vger.kernel.org, saeedm@nvidia.com,
        vigneshr@ti.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 28 Jul 2021 10:33:44 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v1:
>  * Added two new patches that remove registration field from mlx5 and ti drivers.
> v0: https://lore.kernel.org/lkml/ed7bbb1e4c51dd58e6035a058e93d16f883b09ce.1627215829.git.leonro@nvidia.com
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/3] net: ti: am65-cpsw-nuss: fix wrong devlink release order
    https://git.kernel.org/netdev/net-next/c/acf34954efd1
  - [net-next,v1,2/3] net/mlx5: Don't rely on always true registered field
    https://git.kernel.org/netdev/net-next/c/35f6986743d7
  - [net-next,v1,3/3] devlink: Remove duplicated registration check
    https://git.kernel.org/netdev/net-next/c/d7907a2b1a3b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


