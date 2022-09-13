Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1315F5B6924
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 10:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiIMIA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 04:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiIMIAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 04:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5F3248CC
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 01:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C86E1B80E29
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 08:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 870DFC43141;
        Tue, 13 Sep 2022 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663056015;
        bh=c5EPj75D98P2LYMS6YUHH54KM/ypulBhsCgfF/NZQx4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MOksJnwsCqxYtcZzzK63ZxszmlqfoHIB7qJM3LQrs09hjDPJHFKdMu0WHtdy4zCmY
         PBL5cd1mTF+J7l/RKj8CkLU5TxoyOqOot3BWS4cTmzYElk1MSo6pHJ8bA7CA+qi3iH
         YOQ4mpNubq/NV09nqD4rx/Cl30GVueR2iIOJ8JwcHRUH559hkPRjwp8gfA3wUC41IF
         Bk1ATC3Glz2CDWzirxd6SmrxrLB3g/yLEKm3iD1MM3BGpw5M0oaRUK0g6asIcfWmou
         864vBSeqGhS2cHktw1QeVz1JLnuc+5BGI7BsnT4L1rP4IEdosKIWkQ6fUP1nTvSzEX
         RGl75kdJKdrlQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66228C73FE9;
        Tue, 13 Sep 2022 08:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sfc: introduce shutdown entry point in efx pci
 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166305601539.22239.6689456371130393686.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Sep 2022 08:00:15 +0000
References: <20220906105620.26179-1-pieter.jansen-van-vuuren@amd.com>
In-Reply-To: <20220906105620.26179-1-pieter.jansen-van-vuuren@amd.com>
To:     <pieter.jansen-van-vuuren@amd.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 6 Sep 2022 11:56:20 +0100 you wrote:
> From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> 
> Make the device inactive when the system shutdown callback has been
> invoked. This is achieved by freezing the driver and disabling the
> PCI bus mastering.
> 
> Co-developed-by: Martin Habets <habetsm.xilinx@gmail.com>
> Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> 
> [...]

Here is the summary with links:
  - [net-next] sfc: introduce shutdown entry point in efx pci driver
    https://git.kernel.org/netdev/net-next/c/41e3b0722f6c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


