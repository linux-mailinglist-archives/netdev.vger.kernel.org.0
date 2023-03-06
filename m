Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6795A6AD0F5
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 23:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCFWAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 17:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCFWAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 17:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74F839B81
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 14:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8448AB81135
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 22:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DFA2C4339B;
        Mon,  6 Mar 2023 22:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678140019;
        bh=Z+t7RJHWXhqqYVaB6v6igwdoN7V53f4saMQhZtCKL/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e3ilGinrUVmWMRQFMdX2AR54iWPrEMeNGqECmuNOIXB1tFBBgTAi7R8comQWKfrW4
         cWMSy1qiaQvp83+d0DWISDtPiohC/wJEuxmaMkBlrHMobUNIJ8q3bcThfvXx0l1V/v
         +s551YG/NaqSspq/HH3ww0gjKjkU2RODYVYVrCXQYzBC4hnwp2nTJ4D+/6Vs3YZq4Q
         LPGzdHXxUicQL5JI6+UOmptKfnnCrgZAFcpnfeaF338dYydLukUyyVCpthb+jqfnG5
         WDxTVO8NqfUlV8nlIU3FRbIIT8A3JEZYVp+9MeYByDviC1rDw0oz2nZEVO6ueCgfib
         RjjEz/Hlb0gpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE934E68C39;
        Mon,  6 Mar 2023 22:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: tls: fix device-offloaded sendpage straddling
 records
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167814001890.23313.11794676936510215207.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Mar 2023 22:00:18 +0000
References: <20230304192610.3818098-1-kuba@kernel.org>
In-Reply-To: <20230304192610.3818098-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, amoulin@corp.free.fr, borisp@nvidia.com,
        john.fastabend@gmail.com, tariqt@nvidia.com, maximmi@nvidia.com,
        maxtram95@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  4 Mar 2023 11:26:10 -0800 you wrote:
> Adrien reports that incorrect data is transmitted when a single
> page straddles multiple records. We would transmit the same
> data in all iterations of the loop.
> 
> Reported-by: Adrien Moulin <amoulin@corp.free.fr>
> Link: https://lore.kernel.org/all/61481278.42813558.1677845235112.JavaMail.zimbra@corp.free.fr
> Fixes: c1318b39c7d3 ("tls: Add opt-in zerocopy mode of sendfile()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] net: tls: fix device-offloaded sendpage straddling records
    https://git.kernel.org/netdev/net/c/e539a105f947

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


