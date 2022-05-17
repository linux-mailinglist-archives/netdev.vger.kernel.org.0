Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33BB5529E3B
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245004AbiEQJkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244953AbiEQJkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:40:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7B546162;
        Tue, 17 May 2022 02:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48F2361509;
        Tue, 17 May 2022 09:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97BF0C34113;
        Tue, 17 May 2022 09:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652780411;
        bh=3KCXnQfgxiOQmWBrN8ewdG+/4oTVgK59nL0Wa1nM4dc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QbAcTgoKLfFJUzwtSZywe8a7C4p6+alWJzRhk9X6us/QhbVuBlYM3dpwzy6VPhGIE
         SUbBSQRf35CHXwavybi065L/f6KJUaJ8LRgf+hG6X78vakuJVUMBt8Hegz5O6J/gKq
         Cg+Vm1ocVtU2pr/9d2/KB44xCIG+JHcy9m1xhY8gvCCkwVH/Ix7MxpkUGSrGegHu7D
         6WbA9waIGQZppCsxONGLFrL3va1FapKgvXsUNxW6e2yYRYnoq4FkzUY3A0DaWMhq7X
         sCWMIJ4fI/1QQJOeN0E4oX4dtv3bV1anCrajA1FekdrxqiyqpJqxxR/9LwFpr/z0zQ
         Z1SAlYD5oYypw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B58DF0383D;
        Tue, 17 May 2022 09:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlxbf_gige: use eth_zero_addr() to clear mac
 address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165278041150.25162.12476156103247790966.git-patchwork-notify@kernel.org>
Date:   Tue, 17 May 2022 09:40:11 +0000
References: <20220516033343.329178-1-luwei32@huawei.com>
In-Reply-To: <20220516033343.329178-1-luwei32@huawei.com>
To:     Lu Wei <luwei32@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, asmaa@nvidia.com, davthompson@nvidia.com,
        limings@nvidia.com, cai.huoqing@linux.dev, arnd@arndb.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 16 May 2022 11:33:43 +0800 you wrote:
> Use eth_zero_addr() to clear mac address instead of memset().
> 
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net/mlxbf_gige: use eth_zero_addr() to clear mac address
    https://git.kernel.org/netdev/net-next/c/bcdcf2c466d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


