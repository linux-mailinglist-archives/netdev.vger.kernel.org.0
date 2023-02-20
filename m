Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B197169C8F6
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjBTKuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjBTKuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5FC12F10;
        Mon, 20 Feb 2023 02:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2C2D60DC7;
        Mon, 20 Feb 2023 10:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17D68C4339B;
        Mon, 20 Feb 2023 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676890217;
        bh=fkQbAKKymO1hnUL7oa3t7jMpjAeyD2McsOLZehibJzs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sM1vb5djjXc3U2oOHcZoUYA+hTJuKQQK+1whVY7lBO1SdCiVyabpqH7/JEfvZRDoT
         6ypgMrBwGflZph07rzLgBzUTFEHeXx8j7I9JcqGr/B7krjuw1XYsm3UQzqKHJYuYJx
         1odNxhuGIfqpLCZCzadlgmug9NmexdrtHXeUXkU/mEM3Fj+SEu2qn26Egakk5btqGg
         L1VhTHSJIReSX42yudba1L0ZhKzhHZcmcPFgL1DSyVRlz400njSkbzkmFohj1dLjjm
         g/eK8vKUVs8GZ7A65S/QTh/tb6JAbk5T7czfqCfPgEWr6kJhwqQCRh/qMZCvH+ICev
         KXbN24XqcWD/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EFF33E68D23;
        Mon, 20 Feb 2023 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sfc: use IS_ENABLED() checks for CONFIG_SFC_SRIOV
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167689021698.13054.16514815510769961812.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 10:50:16 +0000
References: <20230217095650.2305559-1-arnd@kernel.org>
In-Reply-To: <20230217095650.2305559-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alejandro.lucero-palau@amd.com, arnd@arndb.de,
        jonathan.s.cooper@amd.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Feb 2023 10:56:39 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> One local variable has become unused after a recent change:
> 
> drivers/net/ethernet/sfc/ef100_nic.c: In function 'ef100_probe_netdev_pf':
> drivers/net/ethernet/sfc/ef100_nic.c:1155:21: error: unused variable 'net_dev' [-Werror=unused-variable]
>   struct net_device *net_dev = efx->net_dev;
>                      ^~~~~~~
> 
> [...]

Here is the summary with links:
  - sfc: use IS_ENABLED() checks for CONFIG_SFC_SRIOV
    https://git.kernel.org/netdev/net-next/c/a59f832a71c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


