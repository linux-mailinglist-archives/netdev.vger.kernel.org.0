Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C596BAB62
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjCOJAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbjCOJA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:00:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0129F2ED4C;
        Wed, 15 Mar 2023 02:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D346B81DA8;
        Wed, 15 Mar 2023 09:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBF3BC433D2;
        Wed, 15 Mar 2023 09:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678870818;
        bh=G0QmhIrqWNMWYnwuDWWxUtqhxaLGtT1V9FNUycJGtYk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JlEggPefmq7amPGtcXIOBHdnf62gtOgXRhY6kU2RKlipDRO/RLi57WV9O4QnL9pfQ
         nhOEHggknDx86n6IddrLB16p8uGNq3gOQ1+T/FjcpWHcArm1Ik31QAP7uMg0GaaOA1
         +u3ncufibFHgW0H5WBLwZAE9vKY2354TQmKYI0MygK0az7g7qSCwWDEb/Xy+QuEW63
         798kpORkRUHhF5wGGzB/GCMtz/S2imqzQFmnTCv0zuy0Xw+jrjEosV+c5cXyFSAWm4
         anelk/W5xQFjprzzy1Tt9hsbc2xI029AXo6Qg361G7bScu11KrhS7EHWyABEBaY9iI
         moX1INtx35cuw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C2CBCE66CBC;
        Wed, 15 Mar 2023 09:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: smsc75xx: Limit packet length to skb->len
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167887081879.17591.15568032796714316923.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 09:00:18 +0000
References: <20230313220045.52394-1-szymon.heidrich@gmail.com>
In-Reply-To: <20230313220045.52394-1-szymon.heidrich@gmail.com>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>
Cc:     steve.glendinning@shawell.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Mar 2023 23:00:45 +0100 you wrote:
> Packet length retrieved from skb data may be larger than
> the actual socket buffer length (up to 9026 bytes). In such
> case the cloned skb passed up the network stack will leak
> kernel memory contents.
> 
> Fixes: d0cad871703b ("smsc75xx: SMSC LAN75xx USB gigabit ethernet adapter driver")
> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: usb: smsc75xx: Limit packet length to skb->len
    https://git.kernel.org/netdev/net/c/d8b228318935

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


