Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B32D6957B6
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 05:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjBNEKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 23:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjBNEKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 23:10:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8CE17CE4;
        Mon, 13 Feb 2023 20:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D49F6141D;
        Tue, 14 Feb 2023 04:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0025C433A1;
        Tue, 14 Feb 2023 04:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676347818;
        bh=l5urqEWQHpOITR8ixDdP9tDjrYNRGD55/CpQXcmjeGs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i04yit0z5Qs5tVDt7scN5kf/zZUPda44zBWeJ4dKievXtnL9RGuslSGOjSTPg0zwO
         MXU9dPSOxmXU1HnsiPHAlye2fuXYRTqGzHvgG12MzQOc4iavshMIXM8IY4zybDU8Zf
         cZhp/XRD2eK/KYgb7qv3SCb/y46FiO0d3oNpbfvDucP4TMAMDDAy/Fnmzs6PXCYwQU
         W00q8eBgwHq7d2kREecdUSLV+LXIyooSanvxQfG9GrilK4JcFSIOZxTWYLuIYBuLm0
         8hZgE27MtzZENFnG/4rjCmVJddKAWrTVucc3zyJDcKpmaGomgGa0bjI5K3vNoHTeok
         1hGpyIolmgD6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A72D5E45098;
        Tue, 14 Feb 2023 04:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: add missing NETDEV_XDP_ACT_XSK_ZEROCOPY
 bit to xdp_features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167634781867.18399.2460870854781740245.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Feb 2023 04:10:18 +0000
References: <c8949baafdf617188dcedb9033ce5a9ca6e9e5ff.1676195440.git.lorenzo@kernel.org>
In-Reply-To: <c8949baafdf617188dcedb9033ce5a9ca6e9e5ff.1676195440.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, lorenzo.bianconi@redhat.com,
        bpf@vger.kernel.org
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

On Sun, 12 Feb 2023 10:54:43 +0100 you wrote:
> Add missing xsk zero-copy bit to xdp_features capability flag.
> 
> Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net-next] net: stmmac: add missing NETDEV_XDP_ACT_XSK_ZEROCOPY bit to xdp_features
    https://git.kernel.org/netdev/net-next/c/c758fedf0802

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


