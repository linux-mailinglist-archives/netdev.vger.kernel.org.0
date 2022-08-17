Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05C2596D27
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 13:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbiHQLAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 07:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236106AbiHQLAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 07:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA3151A30;
        Wed, 17 Aug 2022 04:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF90E614A9;
        Wed, 17 Aug 2022 11:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07937C433B5;
        Wed, 17 Aug 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660734016;
        bh=ttjqAmA8Dgb/QKb7KUJdDUHaSkml7XYlRm70E1cNU0M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=unpKm8ZJWJXOz3FWDK3H+f0kcbArj2orA2FR4ncU0Z+9zPK5aWkqIywAkR6ym48wM
         f8Gj8M8D6EHPcIXopiGlqFknabY6v/AaSqEDqwHg0dZJqy8ynlNsWVUl7p7LyXv17b
         nMNRRUOJndVpn/mQ0hxVHH2nZX+z3dKvai4la7XtRDqDoKADiaAylYpHkuMb10+iqG
         0d5t2Z7xkJCjdegEzecJapZJw6Aad/dMJe/XteKk4YN6/zaMgXHbMvC8T+8SsL5utQ
         fWVM7pS1Ck6NZCD1euGdFZr21ST4SRcrrxZ6fOQWbfmiS8lQ/C2Au6CDrgcXDv5Jme
         A5vp/X21FMJaA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF688E2A051;
        Wed, 17 Aug 2022 11:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: broadcom: Implement suspend/resume for
 AC131 and BCM5241
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166073401591.15107.13441977002582907304.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 11:00:15 +0000
References: <20220815190747.2749477-1-f.fainelli@gmail.com>
In-Reply-To: <20220815190747.2749477-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Aug 2022 12:07:47 -0700 you wrote:
> Implement the suspend/resume procedure for the Broadcom AC131 and BCM5241 type
> of PHYs (10/100 only) by entering the standard power down followed by the
> proprietary standby mode in the auxiliary mode 4 shadow register. On resume,
> the PHY software reset is enough to make it come out of standby mode so we can
> utilize brcm_fet_config_init() as the resume hook.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: broadcom: Implement suspend/resume for AC131 and BCM5241
    https://git.kernel.org/netdev/net-next/c/0630f64d25a0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


