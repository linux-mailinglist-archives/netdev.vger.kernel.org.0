Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A024D3FE3
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 04:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239324AbiCJDvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 22:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239315AbiCJDvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 22:51:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9DE6D946;
        Wed,  9 Mar 2022 19:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38EF3616EE;
        Thu, 10 Mar 2022 03:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87256C340F4;
        Thu, 10 Mar 2022 03:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646884210;
        bh=OW16WIE2WS+nMy1pZci5A2oqqRDPEZSYzU7wyzE3He0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rXUBnbJ+7wW71QeApDoRcXiFbDsE8TuTD5AQSPDVRh9l7hMzqnplLAL6+M/rPVw2a
         YvNf80KTSZpQ3oQX4vG2CWGxU6UA4itYk4R4GCApJlSOfn5GipA8WoCrVKnv7tpFXL
         2WLhvGFCQGs/cH7n9KlOCvIXxQ7blNsWcB0NqPqqk5eE/+28g/Nlf035WveWyjcXa/
         dZdsFs435OnFgQmqJq3J0+ZGLkERyBsiwMlOisDqMFt3qCx3HDOhZkyPSrOf50Sq8d
         UsnXhB5g17a5W3y5cZMByIaL2vhuha2M9yAbzfWdPisndmX4slThDVbYZ2+CkK6hVE
         dMTWx9Jhd7oQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6AEA5EAC095;
        Thu, 10 Mar 2022 03:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 1/1] net: dsa: microchip: ksz9477: implement MTU
 configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164688421043.27281.1517555067415457962.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 03:50:10 +0000
References: <20220308135857.1119028-1-o.rempel@pengutronix.de>
In-Reply-To: <20220308135857.1119028-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  8 Mar 2022 14:58:57 +0100 you wrote:
> This chips supports two ways to configure max MTU size:
> - by setting SW_LEGAL_PACKET_DISABLE bit: if this bit is 0 allowed packed size
>   will be between 64 and bytes 1518. If this bit is 1, it will accept
>   packets up to 2000 bytes.
> - by setting SW_JUMBO_PACKET bit. If this bit is set, the chip will
>   ignore SW_LEGAL_PACKET_DISABLE value and use REG_SW_MTU__2 register to
>   configure MTU size.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/1] net: dsa: microchip: ksz9477: implement MTU configuration
    https://git.kernel.org/netdev/net-next/c/e18058ea9986

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


