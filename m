Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531435EE8A4
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 23:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbiI1Vua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 17:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbiI1VuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 17:50:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB6386731;
        Wed, 28 Sep 2022 14:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A04BFCE1FD6;
        Wed, 28 Sep 2022 21:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB6DDC433C1;
        Wed, 28 Sep 2022 21:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664401815;
        bh=revs7MRkpBrHtNJO1aVaEpLM4dqhY5Vmifno0mWF5P8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V10HUXdDaJ7vzgnaK3J89ly4MO4pfdj79Uq/CjS4nqdiXJV9/zgUsS5LAm4C8WI5O
         EMTB10zFZTMKE7KP4ZuRaTSb+MsaKztLHXGZ5QsgVuRa6EhChnQwRczDuyWMb0fuK2
         3/S0maFe+ODiHCCzdZJ1LRrmBWvFZ6Xi0ZJuicZonCan3Isb0Fi1y0yjnF78a8m5Wl
         AfWRnvkbY0OMVZFwv8eqrziOQDfvvEXKYscYZNexlkaOxVc6FnO7+Nj9rZifH+sGMw
         1U4Q4mBgHP3ffYs3ujXs7hulzvZliNKMq6qF1Epa5cEZ0LQdCj0lvewOiEzNZEZzOO
         xc5kRTo5eGTxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B3C56E4D021;
        Wed, 28 Sep 2022 21:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] Bluetooth: Prevent double register of suspend
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166440181573.17736.18391777686258577033.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 21:50:15 +0000
References: <20220928130027.v3.1.Ia168b651a69b253059f2bbaa60b98083e619545c@changeid>
In-Reply-To: <20220928130027.v3.1.Ia168b651a69b253059f2bbaa60b98083e619545c@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@google.com>
Cc:     linux-bluetooth@vger.kernel.org, abhishekpandit@chromium.org,
        syzkaller@googlegroups.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, marcel@holtmann.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Wed, 28 Sep 2022 13:00:30 -0700 you wrote:
> From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> Suspend notifier should only be registered and unregistered once per
> hdev. Simplify this by only registering during driver registration and
> simply exiting early when HCI_USER_CHANNEL is set.
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Fixes: 359ee4f834f5 (Bluetooth: Unregister suspend with userchannel)
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> [...]

Here is the summary with links:
  - [v3] Bluetooth: Prevent double register of suspend
    https://git.kernel.org/bluetooth/bluetooth-next/c/4b8af331bb4d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


