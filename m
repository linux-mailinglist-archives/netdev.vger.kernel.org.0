Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F473E14EB
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241449AbhHEMk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241415AbhHEMkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 08:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BBE2761156;
        Thu,  5 Aug 2021 12:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628167206;
        bh=axZuoppMPWbxxVruT0pIMp+2L/PAfFxF0KeP3fi2Ays=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vivj9FNQIY6AfUzmK2IDimfRCemCjR86bd4gun/uJG1kPRTzL1gkbI7YN4emUvIs7
         dloGCT1d/TI4BeEwNBxuHQMyv71cZQYvZx8IPvDNSnSig2TC4TMkBZTuh+hrViPH+s
         32Gwj587WiJ2zq4G1Ykv0cWRMnd78y/2zwbshmoBjoeSwSpeeVY14e8Q8whBPClr5K
         lRT97sGxNqWtTyiUrETFL/3PxBTGzICeo6lZfHUIadhmkNNKsG/BAPElmEkAVc1M6x
         nNaEQVok5zy511dezLPBnbaq2w1m6iNvd+XSaDSF5sUF6Jvh1wuWwhrtM3rKfpR84i
         0Ui+UTkYUen4A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B5D1D60A72;
        Thu,  5 Aug 2021 12:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netdevsim: Forbid devlink reload when adding or
 deleting ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162816720674.10114.12919515141132982262.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 12:40:06 +0000
References: <53cd1a28dd34ced9fb4c39885c6e13523e97d62c.1628161323.git.leonro@nvidia.com>
In-Reply-To: <53cd1a28dd34ced9fb4c39885c6e13523e97d62c.1628161323.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  5 Aug 2021 14:02:45 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> In order to remove complexity in devlink core related to
> devlink_reload_enable/disable, let's rewrite new_port/del_port
> logic to rely on internal to netdevsim lcok.
> 
> We should protect only reload_down flow because it destroys nsim_dev,
> which is needed for nsim_dev_port_add/nsim_dev_port_del to hold
> port_list_lock.
> 
> [...]

Here is the summary with links:
  - [net-next] netdevsim: Forbid devlink reload when adding or deleting ports
    https://git.kernel.org/netdev/net-next/c/23809a726c0d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


