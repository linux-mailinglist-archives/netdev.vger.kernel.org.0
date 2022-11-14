Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9319627C80
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbiKNLk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236253AbiKNLkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3539FDF10
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 03:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6817B80E6F
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 11:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64E66C433D7;
        Mon, 14 Nov 2022 11:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668426018;
        bh=CsQxr/Jri1JwXGRxgd7eDnQXiBIIkrgGtm1fYQiSMHY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j1OVWjEl4Y85B7jKiK8R+v1KF9xtpI3wcpdnKshEEQqPsKMYtqjNzpCFTYemevboY
         A9s4An1kEaUs+F94m5pkmmzDj8Konskg+3X33Zn1Fr7lsueKHWnxC7mtm+P6n4hXG2
         RXdo+uh190nLT/qplMBdz8Ku5uLj9H3oyKItdk7i94ym8X6zsylo41tYT+GD11LpEj
         ao3QZ5Rhhl8h+NG12ndtdWq4PtnWDmlcKMcpAhgyp2Wlpz0GFqY0624T4rHzcVI6rg
         1JC50XVAtNWxKdBvWQD/zviTUcKodmYKNOdMPS5Pxi/MRydF2s82lvSVyUw1IBDsjO
         ol6dbH3ZQceRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50707E4D021;
        Mon, 14 Nov 2022 11:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: Bridge,
 Use debug instead of warn if entry doesn't exists
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166842601832.5995.17704075534917151925.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 11:40:18 +0000
References: <20221112102147.496378-2-saeed@kernel.org>
In-Reply-To: <20221112102147.496378-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, roid@nvidia.com, vladbu@nvidia.com
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
by Saeed Mahameed <saeedm@nvidia.com>:

On Sat, 12 Nov 2022 02:21:33 -0800 you wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> There is no need for the warn if entry already removed.
> Use debug print like in the update flow.
> Also update the messages so user can identify if the it's
> from the update flow or remove flow.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: Bridge, Use debug instead of warn if entry doesn't exists
    https://git.kernel.org/netdev/net-next/c/ea645f97bcec
  - [net-next,02/15] net/mlx5: Fix spelling mistake "destoy" -> "destroy"
    https://git.kernel.org/netdev/net-next/c/d23b928befda
  - [net-next,03/15] net/mlx5: Unregister traps on driver unload flow
    https://git.kernel.org/netdev/net-next/c/71b75f0e02ed
  - [net-next,04/15] net/mlx5: Expose vhca_id to debugfs
    https://git.kernel.org/netdev/net-next/c/dd3dd7263cde
  - [net-next,05/15] net/mlx5e: remove unused list in arfs
    https://git.kernel.org/netdev/net-next/c/60551e95a864
  - [net-next,06/15] net/mlx5e: Use clamp operation instead of open coding it
    https://git.kernel.org/netdev/net-next/c/9458108040b3
  - [net-next,07/15] net/mlx5e: Support enhanced CQE compression
    https://git.kernel.org/netdev/net-next/c/2c925db0a7d6
  - [net-next,08/15] net/mlx5e: Move params kernel log print to probe function
    https://git.kernel.org/netdev/net-next/c/38438d39a9a0
  - [net-next,09/15] net/mlx5e: Add error flow when failing update_rx
    https://git.kernel.org/netdev/net-next/c/e74ae1faeb71
  - [net-next,10/15] net/mlx5e: TC, Remove redundant WARN_ON()
    https://git.kernel.org/netdev/net-next/c/989722906166
  - [net-next,11/15] net/mlx5e: kTLS, Remove unused work field
    https://git.kernel.org/netdev/net-next/c/1f74399fd1ed
  - [net-next,12/15] net/mlx5e: kTLS, Remove unnecessary per-callback completion
    https://git.kernel.org/netdev/net-next/c/4d78a2ebbd2b
  - [net-next,13/15] net/mlx5e: kTLS, Use a single async context object per a callback bulk
    https://git.kernel.org/netdev/net-next/c/341361533011
  - [net-next,14/15] net/mlx5e: CT, optimize pre_ct table lookup
    https://git.kernel.org/netdev/net-next/c/05bb74c29d84
  - [net-next,15/15] net/mlx5e: ethtool: get_link_ext_stats for PHY down events
    https://git.kernel.org/netdev/net-next/c/e07c4924a77d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


