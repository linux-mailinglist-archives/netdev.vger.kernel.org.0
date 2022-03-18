Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19D74DD1E0
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 01:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiCRAVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 20:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiCRAVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 20:21:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D791F3A55
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 17:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E809E6106D
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 00:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45C9AC340F3;
        Fri, 18 Mar 2022 00:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647562814;
        bh=XQjHs79glzX11e25aJhS3Byje7BqBcrn/esvbV2abR8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qaAgkhceVuN8iazOhQ8chx8KIKcGofiojog2O/NrX3tNRjhXl0PuMSh1OE6RiegHn
         nUnLS1NrtJUDqcAib2DHoNC3rrLv07SQaXG1bRN6RtfSAaiEofgbePQz+mg48VZgGd
         1NCmbFYkKBmSTe+Leu3KPFJz0b2hHsB4/x/D7+La105XJSZMIAT9IY4y8CcfUFlobJ
         TRqxJV+7Fs2plciZ+EpVhnj6eLX7t1jfjALe/CrBC5y/kEDSGbeAgR6de0GB1FHZmv
         qVrWYJ4Nb1Sz+KtDH+nYaUU98P0JvLYDyI/e/YqDIxpMsxouy2OuVhudKv0e3VMlbb
         B/ZFZt5h5A4XQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19BFDE8DD5B;
        Fri, 18 Mar 2022 00:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: improve driver unload and system shutdown
 behavior on DASH-enabled systems
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164756281410.28197.13190201885232155922.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 00:20:14 +0000
References: <1de3b176-c09c-1654-6f00-9785f7a4f954@gmail.com>
In-Reply-To: <1de3b176-c09c-1654-6f00-9785f7a4f954@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        yaneti@declera.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Mar 2022 22:31:00 +0100 you wrote:
> There's a number of systems supporting DASH remote management.
> Driver unload and system shutdown can result in the PHY suspending,
> thus making DASH unusable. Improve this by handling DASH being enabled
> very similar to WoL being enabled.
> 
> Tested-by: Yanko Kaneti <yaneti@declera.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: improve driver unload and system shutdown behavior on DASH-enabled systems
    https://git.kernel.org/netdev/net-next/c/54744510fa9c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


