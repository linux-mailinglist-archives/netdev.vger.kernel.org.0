Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FA15226E1
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 00:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbiEJWaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 18:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbiEJWaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 18:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EF325B05E;
        Tue, 10 May 2022 15:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61444B82014;
        Tue, 10 May 2022 22:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 203FDC385D1;
        Tue, 10 May 2022 22:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652221813;
        bh=zUenaunzMFKCxprStyr9lWv3IriMF9H8jUGb9TfBr2Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VZNj4Ohp3/Ztn04h+Qclf3mLbe4cHfxOZH6bMO6TqBR9qLmqxZ2SrUy07fAFdhPg1
         u7eIjODb9NbVT5g21vRDg3YWEcpKWhboeqGRo3Yu6+vtkntv2bA44QLg/bvyl+R9nD
         81V369lHgvKAHv1Z2iDFbmS7XQfPgCgcSy1W37iZXNqY47EXpF1FAJjbtPCBBmT611
         RxH8Mvkt4UEes9qT3ASFbnwKgPRXSIRtUs2FHLFyntJuMxohJhKGlH3pUgEe/vA59a
         +GoOpXF+ahwcuwzp31rAW4VkQa/GCP1/n26AY+zlAmTuMuAhEcBoG2VGQxwBo19Tre
         7KPXuo3oOPGhQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6C74F03930;
        Tue, 10 May 2022 22:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: phy: micrel: Fix incorret variable type in micrel
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165222181294.9200.14239938833092896209.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 22:30:12 +0000
References: <20220509144519.2343399-1-wanjiabing@vivo.com>
In-Reply-To: <20220509144519.2343399-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, horatiu.vultur@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Mon,  9 May 2022 22:45:19 +0800 you wrote:
> In lanphy_read_page_reg, calling __phy_read() might return a negative
> error code. Use 'int' to check the error code.
> 
> Fixes: 7c2dcfa295b1 ("net: phy: micrel: Add support for LAN8804 PHY")
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
> Changelog:
> v2:
> - Add a 'Fixes' tag.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: phy: micrel: Fix incorret variable type in micrel
    https://git.kernel.org/netdev/net/c/12a4d677b1c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


