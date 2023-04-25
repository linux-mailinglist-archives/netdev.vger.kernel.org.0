Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F121F6ED9DC
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbjDYBaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbjDYBaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A00AF10
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 18:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D0FA620B8
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7784C433EF;
        Tue, 25 Apr 2023 01:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682386218;
        bh=IRVt3OHpont8D6m2Qy4zKQSFmZ0H9HaErMKQextMlkY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LwpZuES7jGMHCG0Ry0UFFi6pK/QlBuaeAgZ6RidZmkyZ+ksu/C2RwMdiw5XSsTb9d
         1sc+9uiHO8HoWLYDUHzJPdVICOqsP+3vblZMB0124Lm1TW5sflax99eYGM6PiaDgYo
         HOaygw0LLrJ7lwFgtly6ozV/neSu2He+3G8PQsZARN0/WknvmpLBoUBmp1PiXFe/Eo
         M29lADGRvkKDfn8yN7xOGLZwxtQ9IJcRwXo9iGRvZogNqDCXSsTmX6Bb0AJtNg/dsB
         hqW4yWeaeki/JSdgTLhkTBLIrXeU83vPX+abeNKU1IrCkYekB74eL4ZrJGKpiz2abl
         5LaXSkboitbig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 88FDEE5FFC9;
        Tue, 25 Apr 2023 01:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/1] net: phy: Fix reading LED reg property
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168238621855.15904.17247622322735247331.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 01:30:18 +0000
References: <20230424141648.317944-1-alexander.stein@ew.tq-group.com>
In-Reply-To: <20230424141648.317944-1-alexander.stein@ew.tq-group.com>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, f.fainelli@gmail.com, ansuelsmth@gmail.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 24 Apr 2023 16:16:48 +0200 you wrote:
> 'reg' is always encoded in 32 bits, thus it has to be read using the
> function with the corresponding bit width.
> 
> Fixes: 01e5b728e9e4 ("net: phy: Add a binding for PHY LEDs")
> Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> ---
> Changes in v2:
> * Explicitly do range check before assigning to u8
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/1] net: phy: Fix reading LED reg property
    https://git.kernel.org/netdev/net-next/c/aed8fdad2152

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


