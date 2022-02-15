Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA3E4B69BA
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 11:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbiBOKuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 05:50:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236712AbiBOKuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 05:50:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C720FD226A
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 02:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7289BB81894
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 10:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3EC9FC340F1;
        Tue, 15 Feb 2022 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644922212;
        bh=0CgmcEROgDgs9jG7cQ2fI6d3QUAf5+LfRFP88lTzX8k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ds9dQHlkTt/1r78BVI4xi7usezapR3ex8YGOOzx95Y7w5Vdzjggtr1PMUPdpf/V5x
         spJEAb8GSWjdQOxhysTXt+kevVRGNAyB/mWfqm1Kye5vaCT0fM1o8iZdbsUC+zWM/z
         ia01+2XXJUCihLMt8LC9HHqqlmW/oaX5n+z/nQlPjA2EuXhWuzqSpMbftXaZSINGOZ
         hUGvvgSqkPyEJCRprtTjW7lviPwyHnVnl0ptP6S9J/mUSNuCggAzMC6zl8r54tuqH3
         9ULT7VHUV7PK//gTwmzVDBNO3vf8UfYoAhXUCP3kJKHxPpIVq5whN2tZQZgqpclJHe
         Cxklj4RUTRdfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 27C05E5D07D;
        Tue, 15 Feb 2022 10:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5e: Remove unused tstamp SQ field
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164492221215.12084.15190713396104689323.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 10:50:12 +0000
References: <20220215063229.737960-2-saeed@kernel.org>
In-Reply-To: <20220215063229.737960-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, ayal@nvidia.com, saeedm@nvidia.com
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

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Mon, 14 Feb 2022 22:32:15 -0800 you wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> Remove tstamp pointer in mlx5e_txqsq as it's no longer used after
> commit 7c39afb394c7 ("net/mlx5: PTP code migration to driver core section").
> 
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Aya Levin <ayal@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: Remove unused tstamp SQ field
    https://git.kernel.org/netdev/net-next/c/9536923d3f35
  - [net-next,02/15] net/mlx5e: Read max WQEBBs on the SQ from firmware
    https://git.kernel.org/netdev/net-next/c/c27bd1718c06
  - [net-next,03/15] net/mlx5e: Use FW limitation for max MPW WQEBBs
    https://git.kernel.org/netdev/net-next/c/76c31e5f7585
  - [net-next,04/15] net/mlx5e: Cleanup of start/stop all queues
    https://git.kernel.org/netdev/net-next/c/befa41771f9e
  - [net-next,05/15] net/mlx5e: Disable TX queues before registering the netdev
    https://git.kernel.org/netdev/net-next/c/d08c6e2a4d03
  - [net-next,06/15] net/mlx5e: Use a barrier after updating txq2sq
    https://git.kernel.org/netdev/net-next/c/6ce204eac387
  - [net-next,07/15] net/mlx5e: Sync txq2sq updates with mlx5e_xmit for HTB queues
    https://git.kernel.org/netdev/net-next/c/17c84cb46e33
  - [net-next,08/15] net/mlx5e: Introduce select queue parameters
    https://git.kernel.org/netdev/net-next/c/8bf30be75069
  - [net-next,09/15] net/mlx5e: Move mlx5e_select_queue to en/selq.c
    https://git.kernel.org/netdev/net-next/c/6b23f6ab86a4
  - [net-next,10/15] net/mlx5e: Use select queue parameters to sync with control flow
    https://git.kernel.org/netdev/net-next/c/3ab45777a27c
  - [net-next,11/15] net/mlx5e: Move repeating code that gets TC prio into a function
    https://git.kernel.org/netdev/net-next/c/62f7991feab6
  - [net-next,12/15] net/mlx5e: Use READ_ONCE/WRITE_ONCE for DCBX trust state
    https://git.kernel.org/netdev/net-next/c/ed5f9cf06b20
  - [net-next,13/15] net/mlx5e: Optimize mlx5e_select_queue
    https://git.kernel.org/netdev/net-next/c/3c87aedd4899
  - [net-next,14/15] net/mlx5e: Optimize modulo in mlx5e_select_queue
    https://git.kernel.org/netdev/net-next/c/3a9e5fff2ab0
  - [net-next,15/15] net/mlx5e: Optimize the common case condition in mlx5e_select_queue
    https://git.kernel.org/netdev/net-next/c/71753b8ec103

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


