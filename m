Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6163EC2CA
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 15:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238423AbhHNNKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 09:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233729AbhHNNKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 09:10:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BAA9960F4B;
        Sat, 14 Aug 2021 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628946606;
        bh=Pa7sF5Dj+in1mS7svzye/SyTPKZcxm8/U476DIyvNH4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TXLIlWao5NFox3FuofdoMZDGZlXEYM1bQU7JKS4U0bc2uw6P87eXFp4eTwLQK0axJ
         U3nkwhwpkV+FWg6cxdRf7xu+DTYixkJeCmc3Av/VUMMxwdlsFHOa2QwjIMVD4/iZrl
         6ak3Bzd3qVTtS9k3/cKvxDdg+4FTMlXx9upgkTXLbMrjuXW75eQ+ZUAEN+VHdDkjNs
         exr7ocUmoDuTkXfeJflUGEeWA1C/bS8rPnPBUKyCxA7NKzcmRRidwlpywqZIq6xh6k
         AgK2PvCXI4YRD4trDAAaYTJIWuxrN5Wc0o02i3KeEsGI13SaVoZ3wJFF4vlhY95N9I
         kGigWFp35eLsw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ADA1B60A4D;
        Sat, 14 Aug 2021 13:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] Devlink cleanup for delay event series
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162894660670.3097.4150652110351873021.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Aug 2021 13:10:06 +0000
References: <cover.1628933864.git.leonro@nvidia.com>
In-Reply-To: <cover.1628933864.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        huangguangbin2@huawei.com, jacob.e.keller@intel.com,
        jiri@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, salil.mehta@huawei.com,
        snelson@pensando.io, yisen.zhuang@huawei.com, moyufeng@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 14 Aug 2021 12:57:25 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> Jakub's request to make sure that devlink events are delayed and not
> printed till they fully accessible [1] requires us to implement delayed
> event notification system in the devlink.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] devlink: Simplify devlink_pernet_pre_exit call
    https://git.kernel.org/netdev/net-next/c/cbf6ab672eb4
  - [net-next,2/6] devlink: Remove check of always valid devlink pointer
    https://git.kernel.org/netdev/net-next/c/7ca973dc9fe5
  - [net-next,3/6] devlink: Count struct devlink consumers
    https://git.kernel.org/netdev/net-next/c/437ebfd90a25
  - [net-next,4/6] devlink: Use xarray to store devlink instances
    https://git.kernel.org/netdev/net-next/c/11a861d767cd
  - [net-next,5/6] devlink: Clear whole devlink_flash_notify struct
    https://git.kernel.org/netdev/net-next/c/ed43fbac7178
  - [net-next,6/6] net: hns3: remove always exist devlink pointer check
    https://git.kernel.org/netdev/net-next/c/a1fcb106ae97

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


