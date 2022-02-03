Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89DCE4A9079
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 23:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351921AbiBCWKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 17:10:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38732 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiBCWKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 17:10:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19332617D6;
        Thu,  3 Feb 2022 22:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 780ACC340EB;
        Thu,  3 Feb 2022 22:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643926252;
        bh=xP9CJWr1aBy5mpv9X2dpcHXvU38UDBv+cO2U3vskBiE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rcG6q+uta8JxabOggF80CvwgiDM4iZWoXpXMoWk97x7YEtnpfK6DMBbrkq0AO6uFE
         Pob5+tuxXXlonhnad4KOOqHNUVGBTbqh2i310NlTWfAxhs89cGM9WJml7nirsmowEE
         rgUf2tol2bSSN8bQwE2bEe3Yq7Wqz8YT4f5eBU6OHjlFesSYH+qUn4HS3hJ1jzjkFH
         rkP7I9J4kXdQhE3jc8jYIvJ0Z3eHGhGvH4LfqrGR7fv/s+iDjl+NC0D6t1fogk2Wjf
         TpwoC2z6GcZV6o4Ito975GUGWsyQh8Hj7YU8s7WMi2j51jC5+pCTHKsNis1ZkRpfCw
         nIi6EQBnkC09w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B735E5869F;
        Thu,  3 Feb 2022 22:10:52 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: ensure PTP time register reads are
 consistent
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164392625236.29991.16982092505073746974.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 22:10:52 +0000
References: <20220203160025.750632-1-yannick.vignon@oss.nxp.com>
In-Reply-To: <20220203160025.750632-1-yannick.vignon@oss.nxp.com>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, rayagond@vayavyalabs.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sebastien.laveze@oss.nxp.com, olteanv@gmail.com,
        xiaoliang.yang_1@nxp.com, mingkai.hu@nxp.com,
        qiangqing.zhang@nxp.com, yannick.vignon@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  3 Feb 2022 17:00:25 +0100 you wrote:
> From: Yannick Vignon <yannick.vignon@nxp.com>
> 
> Even if protected from preemption and interrupts, a small time window
> remains when the 2 register reads could return inconsistent values,
> each time the "seconds" register changes. This could lead to an about
> 1-second error in the reported time.
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: ensure PTP time register reads are consistent
    https://git.kernel.org/netdev/net/c/80d4609008e6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


