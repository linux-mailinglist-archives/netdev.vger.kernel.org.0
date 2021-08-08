Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DC93E3A13
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 14:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhHHMA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 08:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230337AbhHHMAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 08:00:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3867161057;
        Sun,  8 Aug 2021 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628424006;
        bh=BnYQCLacPE3KGBLzagVrThjZy7IhddeegWummxpuJJ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ca/dnqcoD91hU/DdEFSvGreOArmknMcOBAGLWUaAKc+GIOVt5GKchIxWbN7YgD2QH
         LVOBqN26UXEJQnp6cYGoY3sKac/9NAeytbvsPiX3DWfiZZNOBLWQZu0wrNBRqcw1w9
         MvIfH0Dlq8gUYLPfru3SBxdWAe/BAVumKhxP1cFpV3rjgKfZwDCGl3WSFMJurmQTJl
         PxWqy1XZ41Cyogu60LXdoajgQ/h9QJKIzKhGwd1lAf/tF9yf4FFggeEaXBZ51SEOaT
         y0vLX9viQR8OUB9glw9kDi7i3j2o5aUayc6ipqj2W2AsM+uO2oPRacy7gd8K0DoP2t
         NnIsqVxknve/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2DBC9609B3;
        Sun,  8 Aug 2021 12:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: Simplify devlink port API calls
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162842400618.17847.5783406967029624966.git-patchwork-notify@kernel.org>
Date:   Sun, 08 Aug 2021 12:00:06 +0000
References: <c9f15f122181f05f09fffd2380365b9925dd6427.1628422645.git.leonro@nvidia.com>
In-Reply-To: <c9f15f122181f05f09fffd2380365b9925dd6427.1628422645.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        jiri@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  8 Aug 2021 14:41:21 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Devlink port already has pointer to the devlink instance and all API
> calls that forward these devlink ports to the drivers perform same
> "devlink_port->devlink" assignment before actual call.
> 
> This patch removes useless parameter and allows us in the future
> to create specific devlink_port_ops to manage user space access with
> reliable ops assignment.
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: Simplify devlink port API calls
    https://git.kernel.org/netdev/net-next/c/82564f6c706a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


