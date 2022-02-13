Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E147B4B3C2D
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 17:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236909AbiBMQAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 11:00:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236379AbiBMQAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 11:00:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127D15A090;
        Sun, 13 Feb 2022 08:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 933A5611C4;
        Sun, 13 Feb 2022 16:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6F95C340F0;
        Sun, 13 Feb 2022 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644768009;
        bh=dJ+FtYYgz9ZF0xxniydz/MCoDEFWvBba2GQzSFqd3p0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ioANKADZqNFXYQoCfwuW+WwcDCcKE5lNKnCJJTigHv1yQgBQwKM5XXZxx4D+6sQmx
         w9fCXTCJRuHG4SgCi7U1+patlripBC2LU5NbJ44B1c4Z8D2p3f5pG/i6t5sovgxO8Y
         SetCf5JIto0PFcQVFX+ahX0Fda0r/Gc0vBCXvfV+fqko19Z/aTw3qOEJ1AKLNqKHdm
         wf0y2tjbGLAwcftM6R4otiPk4g6Ux9j7NQaQNzHMGbGs0EQEvYkVXF+0pW/mRCj9Np
         AWMWqM9CSU7RBDkGBa47+lxkfR87Rh8nYdvWorC/wk2iihAGucQDAk2eeRq+Vu8drR
         stVJ7KFXynGNg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF422E6D447;
        Sun, 13 Feb 2022 16:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: Fix when CONFIG_PTP_1588_CLOCK is
 compiled as module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164476800984.537.18049002093731089232.git-patchwork-notify@kernel.org>
Date:   Sun, 13 Feb 2022 16:00:09 +0000
References: <20220212204544.972787-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220212204544.972787-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com, lkp@intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 12 Feb 2022 21:45:44 +0100 you wrote:
> When CONFIG_PTP_1588_CLOCK is compiled as a module, then the linking of
> the lan966x fails because it can't find references to the following
> functions 'ptp_clock_index', 'ptp_clock_register' and
> 'ptp_clock_unregister'
> 
> The fix consists in adding CONFIG_PTP_1588_CLOCK_OPTIONAL as a
> dependency for the driver.
> 
> [...]

Here is the summary with links:
  - [net-next] net: lan966x: Fix when CONFIG_PTP_1588_CLOCK is compiled as module
    https://git.kernel.org/netdev/net-next/c/1da52b0e4724

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


