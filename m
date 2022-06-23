Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804B9556FFD
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 03:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237955AbiFWBkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 21:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiFWBkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 21:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B524161F
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 18:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31FE7B821A1
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 01:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA38CC341CB;
        Thu, 23 Jun 2022 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655948414;
        bh=l8VSDbn/ht+W4yI+gVP0N4zOJeJstJNudlBa8ohx5tI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lghm3HuAWoSa6JKjd49rFKzh+KWdNO7uuHWQnB7DSnRQKzp382Q0HBjkO+Chsz18R
         1wnGRZrgOWcWsgVB88VHSVwiOyA7zkZOLJpm04ZFUCpoTK4w/oBgO794grtiEEvqya
         Ddm/CFBXODRsBoc4ohShqjbKaa7AEHxQWQ+mGQqyL3jM13IBWcy9EOZA/dDTEf/kLj
         iYcHEoIzzHQLQXhDxI02B/xCmoowwvmawk/bZMQZrprb6vapz7sP1hC9eCmMlgwatg
         IH8WNblCc/gWyqjOc2fhs6fvuR7A3KLMKt8gwsQlyTgTuTBneKdT/DFKejN9HX1N5I
         SWAEcOJpIxItw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D596DE7BB90;
        Thu, 23 Jun 2022 01:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] net: phy: Add support for AQR113C EPHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165594841387.25849.16004544949154465980.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 01:40:13 +0000
References: <20220621034027.56508-1-vbhadram@nvidia.com>
In-Reply-To: <20220621034027.56508-1-vbhadram@nvidia.com>
To:     Bhadram Varka <vbhadram@nvidia.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org
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

On Tue, 21 Jun 2022 09:10:27 +0530 you wrote:
> Add support multi-gigabit and single-port Ethernet
> PHY transceiver (AQR113C).
> 
> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> ---
>  drivers/net/phy/aquantia_main.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

Here is the summary with links:
  - [net-next,v1] net: phy: Add support for AQR113C EPHY
    https://git.kernel.org/netdev/net-next/c/12cf1b89a668

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


