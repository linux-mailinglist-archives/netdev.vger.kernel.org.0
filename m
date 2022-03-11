Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FDC4D6048
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 12:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348134AbiCKLBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 06:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237179AbiCKLBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 06:01:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8FF1B2AE2
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 03:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90E3C61B4B
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 11:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1B86C340EC;
        Fri, 11 Mar 2022 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646996414;
        bh=5b4AnospVNzoixo5Sj0uauqIidiIVN3N8JKT2GY8o38=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KM/R8H7Nzi5RftSY+x2xl7d7i0VLx+Nupv5H6KjSZOFA/kBWsmrzoPeDdvqnIQxFc
         CF+196tH+DfHz6gjS39e40eg428B4v3/hvN8UJFIQpGQB+/0ahSV1jRgAEzQnWrlLW
         wB+xzNhivDI57ppAgQfMwRsyRZjW+a1pUxWCj6ZTZul4cx/SMpcEg+sZgYl6iKwuIP
         7r5PpS9n3rFaNCTpnpVIeRTt0aaOptDTODMHwLEenkQbxBlRdYvLUtEHA5Oiw3D8CJ
         7IckkjrlUJ+WQZhRyWCPVF/AFZdekXeDVolZFovJZz+S7f8bsZ8JR4nt0+j/+MVZTN
         qoHrJcc3cL/7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C338DEAC095;
        Fri, 11 Mar 2022 11:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx4: Delete useless moduleparam include
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164699641379.30508.14750751860069066240.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 11:00:13 +0000
References: <20220311074031.645168-2-saeed@kernel.org>
In-Reply-To: <20220311074031.645168-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        leonro@nvidia.com, saeedm@nvidia.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 10 Mar 2022 23:40:17 -0800 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Remove inclusion of not used moduleparam.h.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx4: Delete useless moduleparam include
    https://git.kernel.org/netdev/net-next/c/042637019ea3
  - [net-next,02/15] net/mlx5: Delete useless module.h include
    https://git.kernel.org/netdev/net-next/c/71ab580705c1
  - [net-next,03/15] net/mlx5: Node-aware allocation for the IRQ table
    https://git.kernel.org/netdev/net-next/c/196df17ac53a
  - [net-next,04/15] net/mlx5: Node-aware allocation for the EQ table
    https://git.kernel.org/netdev/net-next/c/e894246df513
  - [net-next,05/15] net/mlx5: Node-aware allocation for the EQs
    https://git.kernel.org/netdev/net-next/c/7f880719b953
  - [net-next,06/15] net/mlx5: Node-aware allocation for UAR
    https://git.kernel.org/netdev/net-next/c/b5e4c3079490
  - [net-next,07/15] net/mlx5: Node-aware allocation for the doorbell pgdir
    https://git.kernel.org/netdev/net-next/c/a3540effb766
  - [net-next,08/15] net/mlx5: CT: Introduce a platform for multiple flow steering providers
    https://git.kernel.org/netdev/net-next/c/769090005230
  - [net-next,09/15] net/mlx5: DR, Add helper to get backing dr table from a mlx5 flow table
    https://git.kernel.org/netdev/net-next/c/34ea969d1645
  - [net-next,10/15] net/mlx5: Add smfs lib to export direct steering API to CT
    https://git.kernel.org/netdev/net-next/c/c6fef514adaa
  - [net-next,11/15] net/mlx5: CT: Add software steering ct flow steering provider
    https://git.kernel.org/netdev/net-next/c/3ee61ebb0df1
  - [net-next,12/15] net/mlx5: CT: Create smfs dr matchers dynamically
    https://git.kernel.org/netdev/net-next/c/fbf6836db42d
  - [net-next,13/15] net/mlx5: Query the maximum MCIA register read size from firmware
    https://git.kernel.org/netdev/net-next/c/271907ee2f29
  - [net-next,14/15] net/mlx5: Parse module mapping using mlx5_ifc
    https://git.kernel.org/netdev/net-next/c/fcb610a86c53
  - [net-next,15/15] net/mlx5e: Remove overzealous validations in netlink EEPROM query
    https://git.kernel.org/netdev/net-next/c/970adfb76095

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


