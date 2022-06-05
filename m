Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E4E53DA2A
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 06:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348975AbiFEEus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 00:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243886AbiFEEuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 00:50:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AD830549;
        Sat,  4 Jun 2022 21:50:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69D45B80B1E;
        Sun,  5 Jun 2022 04:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E32ACC3411E;
        Sun,  5 Jun 2022 04:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654404612;
        bh=dcwSlAM5U/7L22E5xajUTM+Pauz9nH1K/BMqy+7wPyI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mOsDVRbjz5GwqQvoPcx7EqqMXPf9HkN8EK1Z1c43r+4ryOBsbI30CCbaMjm5sV01k
         F+i97c/Sdtod0bmakwgVMfD4O23whRRtIYmgXSUMTItihHTVGRusV96a/P5V9UPNyo
         5D54mfOUnCpYzQaOKhwl/d6STWBPKTh+4PGyyKtyul70ku1ZLbaaxcAs1VV57uVBme
         1stgadTt3efGwGnRTpc8V9Eg4YMmOC+I8cFYTmRjHkeN9NT95F22rgEMqZ1VLR6Hq4
         DokZq+fdZBQBa7LTtLLuW1Rp1S+V230WE0BVPhQjo0WNIS9kQf8Idw/ODkLYc7ToqG
         wPejng/EB8bXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CAEECF5F177;
        Sun,  5 Jun 2022 04:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] Bluetooth: Fix index added after unregister
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165440461282.31102.17462326993445996139.git-patchwork-notify@kernel.org>
Date:   Sun, 05 Jun 2022 04:50:12 +0000
References: <20220602094645.1.I7d191480c15b45a237b927e26aa26ba806409efb@changeid>
In-Reply-To: <20220602094645.1.I7d191480c15b45a237b927e26aa26ba806409efb@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, abhishekpandit@chromium.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        johan.hedberg@gmail.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

This series was applied to bluetooth/bluetooth-next.git (master)
by Marcel Holtmann <marcel@holtmann.org>:

On Thu,  2 Jun 2022 09:46:49 -0700 you wrote:
> From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> When a userchannel socket is released, we should check whether the hdev
> is already unregistered before sending out an IndexAdded.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> [...]

Here is the summary with links:
  - [1/2] Bluetooth: Fix index added after unregister
    https://git.kernel.org/bluetooth/bluetooth-next/c/8d4b73539cca
  - [2/2] Bluetooth: Unregister suspend with userchannel
    https://git.kernel.org/bluetooth/bluetooth-next/c/d6bb2a91f95b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


