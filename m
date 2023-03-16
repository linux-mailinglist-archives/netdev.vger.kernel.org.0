Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EA06BC556
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCPElB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPEk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:40:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DCB1CBE2;
        Wed, 15 Mar 2023 21:40:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A92661EFB;
        Thu, 16 Mar 2023 04:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2169C433EF;
        Thu, 16 Mar 2023 04:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678941617;
        bh=D+k+ZFHEAw7xSJH2jLtU1BquXfnEXsP15ln59Y7vWYw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lh5UxjIJUaSEz/bqe/+HHsaO/hNQTqpIht3+l18z0bKwP/ZloWQX8omRAqrIfmkol
         Pg7bdSlQw7J2yY01r/p6FXlUV2TbVaEyy2u1cgMR+G/KsJLKECezUjW8PAPM12h8YE
         Bo36Vssv7On7pjYv+JzgCll7UasAqdlcgzH25mdcWipnBOwCUiiaLb9ojhZQ166PZH
         w9skD/LD1+X1+v6aMSijYujMV1EEL1c/Y5i3U5iEGenBbssvoReQRd5obsDrmHlE51
         5wNI7MqhToNwRMK3L/XQzUtc/nF3f3OpG0YIQa9emGgR6Y/3KslfYWoMnRS/Dy48UG
         TgxbydySeaKZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9358AE66CBF;
        Thu, 16 Mar 2023 04:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: mscc: fix deadlock in
 phy_ethtool_{get,set}_wol()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167894161760.2389.13225258059136604829.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 04:40:17 +0000
References: <20230314153025.2372970-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230314153025.2372970-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Mar 2023 17:30:25 +0200 you wrote:
> Since the blamed commit, phy_ethtool_get_wol() and phy_ethtool_set_wol()
> acquire phydev->lock, but the mscc phy driver implementations,
> vsc85xx_wol_get() and vsc85xx_wol_set(), acquire the same lock as well,
> resulting in a deadlock.
> 
> $ ip link set swp3 down
> ============================================
> WARNING: possible recursive locking detected
> mscc_felix 0000:00:00.5 swp3: Link is Down
> 
> [...]

Here is the summary with links:
  - [net] net: phy: mscc: fix deadlock in phy_ethtool_{get,set}_wol()
    https://git.kernel.org/netdev/net/c/cd356010ce4c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


