Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F89D6EA1DC
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbjDUCu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbjDUCuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EB83ABC
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 19:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74ACC64D3D
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE3E2C4339C;
        Fri, 21 Apr 2023 02:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682045419;
        bh=qD5QT6Br303O91w6IQ5DA2yUzxqfpCGQj+IN8vJzOlk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NjMVEh6P5Kr340lN9aV0Tz471bTbrVokOYN+zFtgtN5rUrxZ56lPUqE7Y60sJTMDl
         Rbao6N3/3eVNUbPPeVGp0rk7sH5zqWX19QeX6eHci9gEjBT84FPnLdADDRjLHD3Fae
         JI0AJ+zEEnKKFxvoBo1DTIcH5OVL/Gb0AxsWaMZWT3zM2vm5VaK+NCOiJlaPiLNlgp
         xgwyDCzJAP6iAULNMnVczyLT0VREpp3FJU1EaBELIM+W24ZfDpFwOGA7rCjHubyCCm
         gxgEg5Ae2I+6yNBylJaGzUuFsY9vPyB+r/1dJpXWIa9TESAwKxZP3gFIexdT8Fijvx
         6IIQuEk8/UB8A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6E7CE501E3;
        Fri, 21 Apr 2023 02:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] eth: mlx5: avoid iterator use outside of a loop
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168204541968.19656.13626148235311108426.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 02:50:19 +0000
References: <20230420015802.815362-1-kuba@kernel.org>
In-Reply-To: <20230420015802.815362-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com, leon@kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 19 Apr 2023 18:58:02 -0700 you wrote:
> Fix the following warning about risky iterator use:
> 
> drivers/net/ethernet/mellanox/mlx5/core/eq.c:1010 mlx5_comp_irq_get_affinity_mask() warn: iterator used outside loop: 'eq'
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v2:
>  - return NULL rather than 0
> v1: https://lore.kernel.org/all/20230416101753.GB15386@unreal/
> 
> [...]

Here is the summary with links:
  - [net-next] eth: mlx5: avoid iterator use outside of a loop
    https://git.kernel.org/netdev/net-next/c/61718206ee5d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


