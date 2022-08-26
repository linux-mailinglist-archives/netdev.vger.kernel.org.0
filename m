Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE5E5A2542
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 12:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344174AbiHZKAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 06:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343733AbiHZKAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 06:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1837D481C3;
        Fri, 26 Aug 2022 03:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3134A61E9D;
        Fri, 26 Aug 2022 10:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8CE97C4347C;
        Fri, 26 Aug 2022 10:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661508015;
        bh=4NbhDShSfbJVQ91PTmOJ09I/KVFHwBhoPvn6y1m70Hg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=olhdsS7EzcO/o1gl7NJ0mheY2oJFTEQq6w531ikxUDEyPH9RigHh/4vaRYJG89JBl
         TzIL1pHMIqcJldtC0pBUs+jO46z8dCtaEr14NmjIgJCiiiDLcmsffZaexedpozE80h
         D9FQXcL3cmYJ/T0gj+oSWV7j4n7d+yC4Lg4U3RBrBH1oh/a6g5SAf07q5gz7dwABrM
         XAoREJrGUnvORIvk1NUqA3rfAkgllU5/7hYWJUpyK1aegH/dsWVknv7dzz1VGoMBLg
         wFQQOwPz3bfV6dXu4ez2yKeTFsIvPPN8BQJMDBYcxniXFCoe4SwdkXsW6ozauHdyrh
         5WRgEjYwbtguw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6B17BE2A040;
        Fri, 26 Aug 2022 10:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: phylink: allow RGMII/RTBI in-band status
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166150801543.12913.17008280622819013369.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Aug 2022 10:00:15 +0000
References: <20220824061034.3922371-1-dqfext@gmail.com>
In-Reply-To: <20220824061034.3922371-1-dqfext@gmail.com>
To:     Qingfang DENG <dqfext@gmail.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, 24 Aug 2022 14:10:34 +0800 you wrote:
> As per RGMII specification v2.0, section 3.4.1, RGMII/RTBI has an
> optional in-band status feature where the PHY's link status, speed and
> duplex mode can be passed to the MAC.
> Allow RGMII/RTBI to use in-band status.
> 
> Signed-off-by: Qingfang DENG <dqfext@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: phylink: allow RGMII/RTBI in-band status
    https://git.kernel.org/netdev/net-next/c/d73ffc08824d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


