Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D945872EF
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 23:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiHAVPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 17:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbiHAVPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 17:15:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A41DB9;
        Mon,  1 Aug 2022 14:15:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 513E1612F2;
        Mon,  1 Aug 2022 21:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A39DEC433D7;
        Mon,  1 Aug 2022 21:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659388546;
        bh=eP1nsYPf5j0CKCqLcWYUaDg6KQqdKfNltu4AVdSfiS4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iQLQBrMn6vISUmf0tbu2ysCJ9og71ez4lLxn7mZFAXeiWujiYhDSIRw9auJu0Lggb
         NALYLBZrEYNGA+AK8mAXUZM2LSC6OeEKL0crTB7hjMVjgksK2yMgwgIYfwI+kejtZ5
         0c6cgOe6g0wTv2Yk6/HjKGFWJAG8jmvaSI9C+RPTAyVlTkOZ25c6dYA+okWpYhtT4J
         UHGspBv+IHexRdLtGG+yg6oFDMZGuDvhAitwIOYYvU9uJpKm3cjjuqGSFs+/36KFbh
         1pssbBl7hCgHVKjsju1r/BkbeAjzzxONzcCGlhpuMmnE8/L8PJQUNrnc5m6LzZ0aBY
         IPb410m4rHC8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 854B6C43144;
        Mon,  1 Aug 2022 21:15:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] Bluetooth: Always set event mask on suspend
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165938854654.17345.15374057597659100152.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 21:15:46 +0000
References: <20220725153415.v2.1.Ia18502557c4ba9ba7cd2d1da2bae3aeb71b37e4e@changeid>
In-Reply-To: <20220725153415.v2.1.Ia18502557c4ba9ba7cd2d1da2bae3aeb71b37e4e@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@google.com>
Cc:     luiz.dentz@gmail.com, linux-bluetooth@vger.kernel.org,
        abhishekpandit@chromium.org, stable@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        johan.hedberg@gmail.com, marcel@holtmann.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 25 Jul 2022 15:34:21 -0700 you wrote:
> From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> When suspending, always set the event mask once disconnects are
> successful. Otherwise, if wakeup is disallowed, the event mask is not
> set before suspend continues and can result in an early wakeup.
> 
> Fixes: 182ee45da083 ("Bluetooth: hci_sync: Rework hci_suspend_notifier")
> Cc: stable@vger.kernel.org
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> [...]

Here is the summary with links:
  - [v2] Bluetooth: Always set event mask on suspend
    https://git.kernel.org/bluetooth/bluetooth-next/c/ef61b6ea1544

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


