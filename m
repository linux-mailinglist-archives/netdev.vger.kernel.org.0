Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDDF545B94
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 07:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345975AbiFJFUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 01:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345615AbiFJFUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 01:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA883B021;
        Thu,  9 Jun 2022 22:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1CCBB8311D;
        Fri, 10 Jun 2022 05:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74E3AC3411C;
        Fri, 10 Jun 2022 05:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654838414;
        bh=DurdnlAAMqFaYaBBGXevS8TYgbJ+7qLdTEzauXAvU8Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HfdB+/G7hvObLFPBkF/2aAJ1Jpb0X8fA7PnuLzcpB2b4ijK/Fdircx+YgWg0tTp/4
         NduyVjRgd0DkcmCuXxDWxUrtdw54+Rg+UrT7gBX9heiSB8N7JcRZsuVG5PBiMrHSnv
         bLdW3BqIB6raddFg8kmQTxbEL2C9qm43aee8bAXQYUxz3S1aUdxdY39f+dyHay5lfD
         kZ0id9ha2lGOB9vadB9fLxdFynUv2hS1wn+3UQ0fOeTpCakcVby0hY1p+UlxiBqdES
         bfya9WrMFZnybqXQ+WBhfAf9qtbUfxiBvHXyOdro6WmfBgNSEOWMMuFRGW3AAmBQc4
         ijhDXKdNoQMiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58345E737EE;
        Fri, 10 Jun 2022 05:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: adjust MELLANOX ETHERNET INNOVA DRIVERS to TLS
 support removal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165483841435.4442.11942577289291510346.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Jun 2022 05:20:14 +0000
References: <20220601045738.19608-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20220601045738.19608-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     leonro@nvidia.com, borisp@nvidia.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Wed,  1 Jun 2022 06:57:38 +0200 you wrote:
> Commit 40379a0084c2 ("net/mlx5_fpga: Drop INNOVA TLS support") removes all
> files in the directory drivers/net/ethernet/mellanox/mlx5/core/accel/, but
> misses to adjust its reference in MAINTAINERS.
> 
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> broken reference.
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: adjust MELLANOX ETHERNET INNOVA DRIVERS to TLS support removal
    https://git.kernel.org/netdev/net/c/ed872f92fd09

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


