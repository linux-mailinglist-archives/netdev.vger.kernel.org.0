Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397C0479865
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 04:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhLRDaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 22:30:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58472 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbhLRDaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 22:30:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D83D62481;
        Sat, 18 Dec 2021 03:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2694C36AF1;
        Sat, 18 Dec 2021 03:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639798215;
        bh=XZsPQ+WFvZkq7O/vkF/1tEa9sEMBdGhOUIw1DsgaugA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aXopHg88CY5/hDSbJvS/fhvK3LmT8I30YzP92ha1S7AnKJDJpC84BUPULljHECu40
         zLnE8f/L+kJB3P4USM6lFiq/40mbnqTWbmrVd5dpnfIi5yQ/P86IJUyOg/k2PxLLId
         nJPYvH+OpptMxkwuMTbOocoZepDmRrD60nobpQ1kB89VfzC4wWEl+D6M11+XJlN2w4
         t5YPqXYeYx0woQLi2QQfH18OnzsYwpu8F//m9GYklGSewWclNXaW2i7mdP5bue187p
         7ub5fbCdJU2j+HdhXGrOtC3Kor/9VnMAthQqrjY7uHVxOkeKMRiU5/y5B/2FZaiQ8Y
         AFZMSQNC4Ocgw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D230B609BB;
        Sat, 18 Dec 2021 03:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: marvell: prestera: fix incorrect return of port_find
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163979821485.17814.4905336985564462738.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 03:30:14 +0000
References: <20211216170736.8851-1-yevhen.orlov@plvision.eu>
In-Reply-To: <20211216170736.8851-1-yevhen.orlov@plvision.eu>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org, volodymyr.mytnyk@plvision.eu,
        taras.chornyi@plvision.eu, mickeyr@marvell.com,
        serhiy.pshyk@plvision.eu, tchornyi@marvell.com,
        davem@davemloft.net, kuba@kernel.org, andrii.savka@plvision.eu,
        oleksandr.mazur@plvision.eu, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Dec 2021 19:07:36 +0200 you wrote:
> In case, when some ports is in list and we don't find requested - we
> return last iterator state and not return NULL as expected.
> 
> Fixes: 501ef3066c89 ("net: marvell: prestera: Add driver for Prestera family ASIC devices")
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> ---
>  .../ethernet/marvell/prestera/prestera_main.c    | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net] net: marvell: prestera: fix incorrect return of port_find
    https://git.kernel.org/netdev/net/c/8b681bd7c301

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


