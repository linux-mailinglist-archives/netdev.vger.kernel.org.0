Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A23E57BBDD
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 18:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiGTQuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 12:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbiGTQuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 12:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1979D1C11B;
        Wed, 20 Jul 2022 09:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6FDFB82153;
        Wed, 20 Jul 2022 16:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 375B8C341CB;
        Wed, 20 Jul 2022 16:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658335813;
        bh=WT84V7ACiUl91qudaiHG4+cA67epzE9hd9IylF7pkU8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PhJsXFIMLQ5gDHJa+GGnjwwwuanxDrdyiYA8xLdkdX0wVzbTiLC7Gg956J0NhpZcx
         1X3CKO/zL+A0rN4pHwwpmzLYvOk+C5dA9eR+ZvP4WeV3j5W+REi6ZLUIYVHHYfYJXN
         /StgmcG35r5wJncS21bAB+9Pz91LTT8IPGMJ7BhV8O1TX5mP6X+du7FV+1D76cVXCH
         IttlQecJdPe/lmzdEy28QfUtgJzbmaNiqeBHlH61YcvIqe3TplylGvziFwIonFskgi
         /f5+qv2yiW20PPoaBN/UDcF7cQy06sMT/8GbN4Done7q2gODchCKUa7mxK9/E3cCdW
         x0ZbiiM+CQRUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1D0D3E451B3;
        Wed, 20 Jul 2022 16:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] Bluetooth: hci_sync: Correct
 hci_set_event_mask_page_2_sync() event mask
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165833581311.23595.15064528524908565872.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 16:50:13 +0000
References: <1657695194-25801-1-git-send-email-quic_zijuhu@quicinc.com>
In-Reply-To: <1657695194-25801-1-git-send-email-quic_zijuhu@quicinc.com>
To:     Zijun Hu <quic_zijuhu@quicinc.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, luiz.von.dentz@intel.com,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 13 Jul 2022 14:53:14 +0800 you wrote:
> Event HCI_Truncated_Page_Complete should belong to central
> and HCI_Peripheral_Page_Response_Timeout should belong to
> peripheral, but hci_set_event_mask_page_2_sync() take these
> two events for wrong roles, so correct it by this change.
> 
> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> 
> [...]

Here is the summary with links:
  - [v1] Bluetooth: hci_sync: Correct hci_set_event_mask_page_2_sync() event mask
    https://git.kernel.org/bluetooth/bluetooth-next/c/f7913b8db3c4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


