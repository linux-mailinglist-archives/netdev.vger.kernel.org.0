Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9B965BD2E
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237214AbjACJaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237094AbjACJaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:30:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59C15FB0;
        Tue,  3 Jan 2023 01:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 589F4B80E59;
        Tue,  3 Jan 2023 09:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8684C433D2;
        Tue,  3 Jan 2023 09:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672738216;
        bh=ViS8BsfvD0LyNxsnPZ/rliClf9JpsuMSOmjDCGjmSbQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VDeJo24QfcTK+bw+SK1ZnBzZTE/6rEcHgiDxgyWupp03Tg45hr3eZwVXLtPQQrqch
         OX6NnDeJzclx+CVhyz/j7+09Z0RdmoO2hr2t2rsjIKMXuHbS/RaSm2Ikh0KUFJFdRX
         LFvMEJ72Qjr8mhpifRd0pYmco6Heo5DfR6qsyyF5Uui4lJPhZFV3MmbhoGsxsP/hEa
         n77ZF2Rz2e/QpXfRqfhNvPhEyxBvfXaXuRa9uwhNXCyt+32XPrFd0LaU//7mMdKl50
         WnkUNBxzY6er4hWxIBBmnqFR8iy+TUVex8BdVm4dTnDjWgrSnnqRIPW1mPvziuU9jU
         gzcCBukcCKwOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE5F4C395DF;
        Tue,  3 Jan 2023 09:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dpaa: Fix dtsec check for PCS availability
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167273821584.22243.1614058667243566819.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Jan 2023 09:30:15 +0000
References: <20230103065038.2174637-1-seanga2@gmail.com>
In-Reply-To: <20230103065038.2174637-1-seanga2@gmail.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     madalin.bucur@nxp.com, davem@davemloft.net, sean.anderson@seco.com,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        kuba@kernel.org, info@xenosoft.de, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  3 Jan 2023 01:50:38 -0500 you wrote:
> We want to fail if the PCS is not available, not if it is available. Fix
> this condition.
> 
> Fixes: 5d93cfcf7360 ("net: dpaa: Convert to phylink")
> Reported-by: Christian Zigotzky <info@xenosoft.de>
> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dpaa: Fix dtsec check for PCS availability
    https://git.kernel.org/netdev/net/c/7dc618385419

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


