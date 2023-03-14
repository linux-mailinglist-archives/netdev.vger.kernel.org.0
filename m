Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772286BA361
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 00:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjCNXKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 19:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCNXKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 19:10:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0904B2A6C2;
        Tue, 14 Mar 2023 16:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9912361A78;
        Tue, 14 Mar 2023 23:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB92AC4339C;
        Tue, 14 Mar 2023 23:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678835421;
        bh=kB8a3qZCzeTV9mlSrGZPYlM2gQxAiW5kAVrDhaJqMZY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lUnH5dsjIdlLiWDbRQwFhditOe7D7T+Ya3D8lvRYLZBfAtHaI195cZC4Zrkz50kHu
         rs+yZw6ixMYHMjjt+PQ+JUVZi5oY5NMtm5QTYJSqLzi/oF9aqgtonfuB4+kRZxRHFP
         TBjtbWm9Qh4MeiSIT0mcli30FXGyLeSbVygFu+Gr3jLfgLwgUhKAu/oK8RRfcH4F9T
         2YlL+12Ar8I3NnihkukkR7lmqbhbXfvkGNYLicD3Sp3JduHbGdpiE3JoMw0efIxTaq
         3/QjDG65UoWHE6VdkS+VEkHDyF3YnApo2H4FrISJUehMMVDUfViq1HLoZiJUx3mPZA
         aB0z+9u/Jf9tQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE6EBE66CBA;
        Tue, 14 Mar 2023 23:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 0/2] Bluetooth: btrtl: add support for the RTL8723CS
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167883542083.4543.5507901905040064892.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Mar 2023 23:10:20 +0000
References: <20230307221732.3391-1-bage@debian.org>
In-Reply-To: <20230307221732.3391-1-bage@debian.org>
To:     Bastian Germann <bage@debian.org>
Cc:     marcel@holtmann.org, luiz.dentz@gmail.com, johan.hedberg@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Tue,  7 Mar 2023 23:17:29 +0100 you wrote:
> Pinebook uses RTL8723CS for WiFi and bluetooth. Unfortunately, RTL8723CS
> has broken BT-4.1 support, so it requires a quirk.
> 
> Add a quirk and wire up 8723CS support in btrtl.
> I was asked for a btmon output without the quirk;
> however, using the chip without the quirk ends up in a bad state with
> "Opcode 0x c77 failed: -56" (HCI_OP_READ_SYNC_TRAIN_PARAMS) on training.
> A btmon output with the quirk active was already sent by Vasily.
> 
> [...]

Here is the summary with links:
  - [v6,1/2] Bluetooth: Add new quirk for broken local ext features page 2
    https://git.kernel.org/bluetooth/bluetooth-next/c/000b57d5c009
  - [v6,2/2] Bluetooth: btrtl: add support for the RTL8723CS
    https://git.kernel.org/bluetooth/bluetooth-next/c/b8e482d02513

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


