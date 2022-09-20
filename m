Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C7B5BD928
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiITBKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiITBK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:10:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6BA3ED69;
        Mon, 19 Sep 2022 18:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AE48B822BC;
        Tue, 20 Sep 2022 01:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 229B7C4314A;
        Tue, 20 Sep 2022 01:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636221;
        bh=tAdQOQKbs9aPWvdoyea6xZp85xoMMvlK9Lfn6K2rcK8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ckLyd9PMDf+q+qNJ3e7shAaPr00Bx79/iw+HHp2UsBvMqk3s2EAv6qZViNOEHQxL1
         RiygdnBXs0bK3+bsKtH7Ci8QDznlHT2C87+WCS6CAMY8F3zN1StqqDaAo8h5LpyoBH
         OhQQWD6ZUNfuVW3ADxAdQaqHqaajsYJNHK1FPz34Gufkp31xKDzAUBJjpym6Dqqugg
         oMFd4a/vmyWZN5ifLgziyVImbA4LAO5ZIOaBu7XoSkQVArVkotq+T7dgzODSO8Uczo
         o8DNxJj2TqBaKLmMQ86F4fRBQHshyJFBbi87bOcTFgDqP1h+WlQKoJW3PxlCoAxN+j
         v/4OBBvHgJa4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 03BA3E52536;
        Tue, 20 Sep 2022 01:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: micrel: Cable Diag feature for lan8814 phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363622101.23429.13787591813706362999.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:10:21 +0000
References: <20220909083123.30134-1-Divya.Koppera@microchip.com>
In-Reply-To: <20220909083123.30134-1-Divya.Koppera@microchip.com>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 9 Sep 2022 14:01:23 +0530 you wrote:
> Support for Cable Diagnostics in lan8814 phy
> 
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 125 +++++++++++++++++++++++++++++++++------
>  1 file changed, 107 insertions(+), 18 deletions(-)

Here is the summary with links:
  - [net-next] net: phy: micrel: Cable Diag feature for lan8814 phy
    https://git.kernel.org/netdev/net-next/c/21b688dabecb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


