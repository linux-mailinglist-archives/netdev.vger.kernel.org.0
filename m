Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29EB9519318
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244797AbiEDBDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244845AbiEDBDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:03:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE8DD60
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BBA2B822B2
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 01:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98B99C385B1;
        Wed,  4 May 2022 01:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651626012;
        bh=aT203gngjjduk5KH/1sYlMWCHfnVY6FZZgdpz3iLHQ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kx17TiUr/Za+rpqcdLcTb1Hgm3m6u8UEGrYdOcWoH4f7Z/g8aqtvz9ir2Krv+Qf8k
         foeeqUff5t+hNjc1ubf/brQmOA+ONrpfFH0HlNQMITohCVBrU74E+/NUBnDLDjTHn3
         UaAYVbHeFG8WShwKWlI5csMfr8nlw0wtOcauJ+yazeYwFnGyI/L583IEDWOI36E5tg
         OMyycnqLEr71HkSv7updhJaApqvbjl1vkKNB7NBkDgRnFAshTrTTQs1vhz9Pcg5XS8
         WlodrLhwSUyQiv1/QVVnvHIwMKUjbqxSIjAZYacqXsnIozBuA1aNAworfJ9m9WejYJ
         HqesjiwbkQhcg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A0BAE7399D;
        Wed,  4 May 2022 01:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] bnxt_en: Bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165162601249.2155.16006319994410212768.git-patchwork-notify@kernel.org>
Date:   Wed, 04 May 2022 01:00:12 +0000
References: <1651540392-2260-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1651540392-2260-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  2 May 2022 21:13:09 -0400 you wrote:
> This patch series includes 3 fixes:
> 
> 1. Fix an occasional VF open failure.
> 2. Fix a PTP spinlock usage before initialization
> 3. Fix unnecesary RX packet drops under high TX traffic load.
> 
> Michael Chan (2):
>   bnxt_en: Initiallize bp->ptp_lock first before using it
>   bnxt_en: Fix unnecessary dropping of RX packets
> 
> [...]

Here is the summary with links:
  - [net,1/3] bnxt_en: Fix possible bnxt_open() failure caused by wrong RFS flag
    https://git.kernel.org/netdev/net/c/13ba794397e4
  - [net,2/3] bnxt_en: Initiallize bp->ptp_lock first before using it
    https://git.kernel.org/netdev/net/c/2b156fb57d8f
  - [net,3/3] bnxt_en: Fix unnecessary dropping of RX packets
    https://git.kernel.org/netdev/net/c/195af57914d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


