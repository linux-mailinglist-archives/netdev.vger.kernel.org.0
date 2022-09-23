Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9B75E79C8
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 13:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbiIWLkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 07:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiIWLkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 07:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B350E6DD2;
        Fri, 23 Sep 2022 04:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB352614AC;
        Fri, 23 Sep 2022 11:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2DF11C433D7;
        Fri, 23 Sep 2022 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663933214;
        bh=iA3HSnC5uSM/aCZoJ30q3G9yKOqUq+rr0mXVJgegbf8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BNafXjABw/iGkHKyz88//SvG38jK5pkJFkFtaubG1N4V0UmHhfDhtMqVXl1l8nagp
         4CcQ4duE4v6l4uRvUz2fsvz8heXX2dmI0OMQLA/b8yLyNFK564To6vH+aDTS+g9HFP
         FTMiZRGgfwe9r+08S96DR/oAwNwzAaFj+cThof1qGZuougr61PHVwNGJVlmgoPoqW4
         Z+LtnYgnWLyGcKqP1dSA1ATZS0Dgh83zMwhdK1dNlQpQnuBf6K2KVscwetRIgjPtNY
         FLLZbpk2J7j9tysn8ySB/Bmbkl75Cf7ZbFVY0iMpbsoDp+gzsA3AJbd62JOiU7hhUX
         E22yQ22XthqXQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 14907E4D03D;
        Fri, 23 Sep 2022 11:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: macb: Fix ZynqMP SGMII non-wakeup source resume
 failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166393321408.30956.5657200938175639833.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 11:40:14 +0000
References: <1663767370-11089-1-git-send-email-radhey.shyam.pandey@amd.com>
In-Reply-To: <1663767370-11089-1-git-send-email-radhey.shyam.pandey@amd.com>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        robert.hancock@calian.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, git@amd.com
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

On Wed, 21 Sep 2022 19:06:10 +0530 you wrote:
> When GEM is in SGMII mode and disabled as a wakeup source, the power
> management controller can power down the entire full power domain(FPD)
> if none of the FPD devices are in use.
> 
> Incase of FPD off, there are below ethernet link up issues on non-wakeup
> suspend/resume. To fix it add phy_exit() in suspend and phy_init() in the
> resume path which reinitializes PS GTR SGMII lanes.
> 
> [...]

Here is the summary with links:
  - [net] net: macb: Fix ZynqMP SGMII non-wakeup source resume failure
    https://git.kernel.org/netdev/net/c/f22bd29ba19a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


