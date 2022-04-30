Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57153515E31
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 16:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242406AbiD3Odk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 10:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242272AbiD3Odi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 10:33:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C552DFBC;
        Sat, 30 Apr 2022 07:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58725B83090;
        Sat, 30 Apr 2022 14:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1474BC385AF;
        Sat, 30 Apr 2022 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651329013;
        bh=TEeET+LQnYBBMVfmaUljRCL0qeuYqmXv8VscOwh7ArE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LwTUg5apvji6XoGZOkDdco6tmZvNuswVC+B4Z21YCPTVWM58gTAf5JjAZ0SSseKlr
         PJ3YycnECQG7W+0NLOugtTW9/Pu0CBkyahTsC9Ph44IUFXFr6MM4sq1yAANr/yHF0w
         iT6agelRXf3M5CWpDAjBysDS7DbRMRG1i53DFkHmCFlOo/tzwRcPnel6eqv0TFzLYh
         5daGh+l9e3BZ8701jBmsrZ3k3RjISQGGVZ7GrPUukVy3Zk2vKCxPfhgcp13ApNb6/m
         VhzkVwGHmfP6rs7P8iqLF+i/FvdxSzNkGAFzgaxZoCU8oApgTwMW6egT24JDJx4uRc
         6DdjmsEjlC7gw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E97BDF03841;
        Sat, 30 Apr 2022 14:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: Fix compilation error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165132901295.11133.16561971820560838963.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 14:30:12 +0000
References: <20220429071953.4079517-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220429071953.4079517-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, davem@davemloft.net, arnd@arndb.de,
        lkp@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Apr 2022 09:19:53 +0200 you wrote:
> Starting from the blamed commit, the lan966x build fails with the
> following compilation error:
> 
> drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c:342:9: error: implicit declaration of function ‘ptp_find_pin_unlocked’ [-Werror=implicit-function-declaration]
>   342 |   pin = ptp_find_pin_unlocked(phc->clock, PTP_PF_EXTTS, 0);
> 
> The issue is that there is no stub function for ptp_find_pin_unlocked
> in case CONFIG_PTP_1588_CLOCK is not selected. Therefore add one.
> 
> [...]

Here is the summary with links:
  - [net-next] net: lan966x: Fix compilation error
    https://git.kernel.org/netdev/net-next/c/48cec73a891c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


