Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157875FBB6E
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 21:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiJKTk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 15:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJKTkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 15:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777DF4DF39;
        Tue, 11 Oct 2022 12:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A00CB81687;
        Tue, 11 Oct 2022 19:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B118AC433D6;
        Tue, 11 Oct 2022 19:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665517215;
        bh=fSa96AsBk2B5TQLhU0NJorhENI0zD2WOvcXvMQC90tM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XlBNHVuLg7mC8dNVnCspsX4avawFTAbOqz7ygk2jas+TUcDDt0JPH3Qzj/loX/QD4
         Ru2FcvYlwEaFD9GP1/T8D9wJdtXCemqGy/0Wzs3WrQlXilw5tj6/6wKi2jlLSunfnK
         nf20S+h4gTMkKQtRgX3VZpFd51tcmok8xQ7XDh/b+ejTzfTv83wZxYTWel+WkwXP/0
         Q0vnt4swSvU49OHJj6q75TUHDQsqxpkPQYaus8Xdmsvy1jR3E0VY846xjvHwYvAGfs
         TnYWg6hPN6BdnguT583w+IgiIiDYl7soyXXGBDxUNZfvyCd+RNZPHf/eyc25bnE2j0
         KCEziBujKWV7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8CFF0E29F34;
        Tue, 11 Oct 2022 19:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: hci_sync: cancel cmd_timer if hci_open failed
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166551721557.30530.2713300623077176869.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Oct 2022 19:40:15 +0000
References: <20221005150934.1.Ife932473db2eec6f0bc54226c3328e5fa8c5f97b@changeid>
In-Reply-To: <20221005150934.1.Ife932473db2eec6f0bc54226c3328e5fa8c5f97b@changeid>
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, chromeos-bluetooth-upstreaming@chromium.org,
        apusaka@chromium.org, abhishekpandit@google.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        johan.hedberg@gmail.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  5 Oct 2022 15:09:47 +0800 you wrote:
> From: Archie Pusaka <apusaka@chromium.org>
> 
> If a command is already sent, we take care of freeing it, but we
> also need to cancel the timeout as well.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@google.com>
> 
> [...]

Here is the summary with links:
  - Bluetooth: hci_sync: cancel cmd_timer if hci_open failed
    https://git.kernel.org/bluetooth/bluetooth-next/c/64b5c4c8e79c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


