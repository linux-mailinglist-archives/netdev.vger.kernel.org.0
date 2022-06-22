Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819CB55425B
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357061AbiFVFuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357053AbiFVFuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7BB3668E
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF7B5B81C27
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 05:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 793C0C36AEA;
        Wed, 22 Jun 2022 05:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655877014;
        bh=/S85wz7gnYjPHrFOWNPO68ee3cS/V3bcgzpIN+phmyk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u12KfxPl0CYxlJCvzDHK61XBlkgvEwAOE7ihF/3DeU+UpOd9FMpKo+JR9UxE8y7CP
         rAprw64Od6IxLEl4dAhpyOIh/+IgPU1saYuTS1LpXLnz3wwm0XY+P1OtFoUN/gPAn/
         OzszkVSoKs/XazApB4apDvrhOimem7dDaU2mWWgzJ3wWgvRoQRrrx2JDAy4APtUFPa
         lchWH8eEMmUGHg9RO2S5p/8wSxB62gHJhsQswx4Qnsl2Xrppgfg8nHDQ2LT8Dcz6wG
         UxLmbRyFVd8C+ZweNflXzHZrZazptqfR1+wOPZwlCo4eI45Q/e4IaYbex3FxB6Pw21
         DP0E2oesQrn0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 671D9E7387A;
        Wed, 22 Jun 2022 05:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: smsc: Deduplicate interrupt
 acknowledgement upon phy_init_hw()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165587701441.11274.13617044736070685718.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Jun 2022 05:50:14 +0000
References: <0254edf48bddc96c6248c4414043a3699e94614a.1655716767.git.lukas@wunner.de>
In-Reply-To: <0254edf48bddc96c6248c4414043a3699e94614a.1655716767.git.lukas@wunner.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        andre.edich@microchip.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Jun 2022 11:28:39 +0200 you wrote:
> Since commit 4c0d2e96ba05 ("net: phy: consider that suspend2ram may cut
> off PHY power"), phy_init_hw() invokes both, the ->config_init() and
> ->config_intr() callbacks.
> 
> In the SMSC PHY driver, the latter acknowledges stale interrupts, hence
> there's no longer a need to acknowledge them in the former as well.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: smsc: Deduplicate interrupt acknowledgement upon phy_init_hw()
    https://git.kernel.org/netdev/net-next/c/b1f01b4bd7ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


