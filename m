Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F112685F46
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjBAFv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjBAFvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:51:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0457A234C0
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 21:50:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8217D61169
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D462CC4339C;
        Wed,  1 Feb 2023 05:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675230619;
        bh=dMK1M5XEzFUhnnfksoBoooXMNhZLkobXqrZWemZWNyA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BgM3U49eOnVMDzn6KcF/wXg4xGeROuQS0Imhu1/qhExTq3R3bh7GM1veuEBgSYSzv
         pDFFJR/sHHWxeZ7jUKsXvJxzjai2hSsWBZ2sHJ91x4h/S0nEBL9glYf6ECZEBl/lgs
         utmbsMtYdlmgX8NoiyN9C6YHfxxhQ8Zyx4uBIrTY6rV7QxwwcFjlFrgnO/nI/yq40r
         F0rpwlU6BL3WmcgebOMtTK9Ks47e/Kay9lU2ERBFxvbgjGpmFZjMH1q0ZevF7V5jMT
         KKjeHLMSsc1sJhw74PlTRZX4jeUzu40oUt0vBXNJ+a5r5oyiNIyGmWhzsX4wooGjEx
         /bvj4uNC1fLcg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B5F0CE501F1;
        Wed,  1 Feb 2023 05:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: Header file for crypto
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167523061973.13377.16820698331348375211.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 05:50:19 +0000
References: <20230131031201.35336-2-saeed@kernel.org>
In-Reply-To: <20230131031201.35336-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, jianbol@nvidia.com
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

On Mon, 30 Jan 2023 19:11:47 -0800 you wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> Take crypto API out of the generic mlx5.h header into a dedicated
> header.
> 
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: Header file for crypto
    https://git.kernel.org/netdev/net-next/c/c673b6772abc
  - [net-next,02/15] net/mlx5: Add IFC bits for general obj create param
    https://git.kernel.org/netdev/net-next/c/4744c7ad2299
  - [net-next,03/15] net/mlx5: Add IFC bits and enums for crypto key
    https://git.kernel.org/netdev/net-next/c/9a0ed4f2bfe2
  - [net-next,04/15] net/mlx5: Change key type to key purpose
    https://git.kernel.org/netdev/net-next/c/60c8972d2ccc
  - [net-next,05/15] net/mlx5: Prepare for fast crypto key update if hardware supports it
    https://git.kernel.org/netdev/net-next/c/fe298bdf6f65
  - [net-next,06/15] net/mlx5: Add const to the key pointer of encryption key creation
    https://git.kernel.org/netdev/net-next/c/55f0d6d20061
  - [net-next,07/15] net/mlx5: Refactor the encryption key creation
    https://git.kernel.org/netdev/net-next/c/942192541675
  - [net-next,08/15] net/mlx5: Add new APIs for fast update encryption key
    https://git.kernel.org/netdev/net-next/c/204369e718e9
  - [net-next,09/15] net/mlx5: Add support SYNC_CRYPTO command
    https://git.kernel.org/netdev/net-next/c/7a5b72c2a8e4
  - [net-next,10/15] net/mlx5: Add bulk allocation and modify_dek operation
    https://git.kernel.org/netdev/net-next/c/4d570c7117dd
  - [net-next,11/15] net/mlx5: Use bulk allocation for fast update encryption key
    https://git.kernel.org/netdev/net-next/c/c6e7d8171045
  - [net-next,12/15] net/mlx5: Reuse DEKs after executing SYNC_CRYPTO command
    https://git.kernel.org/netdev/net-next/c/709f07fe1a59
  - [net-next,13/15] net/mlx5: Add async garbage collector for DEK bulk
    https://git.kernel.org/netdev/net-next/c/12a9e1b73db0
  - [net-next,14/15] net/mlx5: Keep only one bulk of full available DEKs
    https://git.kernel.org/netdev/net-next/c/8a6fa6df61ff
  - [net-next,15/15] net/mlx5e: kTLS, Improve connection rate by using fast update encryption key
    https://git.kernel.org/netdev/net-next/c/f741db1a5171

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


