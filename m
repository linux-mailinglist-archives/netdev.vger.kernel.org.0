Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DF23B9630
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhGASmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhGASme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 14:42:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 14B9B6140E;
        Thu,  1 Jul 2021 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625164804;
        bh=HeVOAPZepgrDMx6AtEfiCdTVaH/t7uVwXubMMHgyAH8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q6N+nJpODdqAHnevELADfKShU8rG4lfNX/7+aGY29C+FTPXbJ8YLfj4ElP7us7bI7
         d0h0k8AW6E7RVr6ZKHV3QwKOMTGzCwSLGqG1zZTtVAJ0JBgg57eqiDJZwFJUXj5Y5A
         gHsnyjC+qsALza0Hvk4ORIMhHpANDZuqWXUGRow4RUZkw5UjNUJclTcsp93RbQ9CRW
         ERpknHMjUaN7Y05fUnkBZcIxqg7TzeCAG33HMVGG5Mp1IYsQ3HBVk1k2pGxmubFxlw
         oHaYxTyGiuU3X+13GJty2bXZNGfgeTo/Mb+nz2Hz9Lmgc+/zR3LeCxa/MSTc9TCZdo
         9GEDJQ9b3NUPQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 053A760A56;
        Thu,  1 Jul 2021 18:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH 0/3] Dynamic LMTST region setup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162516480401.21656.5714473098578182788.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 18:40:04 +0000
References: <20210629170006.722-1-gakula@marvell.com>
In-Reply-To: <20210629170006.722-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sbhatta@marvell.com,
        hkelam@marvell.com, jerinj@marvell.com, lcherian@marvell.com,
        sgoutham@marvell.com, hkalra@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 29 Jun 2021 22:30:03 +0530 you wrote:
> This patch series allows RVU PF/VF to allocate memory for
> LMTST operations instead of using memory reserved by firmware
> which is mapped as device memory.
> The LMTST mapping table contains the RVU PF/VF LMTST memory base
> address entries. This table is used by hardware for LMTST operations.
> Patch1 introduces new mailbox message to update the LMTST table with
> the new allocated memory address.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] octeontx2-af: cn10k: Setting up lmtst map table
    https://git.kernel.org/netdev/net-next/c/873a1e3d207a
  - [net-next,2/3] octeontx2-af: cn10k: Support configurable LMTST regions
    https://git.kernel.org/netdev/net-next/c/893ae97214c3
  - [net-next,3/3] octeontx2-pf: cn10k: Use runtime allocated LMTLINE region
    https://git.kernel.org/netdev/net-next/c/5c0512072f65

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


