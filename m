Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0701F66571B
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238033AbjAKJOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjAKJOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:14:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8911A9FF9
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44303B819CA
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB9F4C433D2;
        Wed, 11 Jan 2023 09:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673428218;
        bh=VKVKUc8OvhYusR1pL8vF+zsliLMFSB73Xgk3fafv4Qw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ATapIGXvF3fpfoGgbV449jbl6euIMsi0RaPq9nsWpXJfG3JVyxqs0qKvxXJwfq7yQ
         RWzEo/DXa1aPr9BD8xuR/KsFhHE+D2wKvlnv1UOfjkyybVYBK8ObEmtLU9g4jbOfVz
         SeUjzu6XkENFojudFUnjHKCXmh5KDy4CrBxWh6i+3KC4WrkY/vjTkmSxDL0a3fdTvS
         C1ooKqUrY1abF9M17qlUTZbvf+PvEz5qgCuzpthkvlwAOOyGYvBkraFF+o7hL8VZ0N
         x0SNMSaFi6JOszq2fULYgcFTFlG0GppdL9Nu4IRdUpSmA0heLcREnCCWo7c3bHBHr+
         wRIketOTqIkfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C48FBE4D026;
        Wed, 11 Jan 2023 09:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: Expose shared buffer registers bits and
 structs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167342821880.24876.17700227284052199682.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Jan 2023 09:10:18 +0000
References: <20230111053045.413133-2-saeed@kernel.org>
In-Reply-To: <20230111053045.413133-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, msanalla@nvidia.com, moshe@nvidia.com
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

On Tue, 10 Jan 2023 21:30:31 -0800 you wrote:
> From: Maher Sanalla <msanalla@nvidia.com>
> 
> Add the shared receive buffer management and configuration registers:
> 1. SBPR - Shared Buffer Pools Register
> 2. SBCM - Shared Buffer Class Management Register
> 
> Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: Expose shared buffer registers bits and structs
    https://git.kernel.org/netdev/net-next/c/8d231dbc3b10
  - [net-next,02/15] net/mlx5e: Add API to query/modify SBPR and SBCM registers
    https://git.kernel.org/netdev/net-next/c/11f0996d5c60
  - [net-next,03/15] net/mlx5e: Update shared buffer along with device buffer changes
    https://git.kernel.org/netdev/net-next/c/a440030d8946
  - [net-next,04/15] net/mlx5e: Add Ethernet driver debugfs
    https://git.kernel.org/netdev/net-next/c/288eca60cc31
  - [net-next,05/15] net/mlx5e: kTLS, Add debugfs
    https://git.kernel.org/netdev/net-next/c/0fedee1ae9ef
  - [net-next,06/15] net/mlx5e: Add hairpin params structure
    https://git.kernel.org/netdev/net-next/c/1a8034720f38
  - [net-next,07/15] net/mlx5e: Add flow steering debugfs directory
    https://git.kernel.org/netdev/net-next/c/3a3da78dd258
  - [net-next,08/15] net/mlx5e: Add hairpin debugfs files
    https://git.kernel.org/netdev/net-next/c/0e414518d6d8
  - [net-next,09/15] net/mlx5: Enable management PF initialization
    https://git.kernel.org/netdev/net-next/c/fe998a3c77b9
  - [net-next,10/15] net/mlx5: Introduce and use opcode getter in command interface
    https://git.kernel.org/netdev/net-next/c/7cb5eb937231
  - [net-next,11/15] net/mlx5: Prevent high-rate FW commands from populating all slots
    https://git.kernel.org/netdev/net-next/c/63fbae0a74c3
  - [net-next,12/15] net/mlx5e: Replace zero-length array with flexible-array member
    https://git.kernel.org/netdev/net-next/c/7193b436b56e
  - [net-next,13/15] net/mlx5e: Replace 0-length array with flexible array
    https://git.kernel.org/netdev/net-next/c/7bd1099c7ede
  - [net-next,14/15] net/mlx5: remove redundant ret variable
    https://git.kernel.org/netdev/net-next/c/4238654ce166
  - [net-next,15/15] net/mlx5e: Use kzalloc() in mlx5e_accel_fs_tcp_create()
    https://git.kernel.org/netdev/net-next/c/96c31b5b2cae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


