Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36105493E4C
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 17:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356120AbiASQaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 11:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiASQaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 11:30:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E4DC061574
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 08:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD706B81A65
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 16:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75F57C340E5;
        Wed, 19 Jan 2022 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642609810;
        bh=P2RwwqMmrgNT5XQTERJIxbCDmK3x+DZSczMR0mJpWZ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M68ZBY+m4nvdaAz72tqX5mVNHx4nFud5Kq5Bf+cSyFd03eHoHOl0+GldjdBjNXSRX
         skfSq0ppQ4aepr9Ukq+2/XqMyfV4LEbQjlrh1L7mIWR8WIo6Oa05kZJq0HEvS+HXAt
         TI7y5HSfm1fc7M9bKHJKaV7Ah/CMGJoa9/IBBz8CpY7APhoo+nVZpLtFpDcc+J/rsL
         ExLPNAkgnOF1TTiqeQstEyxVR8JrGcXpyigwjZWc6HkMTHGkVjNzXhbdYsmHxpKpIL
         Ay+7T4unuubkp6TAvi3CiTLQsrBHKo1jKOLaNV75JP9z/IqPWfixl6Pnn2NHsRScqU
         jEJNgCkQrWDcg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D962F6079B;
        Wed, 19 Jan 2022 16:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 0/4] net/fsl: xgmac_mdio: Add workaround for erratum
 A-009885
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164260981037.11428.9139293914136449143.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Jan 2022 16:30:10 +0000
References: <20220118215054.2629314-1-tobias@waldekranz.com>
In-Reply-To: <20220118215054.2629314-1-tobias@waldekranz.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Jan 2022 22:50:49 +0100 you wrote:
> The individual messages mostly speak for themselves.
> 
> It is very possible that there are more chips out there that are
> impacted by this, but I only have access to the errata document for
> the T1024 family, so I've limited the DT changes to the exact FMan
> version used in that device. Hopefully someone from NXP can supply a
> follow-up if need be.
> 
> [...]

Here is the summary with links:
  - [v2,net,1/4] net/fsl: xgmac_mdio: Add workaround for erratum A-009885
    https://git.kernel.org/netdev/net/c/6198c7220197
  - [v2,net,2/4] dt-bindings: net: Document fsl,erratum-a009885
    https://git.kernel.org/netdev/net/c/ea11fc509ff2
  - [v2,net,3/4] powerpc/fsl/dts: Enable WA for erratum A-009885 on fman3l MDIO buses
    https://git.kernel.org/netdev/net/c/0d375d610fa9
  - [v2,net,4/4] net/fsl: xgmac_mdio: Fix incorrect iounmap when removing module
    https://git.kernel.org/netdev/net/c/3f7c239c7844

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


