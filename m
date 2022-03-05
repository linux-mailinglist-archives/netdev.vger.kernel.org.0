Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DEE4CE47E
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 12:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiCELVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 06:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiCELVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 06:21:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7281B79D
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 03:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48CB0611D5
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 11:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A18F5C340F1;
        Sat,  5 Mar 2022 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646479213;
        bh=ttD+E0dqOpHDuENrbTRNpsi/+KR2j1/p4arEPXww05M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pw+iNawt1+lU2GNkBS25xU0YUjW0xA7CBOyS43cP1BDoyVMt1Yev08KxMTopNfa0J
         kX5SWsvtDioVmZgIxEc2XE+qlrJ8KkvlbkJwAoB9gU3DwxII39WWNlMIHEBU+64/LW
         MguHve8ogGAS6KeN9QpO0YPLdnqm0k2Bmwi115IFF3yUlDZrlYTVOQWp7MwXCPgwHx
         ZUBlBHMlvxSEnrfVY61BpXReqDvP1W6Vq+hS74xlBBYTi29hOqVWfMZ54NP52ax/8K
         uwWc6osN3ZM64aunBi844ST1jfdRWYwi7zpFObLPjHavgzhvFqiIwZdd2aPrmD835L
         fty2iRKhE+5dw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86D14E6D44B;
        Sat,  5 Mar 2022 11:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/7] NAPI/GRO support for axienet driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164647921354.16870.15617244602139449593.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Mar 2022 11:20:13 +0000
References: <20220305022443.2708763-1-robert.hancock@calian.com>
In-Reply-To: <20220305022443.2708763-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, radhey.shyam.pandey@xilinx.com,
        davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        linux@armlinux.org.uk, daniel@iogearbox.net,
        linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  4 Mar 2022 20:24:36 -0600 you wrote:
> Add support for NAPI and GRO receive in the Xilinx AXI Ethernet driver,
> and some other related cleanups.
> 
> Changes since v2:
> -fix undocumented members in axienet_local struct
> 
> Changes since v1:
> -fix 32-bit ARM compile error
> -fix undocumented function parameter
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/7] net: axienet: fix RX ring refill allocation failure handling
    https://git.kernel.org/netdev/net-next/c/7a7d340ba4d9
  - [net-next,v3,2/7] net: axienet: Clean up device used for DMA calls
    https://git.kernel.org/netdev/net-next/c/17882fd42567
  - [net-next,v3,3/7] net: axienet: Clean up DMA start/stop and error handling
    https://git.kernel.org/netdev/net-next/c/84b9ccc0749a
  - [net-next,v3,4/7] net: axienet: don't set IRQ timer when IRQ delay not used
    https://git.kernel.org/netdev/net-next/c/0155ae6eb84d
  - [net-next,v3,5/7] net: axienet: implement NAPI and GRO receive
    https://git.kernel.org/netdev/net-next/c/cc37610caaf8
  - [net-next,v3,6/7] net: axienet: reduce default RX interrupt threshold to 1
    https://git.kernel.org/netdev/net-next/c/40da5d680e02
  - [net-next,v3,7/7] net: axienet: add coalesce timer ethtool configuration
    https://git.kernel.org/netdev/net-next/c/0b79b8dc97b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


