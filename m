Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDBC575611
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 22:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240641AbiGNUAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 16:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiGNUAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 16:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43805F133;
        Thu, 14 Jul 2022 13:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A33E62212;
        Thu, 14 Jul 2022 20:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9AED6C34115;
        Thu, 14 Jul 2022 20:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657828813;
        bh=L/q2C7SYQkUyZD3IgdzL4euZ9WCMW35Xm7pctMA5yWk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F7B+bhr2/Wh5CLzfVW6kAWH/a0jSA4pZ87cPvI1/KIQV3bHq6kG3PCl5AWoZxpMp3
         c7yacAmCbyL/tdrp7gPo39COozWsil/m6t9iHnSbs2LbWeZFs2/UgjRGf1sMf67Ikp
         35rvTB4eI+rCV3wvlSGbLbJmbpGkAkzQkaYNyngrdxFz1NqvP4OibCx/mx82cOwlG+
         yCk/IaOaJE/Vicib09WsuXARZ1aI63ydK5FhJz99UUIkE1RM1WXPC3iFVMrvvNOrBq
         ZRMZsRVlrtQn9sRkuEF6KXDdsGpMcF29VauZN9QxOnMER6W+NVUFcwRmquwKu+hNto
         rsipy3kX//+sw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D46EE45227;
        Thu, 14 Jul 2022 20:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] Bluetooth: Collect kcov coverage from hci_rx_work
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165782881350.24437.8150730211077461222.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 20:00:13 +0000
References: <20220714104814.1296858-1-poprdi@google.com>
In-Reply-To: <20220714104814.1296858-1-poprdi@google.com>
To:     Tamas Koczka <poprdi@google.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        theflow@google.com, nogikh@google.com, dvyukov@google.com
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

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Thu, 14 Jul 2022 10:48:14 +0000 you wrote:
> Annotate hci_rx_work() with kcov_remote_start() and kcov_remote_stop()
> calls, so remote KCOV coverage is collected while processing the rx_q
> queue which is the main incoming Bluetooth packet queue.
> 
> Coverage is associated with the thread which created the packet skb.
> 
> The collected extra coverage helps kernel fuzzing efforts in finding
> vulnerabilities.
> 
> [...]

Here is the summary with links:
  - [v2] Bluetooth: Collect kcov coverage from hci_rx_work
    https://git.kernel.org/bluetooth/bluetooth-next/c/b28a31ebc74f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


