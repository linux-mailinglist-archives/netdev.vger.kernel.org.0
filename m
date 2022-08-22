Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6E759BEEC
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 13:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbiHVLvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 07:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbiHVLuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 07:50:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF111ADAF
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 04:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BDD86CE0F72
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 11:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F942C433D7;
        Mon, 22 Aug 2022 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661169014;
        bh=FqBais9ZMVXqX/YlkIHMfTSj1Mv/W16er/+JCCf3v+I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vCbzIT1UWuuyNdmhZtf/ZF5NGHaTsrps4AdLGZiimCG/9rkuy7yw5RX6idUU+mE4r
         yryMFI6gfCk/IMa9k7+dYF7GVHbJAFct7Jqj8Pfu6hTkGT2LCJTemyJDV0YWhedFMT
         Oe4pffzz/GZRLJRuQ+fuJy+5Kye3ddAj2T4idn7rBH3mt/vPISvOJIypzaHocYjuQF
         zYswew6gsqvdr3dkmBy8g5q0R2Azt+8zfDLDouDmUyw4SFpKi8u5ij6U6g3BsIsP89
         2Sw1Uh4wf+VaokdZ024lN+x2mkwP11jGA3v/CzOGjsfDfRaXal29DPaZHq0QXrq7cJ
         eaU7fhrZ8Br/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E9200C04E59;
        Mon, 22 Aug 2022 11:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 net-next] net: phy: realtek: add support for
 RTL8211F(D)(I)-VD-CG
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166116901394.17660.3710706470479418390.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Aug 2022 11:50:13 +0000
References: <20220817013618.6803-1-wei.fang@nxp.com>
In-Reply-To: <20220817013618.6803-1-wei.fang@nxp.com>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, xiaoning.wang@nxp.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Aug 2022 09:36:18 +0800 you wrote:
> From: Clark Wang <xiaoning.wang@nxp.com>
> 
> RTL8211F(D)(I)-VD-CG is the pin-to-pin upgrade chip from
> RTL8211F(D)(I)-CG.
> 
> Add new PHY ID for this chip.
> It does not support RTL8211F_PHYCR2 anymore, so remove the w/r operation
> of this register.
> 
> [...]

Here is the summary with links:
  - [V3,net-next] net: phy: realtek: add support for RTL8211F(D)(I)-VD-CG
    https://git.kernel.org/netdev/net-next/c/bb726b753f75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


