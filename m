Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6508D641448
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 06:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiLCFaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 00:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiLCFaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 00:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E635512AA2;
        Fri,  2 Dec 2022 21:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EDA860110;
        Sat,  3 Dec 2022 05:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC683C433D7;
        Sat,  3 Dec 2022 05:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670045417;
        bh=W41CUFCrD9qVJ0Xwff8Px3XqjvoC1YmVqP5D/nWRCkE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m3BZphUtUbMDUTjq0nE3wFPXXsGmOj30CKaG0NHWVfyV2dfox4PmR4RqVLaKRpy6a
         k3uOznVAIHVBHERkkKRrr7nfwrQ5/PhOdWTR+QmjCQsqcKumrrAUfn9D6YQU1718YQ
         u1Dj01SahDsKR3UHFF5Vh7HL4TF9G9O11wqHHiTsPZTSGjiIIwftI4LuTU499rc5Gz
         6tGplm7JbkMmt4PXbI6uRSVWDNsBMBNlVAuxCudEHv/NM3BRqkn+opvkdUmgxnLu4j
         Lq9zynfmJJROwkvDDFMm9EHn8tKXmbcGonfK+elX2lpSLVwoTq9ooAINafmxyEQPHD
         bPQbvJH2qnkig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B270FE29F3E;
        Sat,  3 Dec 2022 05:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 1/3] net: dsa: ksz: Check return value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167004541772.20517.321747008541593709.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Dec 2022 05:30:17 +0000
References: <20221201140032.26746-1-artem.chernyshev@red-soft.ru>
In-Reply-To: <20221201140032.26746-1-artem.chernyshev@red-soft.ru>
To:     Artem Chernyshev <artem.chernyshev@red-soft.ru>
Cc:     olteanv@gmail.com, woojung.huh@microchip.com, f.fainelli@gmail.com,
        davem@davemloft.net, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  1 Dec 2022 17:00:30 +0300 you wrote:
> Return NULL if we got unexpected value from skb_trim_rcsum()
> in ksz_common_rcv()
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: bafe9ba7d908 ("net: dsa: ksz: Factor out common tag code")
> Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v3,1/3] net: dsa: ksz: Check return value
    https://git.kernel.org/netdev/net/c/3d8fdcbf1f42
  - [v3,2/3] net: dsa: hellcreek: Check return value
    https://git.kernel.org/netdev/net/c/d4edb5068865
  - [v3,3/3] net: dsa: sja1105: Check return value
    https://git.kernel.org/netdev/net/c/8948876335b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


