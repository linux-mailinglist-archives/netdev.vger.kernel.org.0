Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4895F7E34
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 21:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiJGTka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 15:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiJGTkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 15:40:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7A9C5884;
        Fri,  7 Oct 2022 12:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3141B8242F;
        Fri,  7 Oct 2022 19:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7404AC433C1;
        Fri,  7 Oct 2022 19:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665171615;
        bh=r9RHj3JVPBS4Nf+3GLxt7M35xPV1N2v79wn2NXG965A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HvbuGLetDWkC33XsRwMefBZV+Pj7QfhvBC34nCLcoA0RM5EcAoC2sN2/parqe7gIi
         RxZm7uGkApeVjaagp+jCFKpzdFSKb88vdnh8GpJo5P+6sJMlliYjgM0hrsePVO2mWv
         wOyv42VtjkUEs1lFjqe0gI8Nk6KKnFC8BTW1mcfZFHUBnHXBYK1NUBWpJyrCur+YSe
         gAxefidF4PUnSkqH6HwMIdVmtMIzmg04u0XaKufsJy28FT2T7/DXLUac427StXLD0C
         I6ll7oQxod2TOQ3qGw4gDoyrmW3Hksi8x73VtsFELDIrhlXkvrLUdzsLeOg/Yo/QDX
         yfbblcCtplZeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58AE1E2A05D;
        Fri,  7 Oct 2022 19:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] Bluetooth: btusb: Introduce generic USB reset
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166517161535.22886.13424048980960656308.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Oct 2022 19:40:15 +0000
References: <20221006170915.v3.1.I46e98b47be875d0b9abff2d19417c612077d1909@changeid>
In-Reply-To: <20221006170915.v3.1.I46e98b47be875d0b9abff2d19417c612077d1909@changeid>
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, chromeos-bluetooth-upstreaming@chromium.org,
        apusaka@chromium.org, abhishekpandit@google.com,
        yinghsu@chromium.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, johan.hedberg@gmail.com, pabeni@redhat.com,
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

On Thu,  6 Oct 2022 17:09:31 +0800 you wrote:
> From: Archie Pusaka <apusaka@chromium.org>
> 
> On cmd_timeout with no reset_gpio, reset the USB port as a last
> resort.
> 
> This patch changes the behavior of btusb_intel_cmd_timeout and
> btusb_rtl_cmd_timeout.
> 
> [...]

Here is the summary with links:
  - [v3] Bluetooth: btusb: Introduce generic USB reset
    https://git.kernel.org/bluetooth/bluetooth-next/c/b9c747ff82b4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


