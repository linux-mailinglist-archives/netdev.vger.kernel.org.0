Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A46519C96
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 12:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347772AbiEDKOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 06:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347921AbiEDKNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 06:13:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBE4E0A
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 03:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95363B824A6
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 10:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40873C385A5;
        Wed,  4 May 2022 10:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651659014;
        bh=P7icVoI0ovbcgbdfVwSDGfZtU4dKFaFv3+9HbGR01cM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K4f0pfOUK8pWEF0JeXjOyT3nfOdJ4hxAaeFKKgsp+ouHYoEsiaK5ptRM8iV51fSMA
         MjW34WsXA9jPtwD9GY4cXGvLcqId9/2Rnu4hlNByC3otULI2UW1VfK9sRQyhj2jwrG
         ItDLtcR7WwD/ttzm7d/RyJGqYHCTWAsqFpuuxQcEAQiweseqOUn5GVw1Kr9Y4w02W6
         zSIgvmjzlXEmyHSHKXeJy7+QDclIxYXUFh1cpKUtiawvt/TxH55g50O6tW6e3u7wNl
         VyGJNZPORutHILL3zHsCKQ9SWV8MBmlK58uvvtKjZJMBu0jNT6nVG7gDXVwbE4pDvz
         KCnvqu0dPX8DQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22902E5D087;
        Wed,  4 May 2022 10:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/15] net/mlx5e: Fix wrong source vport matching on tunnel rule
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165165901413.16679.17484307707741961429.git-patchwork-notify@kernel.org>
Date:   Wed, 04 May 2022 10:10:14 +0000
References: <20220504070256.694458-2-saeedm@nvidia.com>
In-Reply-To: <20220504070256.694458-2-saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, lariel@nvidia.com, maord@nvidia.com
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

This series was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Wed,  4 May 2022 00:02:42 -0700 you wrote:
> From: Ariel Levkovich <lariel@nvidia.com>
> 
> When OVS internal port is the vtep device, the first decap
> rule is matching on the internal port's vport metadata value
> and then changes the metadata to be the uplink's value.
> 
> Therefore, following rules on the tunnel, in chain > 0, should
> avoid matching on internal port metadata and use the uplink
> vport metadata instead.
> 
> [...]

Here is the summary with links:
  - [net,01/15] net/mlx5e: Fix wrong source vport matching on tunnel rule
    https://git.kernel.org/netdev/net/c/cb0d54cbf948
  - [net,02/15] net/mlx5: Fix slab-out-of-bounds while reading resource dump menu
    https://git.kernel.org/netdev/net/c/7ba2d9d8de96
  - [net,03/15] net/mlx5e: Don't match double-vlan packets if cvlan is not set
    https://git.kernel.org/netdev/net/c/ada09af92e62
  - [net,04/15] net/mlx5e: Fix the calling of update_buffer_lossy() API
    https://git.kernel.org/netdev/net/c/c4d963a588a6
  - [net,05/15] net/mlx5e: Lag, Fix use-after-free in fib event handler
    https://git.kernel.org/netdev/net/c/27b0420fd959
  - [net,06/15] net/mlx5e: Lag, Fix fib_info pointer assignment
    https://git.kernel.org/netdev/net/c/a6589155ec98
  - [net,07/15] net/mlx5e: Lag, Don't skip fib events on current dst
    https://git.kernel.org/netdev/net/c/4a2a664ed879
  - [net,08/15] net/mlx5e: TC, Fix ct_clear overwriting ct action metadata
    https://git.kernel.org/netdev/net/c/087032ee7021
  - [net,09/15] net/mlx5e: TC, fix decap fallback to uplink when int port not supported
    https://git.kernel.org/netdev/net/c/e3fdc71bcb6f
  - [net,10/15] net/mlx5e: CT: Fix queued up restore put() executing after relevant ft release
    https://git.kernel.org/netdev/net/c/b069e14fff46
  - [net,11/15] net/mlx5e: Avoid checking offload capability in post_parse action
    https://git.kernel.org/netdev/net/c/0e322efd64d2
  - [net,12/15] net/mlx5e: Fix trust state reset in reload
    https://git.kernel.org/netdev/net/c/b781bff882d1
  - [net,13/15] net/mlx5: Fix deadlock in sync reset flow
    https://git.kernel.org/netdev/net/c/cb7786a76ea3
  - [net,14/15] net/mlx5: Avoid double clear or set of sync reset requested
    https://git.kernel.org/netdev/net/c/fc3d3db07b35
  - [net,15/15] net/mlx5: Fix matching on inner TTC
    https://git.kernel.org/netdev/net/c/a042d7f5bb68

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


