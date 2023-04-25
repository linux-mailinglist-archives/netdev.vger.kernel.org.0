Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FE26EDA27
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 04:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbjDYCKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 22:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbjDYCKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 22:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C663355AF;
        Mon, 24 Apr 2023 19:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 663A96200F;
        Tue, 25 Apr 2023 02:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC480C4339B;
        Tue, 25 Apr 2023 02:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682388618;
        bh=N3BII6enj6G3DEwVJPt08yRE5cUr8sUOZrOBWdlV5oc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VEJMDb97KUyJq5sLv7U9eVbsDLkeMR6IEa8dTQ6ldYu30uZj0fDdaCl5Kv2U9NJ6h
         cD5tcl6lHt8X8oY9YkC8hgDb11zXcFLpkv5102zAberJooMbEIjcilcIP4q5NwcnxD
         1OKWLy7HvwW8/Vihn366DAuNSBUK/x77xjCgI1RnPrFlcUyHfCdp9DMnpVJpaaPpCu
         hMGJOBosfF4RoThu+Jpp4ach/F5SZ/B/WMSUk1l2kvVTUzMkbRxNmEg5sXWEDxLu3k
         w+c7JjJl7x7Ce/D24Qrpr2Crf8wtkCj+zWwLHL/fwnBQZ/ltWDEm6F2UUZ/n+jSObj
         L15b8MtHHwhfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A09A2C395D8;
        Tue, 25 Apr 2023 02:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] net: phy: marvell: Fix inconsistent indenting in
 led_blink_set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168238861865.3463.3748388023689644289.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 02:10:18 +0000
References: <20230423172800.3470-1-ansuelsmth@gmail.com>
In-Reply-To: <20230423172800.3470-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 23 Apr 2023 19:28:00 +0200 you wrote:
> Fix inconsistent indeinting in m88e1318_led_blink_set reported by kernel
> test robot, probably done by the presence of an if condition dropped in
> later revision of the same code.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304240007.0VEX8QYG-lkp@intel.com/
> Fixes: 46969f66e928 ("net: phy: marvell: Implement led_blink_set()")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: marvell: Fix inconsistent indenting in led_blink_set
    https://git.kernel.org/netdev/net-next/c/4774ad841bef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


