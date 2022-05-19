Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5323552CB5D
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 07:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbiESFAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 01:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiESFAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 01:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2990A87237;
        Wed, 18 May 2022 22:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1063619E8;
        Thu, 19 May 2022 05:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EBC7C34100;
        Thu, 19 May 2022 05:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652936413;
        bh=Pbtbk8f+v9AhJJnJtf9V5WCcRYrvYNN0Udab0dZoJa0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rITO9CXvulY++tqn95P0Xzft7Ew72Ptr35ByEFDqFOwesYt/gQrQvI9Jnm5/COCPc
         JZ2gvSXr3JLaIg2xZTroVl5P1B+E/smbij4p47Es109zY1DqA7uqEzhH93EUBgbUpS
         wPNaJU7rdzn0GrVcYiyaIXazANouxD5JXvxcu2wpVKGbN5Aqs93WWwOVe59sMrknvQ
         X0fI81NrgQS+ZPDeKP0HpEiHi2ry5IfJOowFpPoHhOc0W2ejLlOuN37ZlaRwUIsaRB
         IeiUvz685vQAgxHeEzUOXT24nZWvx/gg1dGUa7cGC+Quhg47vYybU1lXjL6gIypja8
         SaYfhLAVo5Bdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E45D9E8DBDA;
        Thu, 19 May 2022 05:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5: fix multiple definitions of
 mlx5_lag_mpesw_init / mlx5_lag_mpesw_cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165293641293.23747.10441028556274960802.git-patchwork-notify@kernel.org>
Date:   Thu, 19 May 2022 05:00:12 +0000
References: <20220518183022.2034373-1-kuba@kernel.org>
In-Reply-To: <20220518183022.2034373-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com, leon@kernel.org,
        elic@nvidia.com, mbloch@nvidia.com, linux-rdma@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 18 May 2022 11:30:22 -0700 you wrote:
> static inline is needed in the header.
> 
> Fixes: 94db33177819 ("net/mlx5: Support multiport eswitch mode")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: saeedm@nvidia.com
> CC: leon@kernel.org
> CC: elic@nvidia.com
> CC: mbloch@nvidia.com
> CC: linux-rdma@vger.kernel.org
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5: fix multiple definitions of mlx5_lag_mpesw_init / mlx5_lag_mpesw_cleanup
    https://git.kernel.org/netdev/net-next/c/d935053a62fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


