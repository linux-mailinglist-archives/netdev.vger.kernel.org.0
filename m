Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345E05BD914
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiITBK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiITBKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:10:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBDF3F1D7;
        Mon, 19 Sep 2022 18:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B972661F99;
        Tue, 20 Sep 2022 01:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12555C43147;
        Tue, 20 Sep 2022 01:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636221;
        bh=6XGxtmrAPn7Aky52egClSyQbD89JCnR4nCdm5+k5F/4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sM1ly5qLb58JfEDS/xLa06DcpzYp05Skv9tfsmqIs2vV9eOm57GN39iYiVf9UtSwt
         zVDea+G1pZskQSF8509KUIG+R+CQ/rh/kyWIqz0cA16FbltuUEuEQarZMGgA3FJnuX
         AHGgjxnDBymEmTHcaE5qm1m1vIs+SlkvJC5l8wWL6bl9UlKjHlk+5zRoZ2zXApvgnQ
         wWhQWlDeNW9BcFOuZVgUupIj1ckEp8InA8SyLXh2cdsLqq9cV3d8C1vIIWgKlaEcSt
         Eogkw1jn9qWvuTmJ6AmGcFS9DEagAvwlfMX4mw+2Nx01yr8vKbgQBRraRhTvea8EU4
         wVYNV+v9z1EDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ED30FE52535;
        Tue, 20 Sep 2022 01:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v2 1/2] net/mlx5e: add missing error code in error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363622096.23429.14049621125025586020.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:10:20 +0000
References: <20220914140100.3795545-1-yangyingliang@huawei.com>
In-Reply-To: <20220914140100.3795545-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        saeedm@nvidia.com, liorna@nvidia.com, raeds@nvidia.com,
        davem@davemloft.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Sep 2022 22:00:59 +0800 you wrote:
> Add missing error code when mlx5e_macsec_fs_add_rule() or
> mlx5e_macsec_fs_init() fails. mlx5e_macsec_fs_init() don't
> return ERR_PTR(), so replace IS_ERR_OR_NULL() check with
> NULL pointer check.
> 
> Fixes: e467b283ffd5 ("net/mlx5e: Add MACsec TX steering rules")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next,v2,1/2] net/mlx5e: add missing error code in error path
    https://git.kernel.org/netdev/net-next/c/46ff47bc81b4
  - [-next,v2,2/2] net/mlx5e: Switch to kmemdup() when allocate dev_addr
    https://git.kernel.org/netdev/net-next/c/13c76227cd8a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


