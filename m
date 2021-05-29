Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A88E3949CB
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 03:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhE2BVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 21:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhE2BVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 21:21:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EF072613F9;
        Sat, 29 May 2021 01:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622251204;
        bh=AnUhUPHOZLLD7ZlU5/Eb1f36CWMDOj+lyH1Lp8XLAw4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BlCVbBK0bluFsRUuvlk+978yAEsG1zgbQm9RfXB9UmPFCxm+Sirs9VYLumwR8kP8Z
         7B1tgLxKLcIeeiWT5sbYTrgCwvduhczFtVpsQdYHwZ4YhRWo7vuXpAhmWkZpEjviWC
         4zcI5/gNMuy6CXCjPAuE2AtDe/6ht8cucspgvPedlVPKGDpCXc9k3wbcda8kb9mm36
         en2S7Wd2/hS92RpCRxp/uZzyJeTLfPRRbhnOQ9o5mrLcMX1HbfQqIdhK1STzfVVTHr
         d7dP4nbQ9EcGhj580yT/mHSw4hZxcFv8bOQ1WAgY3Tm+HTz0wlN6JEFHOejUOueCRW
         aViYYgvRGT9KQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E32B2609EA;
        Sat, 29 May 2021 01:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] ehea: fix error return code in ehea_restart_qps()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162225120392.30111.18172953600301226053.git-patchwork-notify@kernel.org>
Date:   Sat, 29 May 2021 01:20:03 +0000
References: <20210528085555.9390-1-thunder.leizhen@huawei.com>
In-Reply-To: <20210528085555.9390-1-thunder.leizhen@huawei.com>
To:     Leizhen (ThunderTown) <thunder.leizhen@huawei.com>
Cc:     dougmill@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        jeff@garzik.org, ossthema@de.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 28 May 2021 16:55:55 +0800 you wrote:
> Fix to return -EFAULT from the error handling case instead of 0, as done
> elsewhere in this function.
> 
> By the way, when get_zeroed_page() fails, directly return -ENOMEM to
> simplify code.
> 
> Fixes: 2c69448bbced ("ehea: DLPAR memory add fix")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> 
> [...]

Here is the summary with links:
  - [1/1] ehea: fix error return code in ehea_restart_qps()
    https://git.kernel.org/netdev/net-next/c/015dbf5662fd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


