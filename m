Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D490E526F4D
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiENCr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 22:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiENCr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 22:47:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139584F6133;
        Fri, 13 May 2022 17:49:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6728AB8324C;
        Sat, 14 May 2022 00:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 258A4C34100;
        Sat, 14 May 2022 00:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652487612;
        bh=VbH6Eye7rDprrBdwdIeqL7tRQ78t85laQ8YSPwhSV1g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I2XyV2+sHI8TA9wcJNxT+5veFxwxzCz6kr4ib/sqAPVTZSnlQJr7LoIULCQwDHawP
         nZFFYmtBjh6jhN8d8a3gQFpEe0mu1WKaOLZjvCPsnt60zGNwt62C4yp5Yyb8Kpk8IR
         tqvMOYUH6WNq1Eb97oaJ1SAGayzg9Sw2wRGVdaS6zLTU9y4wrpwXHuU5IR3NGF8SG5
         ScflNvtOuq3Rw7o0q/Flwqf1kaxoPknVMMI+AFKOmT4u2qIdhNZXU6pL8kLLdZPDSb
         hWufMt9mInN3DMIbNS5+uzge+JlZOAifYLgZSP2NQHBMU/FpGJkMdu1HbI0Z5My0Q3
         NEl7oBPrCNWqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A830F03934;
        Sat, 14 May 2022 00:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: macb: Increment rx bd head after allocating skb and
 buffer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165248761203.19970.11604393560078071280.git-patchwork-notify@kernel.org>
Date:   Sat, 14 May 2022 00:20:12 +0000
References: <20220512171900.32593-1-harini.katakam@xilinx.com>
In-Reply-To: <20220512171900.32593-1-harini.katakam@xilinx.com>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        radhey.shyam.pandey@xilinx.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 May 2022 22:49:00 +0530 you wrote:
> In gem_rx_refill rx_prepared_head is incremented at the beginning of
> the while loop preparing the skb and data buffers. If the skb or data
> buffer allocation fails, this BD will be unusable BDs until the head
> loops back to the same BD (and obviously buffer allocation succeeds).
> In the unlikely event that there's a string of allocation failures,
> there will be an equal number of unusable BDs and an inconsistent RX
> BD chain. Hence increment the head at the end of the while loop to be
> clean.
> 
> [...]

Here is the summary with links:
  - [v2] net: macb: Increment rx bd head after allocating skb and buffer
    https://git.kernel.org/netdev/net/c/9500acc631db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


