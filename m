Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F23698BFA
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 06:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjBPFaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 00:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjBPFaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 00:30:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E71C3A89;
        Wed, 15 Feb 2023 21:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0ADB61E90;
        Thu, 16 Feb 2023 05:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D023C433A1;
        Thu, 16 Feb 2023 05:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676525419;
        bh=xzLvVfruIJbJT9woMw5dDxFNpZ6lxwEO9gPlweIEkyM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X7VKndTzQr6njoCl0qfjgE/go685s4fxuGpQdmcadhqcYL5BZSSta/llVLlc9t9y5
         4w1OaL/kU2xIwVsG7xtrM8JHUrCNMXNTiEs4wpqsHYz0MysLq1W91Ko8Q8r8s14fgG
         lWfwI9zh92PDJotEVrRWa4YuCcKr2RQzJKgecQZSuKM0/DMM2Sk3wD4EQ3Y33kootJ
         WEJBKC5T6KRvAXbHpzV7Pfe2WzcfkwAOr0wOBn9cLs0/HW7CyRazREGq/+SPKFG8Ah
         zD9+2d04qsEzjSNkY+5cHYf1wMQDrhdsfCZyLqqbOOc9fyAzZQZBp/cCFpEN0NoXjd
         d0DLcPTyDa0JA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3CF0E21EC4;
        Thu, 16 Feb 2023 05:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: phy: c45: genphy_c45_an_config_aneg():
 fix uninitialized symbol error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167652541899.5481.5030550372807599560.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 05:30:18 +0000
References: <20230215050453.2251360-1-o.rempel@pengutronix.de>
In-Reply-To: <20230215050453.2251360-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lkp@intel.com, error27@gmail.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Feb 2023 06:04:53 +0100 you wrote:
> Fix warning:
> drivers/net/phy/phy-c45.c:712 genphy_c45_write_eee_adv() error: uninitialized symbol 'changed'
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://lore.kernel.org/r/202302150232.q6idsV8s-lkp@intel.com/
> Fixes: 022c3f87f88e ("net: phy: add genphy_c45_ethtool_get/set_eee() support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/1] net: phy: c45: genphy_c45_an_config_aneg(): fix uninitialized symbol error
    https://git.kernel.org/netdev/net-next/c/c24a34f5a3d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


