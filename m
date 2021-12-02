Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115C7465C9F
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355170AbhLBDXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355157AbhLBDXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:23:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECB8C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83136B82212
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 03:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C082C53FAD;
        Thu,  2 Dec 2021 03:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638415211;
        bh=8TEoADrUx89goxF9TUPq2+EkkDXaiD87rx4o72IlNMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EMJ9gT53XLxHdDyoi2yAjKJj7TVbGMqqg/RVQcHF65irOJYfSt52KViYiXOIE6tsZ
         PKbQN5RNI5b3h+VR0+fSF6PBC4OtaWw/fSM0hbPa7zi5atcZV/4aWdPzR4smmY6ZJm
         0yhwdda6f3I2RtJ45gCqZhWpG0S/UBCwUOzUf+GCsEQlgP3R7vIjZZZMQMG4djMvQ3
         u2bEScEJ8igL0aRQd2+IE+aDCs2ly+ORwJ8++f/dqBdH4dADMcxZOwKQTZ1GYJFD98
         1Db1DcGmDB39ArHKokCNJ7K60O/lIpNwItrJ2w6hSRK9e+cP2DOvP6dIZtTX1GooP+
         SYP6Anu6O9EFg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2923360A59;
        Thu,  2 Dec 2021 03:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: tidy up disable bit clearing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163841521116.978.15322627047461748916.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 03:20:11 +0000
References: <E1ms4Rx-00EKEc-En@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1ms4Rx-00EKEc-En@rmk-PC.armlinux.org.uk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Nov 2021 14:49:41 +0000 you wrote:
> Tidy up the disable bit clearing where we clear a bit and the run the
> link resolver.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net-next] net: phylink: tidy up disable bit clearing
    https://git.kernel.org/netdev/net-next/c/aa729c439441

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


