Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71003E45DF
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 14:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbhHIMk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 08:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234094AbhHIMk0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 08:40:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A8C7661002;
        Mon,  9 Aug 2021 12:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628512805;
        bh=7qkOoiK//vlQCpi8UWehdYDl5L/zTSX8BZPehK9oiCM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I4o6Y2dr/GNaXSmxr9XiMGUNARqu5cPshZlMT9oO+UgCeJ7u5EH2nUjQ0w5J9ghot
         aojJkRpUSzabm3HyIdH6d75yycigikznqoidxxnEIKkznbTe7K5sHWC9xOaGid8lge
         OmduCvhCqoTWY9mF1S9/Xnkkqa3OMX5SJ+77V6qcGn3v6BjCapzozDVCDAf3pPKMJ5
         fevYEK4XGWiqeCLtIN4CgGpUa+P5BZbnps7xSQH/3Zs8nlFGI4TiXaOeoDufTmAbNH
         rJAQRa3BU9JiYEZTcjrXDSKco3uO5JTKVfjKj+l159tuK97LB6LNsR0lWGLfW05ixa
         x+Bh9eBlSgSXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9D392609AD;
        Mon,  9 Aug 2021 12:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: Fix port_type_set function pointer check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162851280563.13993.17604581060971290077.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Aug 2021 12:40:05 +0000
References: <97f68683b3b6c7ea8420c64817771cdedfded7ae.1628510543.git.leonro@nvidia.com>
In-Reply-To: <97f68683b3b6c7ea8420c64817771cdedfded7ae.1628510543.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        jiri@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  9 Aug 2021 15:03:19 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Fix a typo when checking existence of port_type_set function pointer.
> 
> Fixes: 82564f6c706a ("devlink: Simplify devlink port API calls")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: Fix port_type_set function pointer check
    https://git.kernel.org/netdev/net-next/c/2a2b6e3640c4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


