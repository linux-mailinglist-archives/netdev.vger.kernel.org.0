Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283DA5EE8A0
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 23:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiI1VuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 17:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbiI1VuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 17:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82C986FF7;
        Wed, 28 Sep 2022 14:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E8156200C;
        Wed, 28 Sep 2022 21:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4D16C433D7;
        Wed, 28 Sep 2022 21:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664401815;
        bh=0RzmOGYVkpMNE9+fZBsz9ZHEpeLGxXPoHcHDRJcT+78=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k5423oBf6Wx9gswTuSBwRGbiy7ITSGSZPFYgqMKGxTDJuUgZjc8RDQg8Qg9gojy5V
         +zD1qGcVJjg9pJstura4eqcLGRMwNWb7SVFjto1Vgx3MgSx9S0uPtp9yaXMi06MMk6
         sBf2zces9aL30b5s2j8fCT7wEAcSLJpNhH5CSJ7ZEvUUh3o+XRxOg7Mf8JbKUVKsWl
         82Oc+slIjz17DDa1bh/6N0YrE7jgVKeJmryHG+xD0uMOx2BNa+5r/8PavUq8gwhoJh
         zwVUlKgdDrGTteWizDyoi9+ESGvUjYjbN5Hvn3fLR0/Hw+aWfDUWmAzX84AZUw7Ll/
         /p6WVIVN9hpbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6788C395DA;
        Wed, 28 Sep 2022 21:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] Bluetooth: Call shutdown for HCI_USER_CHANNEL
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166440181567.17736.15009174210076483022.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 21:50:15 +0000
References: <20220927131717.v3.1.Ic8eabc8ed89a07c3d52726dd017539069faac6c4@changeid>
In-Reply-To: <20220927131717.v3.1.Ic8eabc8ed89a07c3d52726dd017539069faac6c4@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@google.com>
Cc:     linux-bluetooth@vger.kernel.org, abhishekpandit@chromium.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, marcel@holtmann.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
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

On Tue, 27 Sep 2022 13:17:20 -0700 you wrote:
> From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> Some drivers depend on shutdown being called for proper operation.
> Unset HCI_USER_CHANNEL and call the full close routine since shutdown is
> complementary to setup.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> [...]

Here is the summary with links:
  - [v3] Bluetooth: Call shutdown for HCI_USER_CHANNEL
    https://git.kernel.org/bluetooth/bluetooth-next/c/8dbc3e75a0a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


