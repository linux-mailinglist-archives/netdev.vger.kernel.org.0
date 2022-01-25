Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF33D49B937
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585337AbiAYQus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586331AbiAYQsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:48:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCEBC061786;
        Tue, 25 Jan 2022 08:46:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD01160B43;
        Tue, 25 Jan 2022 16:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38BDAC340E9;
        Tue, 25 Jan 2022 16:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643129174;
        bh=lWUX+M/m5LBPUZVAosLkpl2CMXtqXfCRE6ggsbUarCk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Go7wfveBOvEByjFtpvgQX0vWqUpDDAnLWtFVaPVb2A9O95uDe8asBb5ENTb27yJB/
         s7Yn5JL5i4vRnyzpLMRlsWeSi3dtZ/wq1KMshaK23UBHogsKXt2pvCyVhJsb2dhZdV
         3J090yq/zTkmJ3uAZWJdnmU+ZhRs2XmHprSYcBixxl89eahUpEgepjGamjad+kkwMi
         9y4FrbCd+MN4GdI1XpIN27vXcJIzsONUaum8ypGhMs0hoX4itnDPZuaGfMb6DQRSWI
         /CrRl3d/HFD7pm0e9vWYSXcvGf/BQ8YcOMQ9G28ru5Odv+5rX1u8GjP2SHkrPM9wHS
         p0vtjoEXW/iqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C48BF6079C;
        Tue, 25 Jan 2022 16:46:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] yam: fix a memory leak in yam_siocdevprivate()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164312917410.15904.16284523460013653550.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Jan 2022 16:46:14 +0000
References: <20220124032954.18283-1-hbh25y@gmail.com>
In-Reply-To: <20220124032954.18283-1-hbh25y@gmail.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     jpr@f6fbb.org, davem@davemloft.net, kuba@kernel.org,
        wang6495@umn.edu, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 24 Jan 2022 11:29:54 +0800 you wrote:
> ym needs to be free when ym->cmd != SIOCYAMSMCS.
> 
> Fixes: 0781168e23a2 ("yam: fix a missing-check bug")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  drivers/net/hamradio/yam.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - yam: fix a memory leak in yam_siocdevprivate()
    https://git.kernel.org/netdev/net/c/29eb31542787

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


