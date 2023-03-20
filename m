Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFCA6C0ED3
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCTKbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjCTKbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:31:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2C423D83
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 03:30:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE732B80DF4
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73F86C433A1;
        Mon, 20 Mar 2023 10:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679308219;
        bh=E1UbJSzmyJWB+Ip+7lA/E2uYFpHu21Mx2BIPf6mT92Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mqXKB4Imyk63KdPxT57euJgjTbftGzdomQqkhM5L9oVW38rlzsL62FqIAYg9hGkl+
         6RwZKWB0D4JTTckm4SCSB1s7danUVVxlPMjeOFxPAE8xJtVRkHgBwFhxB/bYY97eJ3
         lDnCm32mnPhjp8TD1f1cHm358O8B8fk6q5QeJyvNLaqql8LQ+Iv5HHiqWPikIsGqSj
         mzlkbdpex7WglEifPPN/FBRNQI96cWFUMMkxaVrDqdUP3rIe3WiYuy3OOY/PTrQBl0
         COP7wnEpSDqBXDS6kq5+RX+ketWYkoKKmbl3QS8rPdZusW/F7RjhqNudFR9nlkHdxT
         1y3p5hg6OPYUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 565B5E2A047;
        Mon, 20 Mar 2023 10:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: consolidate disabling ASPM before EPHY access
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167930821934.19842.17052352181983861721.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Mar 2023 10:30:19 +0000
References: <d9aebd88-6cbb-259e-f9bc-008071f0ad5e@gmail.com>
In-Reply-To: <d9aebd88-6cbb-259e-f9bc-008071f0ad5e@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     nic_swsd@realtek.com, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 18 Mar 2023 22:50:10 +0100 you wrote:
> Now that rtl_hw_aspm_clkreq_enable() is a no-op for chip versions < 32,
> we can consolidate disabling ASPM before EPHY access in rtl_hw_start().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 42 ++---------------------
>  1 file changed, 3 insertions(+), 39 deletions(-)

Here is the summary with links:
  - [net-next] r8169: consolidate disabling ASPM before EPHY access
    https://git.kernel.org/netdev/net-next/c/5fc3f6c90cca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


