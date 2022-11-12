Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E1062673D
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 07:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbiKLGAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 01:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiKLGAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 01:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA78D16594
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 22:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B13560BC5
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 06:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F5C3C43144;
        Sat, 12 Nov 2022 06:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668232818;
        bh=avKbjWDJSL7Fntkb/TmHKuSMQ+id9fLOpP3ztAV5VJU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SSpDNduPdHMGWEJpz4Lp0EQ7D1pICtDyARjCsKIJgr/RcQ6bauGn8aphwRnBDs+MZ
         6FGQ4THEdqamAFUWRBztwmbqTd7dFcuzZf1E0AFItwNc0paVmP33oybawbC/c4dNnF
         46M6Sv2wEUyk5CppFSxwnQTokPIG3l6F5nBJCom1hWNoJ4iSdrk5CBHCCwL8bwlw5X
         1+Yw/RtQCKbHoyH0JhqlpVN+CgYbuY+1HI615fcd3QPczFg+isSrC49U4Od8bm89y4
         d32G6C7IYaL/aazH3w3g7WrbySZcq2zAPkLv5wie716gJHrRZDc3CoTRpm+O6k48Jp
         Lt2963gVSlfFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 31CE8E524C4;
        Sat, 12 Nov 2022 06:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: enable set_policy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166823281819.10181.13032789591512512729.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 06:00:18 +0000
References: <20221110091027.998073-1-angelo.dureghello@timesys.com>
In-Reply-To: <20221110091027.998073-1-angelo.dureghello@timesys.com>
To:     Angelo Dureghello <angelo.dureghello@timesys.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Nov 2022 10:10:27 +0100 you wrote:
> Enabling set_policy capability for mv88e6321.
> 
> Signed-off-by: Angelo Dureghello <angelo.dureghello@timesys.com>
> 
> ---
> Changes for v2:
> - enable set_policy also for mv88e6320, since of same family.
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: mv88e6xxx: enable set_policy
    https://git.kernel.org/netdev/net-next/c/45f22f2fdc19

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


