Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273DB61A71D
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 04:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiKEDAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 23:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKEDAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 23:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA555419B6;
        Fri,  4 Nov 2022 20:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 698D9B8306E;
        Sat,  5 Nov 2022 03:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1064CC433C1;
        Sat,  5 Nov 2022 03:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667617216;
        bh=6JJxvxRw6N0dKIx92xVodPoUq+fvP4pheypZbqEH8KE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gItXcDwAvMgMJjLtcfr+F71xInNOmbM9dNv5723uu3hSrS+NDIoLqjxwX/TvLu5lj
         9uc65XmY+IfTb6fipLGAI0tKi6TT02X8QFwf7Fkaco3u1HgPZ2GkSx+Gn6qAzOa2LJ
         TiApELHcR7sVzrUMmb0M70//Q83bMgoDbGaNDvNGw8h8T3Yj58aS0YkbPXjfHWn/Yx
         f1CV2FsMwNjV/++XE7zgA5hJjur/bp8B/lRKRllIiDt6QlHn1Wg3uCicqTjJKyaBuQ
         FuJDRz5aGDvzZvHo4IFgH+FFrKkzgAhmBqFO9ZN820Zq3/35E4ymxbP/eQ/S+czkeA
         wT3Wz7/JKbquA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E20DDE270DF;
        Sat,  5 Nov 2022 03:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fman: Unregister ethernet device on removal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166761721591.16255.11516331352075023540.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Nov 2022 03:00:15 +0000
References: <20221103182831.2248833-1-sean.anderson@seco.com>
In-Reply-To: <20221103182831.2248833-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, madalin.bucur@nxp.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  3 Nov 2022 14:28:30 -0400 you wrote:
> When the mac device gets removed, it leaves behind the ethernet device.
> This will result in a segfault next time the ethernet device accesses
> mac_dev. Remove the ethernet device when we get removed to prevent
> this. This is not completely reversible, since some resources aren't
> cleaned up properly, but that can be addressed later.
> 
> Fixes: 3933961682a3 ("fsl/fman: Add FMan MAC driver")
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> 
> [...]

Here is the summary with links:
  - net: fman: Unregister ethernet device on removal
    https://git.kernel.org/netdev/net/c/b7cbc6740bd6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


