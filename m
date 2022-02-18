Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A597B4BB10A
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 06:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiBRFAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 00:00:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiBRFAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 00:00:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C232BAA0D;
        Thu, 17 Feb 2022 21:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05F0AB82583;
        Fri, 18 Feb 2022 05:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50476C340FA;
        Fri, 18 Feb 2022 05:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645160412;
        bh=Tjd6KAEJe125Y5LNoDcCFkRn6cC8snye/z4XPK+sb5I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=neTrGpPB66lfHxTOkBCgVcayL7+lAZAGiuT2q2ASnsfS+G2wlgmdE113bPc1yP572
         jZqo6jSolzvlGFrrLa3tpinHYXMmlV2H1dr0cu/ptP4oQZxoUU4ht0DT4DmnqmG+yl
         Sgx5O/dy9sQxQbkhEEzoox4DJys1botLJKEhghU18iDPCDm4jRbjZ9mWw59EjB0e2k
         wDkBRwZEojPInPEZic0PGZ5l1+tiZEuXEP0BqF7pkgACd41shQpJxap1i3ee2x+FSj
         ExHwIrk6a3aOvXofQ2Z9Wz55GCjqAN1P06x1J+yPka5Hk5kbYycYqY1Yi2XHfdb/OR
         mUrVihboCmPDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 31746E6BBD2;
        Fri, 18 Feb 2022 05:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ll_temac: Use GFP_KERNEL instead of GFP_ATOMIC when
 possible
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164516041219.28752.17567769381515627753.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 05:00:12 +0000
References: <694abd65418b2b3974106a82d758e3474c65ae8f.1645042560.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <694abd65418b2b3974106a82d758e3474c65ae8f.1645042560.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Feb 2022 21:16:16 +0100 you wrote:
> XTE_MAX_JUMBO_FRAME_SIZE is over 9000 bytes and the default value for
> 'rx_bd_num' is RX_BD_NUM_DEFAULT	(i.e. 1024)
> 
> So this loop allocates more than 9 Mo of memory.
> 
> Previous memory allocations in this function already use GFP_KERNEL, so
> use __netdev_alloc_skb_ip_align() and an explicit GFP_KERNEL instead of a
> implicit GFP_ATOMIC.
> 
> [...]

Here is the summary with links:
  - net: ll_temac: Use GFP_KERNEL instead of GFP_ATOMIC when possible
    https://git.kernel.org/netdev/net-next/c/60f8ad2392d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


