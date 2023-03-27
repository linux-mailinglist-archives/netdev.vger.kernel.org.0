Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC2B6C9E72
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbjC0Ioc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbjC0IoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:44:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C94C49EC
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14290610FB
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 08:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37895C4339E;
        Mon, 27 Mar 2023 08:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679906417;
        bh=7A8PXwut23IdNXzlF+VEieqrSPWal+UiozqL+SVvSmI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TAGqUalIIwooM0WgU0UwjgkwRywylFYvLMHuKiQ69L7y1r7L2rUx/xI8xQ3Wl9WIl
         nWDXNekUFHt3GHh5iziZ0igHbjJlrrnA07SaOqApVQ7ac0eRRRM/rdqdvFE8LBW7/A
         fP2Op03CFysbXMkZm0/kt7Apro96uSFbW6ajM+F/0GU3R5+jswvx6no4ZI1lEQcB4a
         D6TZLyKr0Sv1/sRz9f7B5UkMhnhqWg6h/iCn+GnhuZHwQD30lAo1lO3s6ksEzrByfH
         QGlqk4+xYxdr4piPU6CE0FP5H2aPcwOW3ekQ2gfpMyBzOpECoOZMSXTpE5mmyLJe+y
         mTQFhS4LDBl0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1D86EE2A038;
        Mon, 27 Mar 2023 08:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: bcm7xxx: use devm_clk_get_optional_enabled
 to simplify the code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167990641711.16673.11264341057362201314.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Mar 2023 08:40:17 +0000
References: <5603487f-3b80-b7ec-dbd2-609fa8020e58@gmail.com>
In-Reply-To: <5603487f-3b80-b7ec-dbd2-609fa8020e58@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Mar 2023 22:23:58 +0100 you wrote:
> Use devm_clk_get_optional_enabled to simplify the code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/bcm7xxx.c | 22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)

Here is the summary with links:
  - [net-next] net: phy: bcm7xxx: use devm_clk_get_optional_enabled to simplify the code
    https://git.kernel.org/netdev/net-next/c/4228c3a23adc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


