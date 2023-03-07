Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0726AF261
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbjCGSwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233368AbjCGSwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:52:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD2A2A9B7;
        Tue,  7 Mar 2023 10:40:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76F7461550;
        Tue,  7 Mar 2023 18:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2A38C433A1;
        Tue,  7 Mar 2023 18:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678214422;
        bh=MGOyxpYFLzWfLWp9sXZ+Dz7/5vT25BPIxEJwEthC7zU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LUVrWj7ai5pFlU0+nS8K/TCVZXM3+NgT5EvvC9UjEC9c8KA46pyFACd5U/Zs3pAqG
         pYxxGr8CLtGCOmWpz2UyQQPEhYUv4h8b0h1uU2cFdjzXyTMcaPvL2PrPWWKmUy4gr4
         +SCpvs3IGuRkqOvSCfPkN74nU+ly7FP1ugwNwiUUpE14grOjWzsQw/fF1FcMX7WrFL
         Fck0OwYK0SINJhjn4STpmh+aLfIG+lBd8yN4C8c41naZ/gnqd6YazLr7VLDtc5zDrf
         Wr0vXZ256cm6hET2gkUcCCnY01S39BLYNiiAt4c0VN/NIU1aw4ZXAoA4H0bEmE9B7c
         FtixH0dCWqISA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B58A2E61B63;
        Tue,  7 Mar 2023 18:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/1] Bluetooth: fix race condition in hidp_session_thread
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167821442273.6197.2769523000407933945.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Mar 2023 18:40:22 +0000
References: <20230304142330.7367-1-lm0963hack@gmail.com>
In-Reply-To: <20230304142330.7367-1-lm0963hack@gmail.com>
To:     Min Li <lm0963hack@gmail.com>
Cc:     luiz.dentz@gmail.com, marcel@holtmann.org, johan.hedberg@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jkosina@suse.cz, hdegoede@redhat.com,
        david.rheinsberg@gmail.com, wsa+renesas@sang-engineering.com,
        linux@weissschuh.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Sat,  4 Mar 2023 22:23:30 +0800 you wrote:
> There is a potential race condition in hidp_session_thread that may
> lead to use-after-free. For instance, the timer is active while
> hidp_del_timer is called in hidp_session_thread(). After hidp_session_put,
> then 'session' will be freed, causing kernel panic when hidp_idle_timeout
> is running.
> 
> The solution is to use del_timer_sync instead of del_timer.
> 
> [...]

Here is the summary with links:
  - [v2,1/1] Bluetooth: fix race condition in hidp_session_thread
    https://git.kernel.org/bluetooth/bluetooth-next/c/4bbfb9fefadf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


