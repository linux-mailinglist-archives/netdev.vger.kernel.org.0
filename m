Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE477524147
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 02:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349510AbiELAAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 20:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiELAAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 20:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89F16212C
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F44561DE3
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95745C34118;
        Thu, 12 May 2022 00:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652313614;
        bh=s9jj9+rvL3NVCd6HtgfbQPe8qb+wHQD/jEuDDDDE9Mg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FNP2gPwRuyjSncMUJS/BzovuQ9bPO4iZsUEs9g+JBtPOjMUGzUKEMVyLIgp3GflID
         96WoYBvm5oajLfArFEGp3gKOEFrRZEvIyQK3lqzYRKGp7jLfkTue9NU06/6Mf9Hs8L
         xv8uxMBGswJ75qRnlz+OgocRH6g98mbNkJ/EASBmJMJMW9tNXpELTWzS9bksQUyPaL
         lbGrRIgcx5xKpaJDxRVJKZKqT5cvOoo9pvePdUQWMMc9Vy++rq/GDmlJs45E4kVmVj
         DX9/tDHC64u+xzQOx6h93w8MEYJBEaNe7nL1et8xT63wBdy+AoQ9u5sHxg+2wegQwl
         v4MxXpaX/Gccg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71FB4F03935;
        Thu, 12 May 2022 00:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Count tc-taprio window drops in enetc driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165231361446.20088.3369016197334449834.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 00:00:14 +0000
References: <20220510163615.6096-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220510163615.6096-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, claudiu.manoil@nxp.com,
        vinicius.gomes@intel.com, michael@walle.cc,
        xiaoliang.yang_1@nxp.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 10 May 2022 19:36:13 +0300 you wrote:
> This series includes a patch from Po Liu (no longer with NXP) which
> counts frames dropped by the tc-taprio offload in ethtool -S and in
> ndo_get_stats64. It also contains a preparation patch from myself.
> 
> Po Liu (1):
>   net: enetc: count the tc-taprio window drops
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: enetc: manage ENETC_F_QBV in priv->active_offloads only when enabled
    https://git.kernel.org/netdev/net-next/c/32bf8e1f6fb9
  - [net-next,2/2] net: enetc: count the tc-taprio window drops
    https://git.kernel.org/netdev/net-next/c/285e8dedb4bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


