Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584DE4670A5
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 04:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242472AbhLCDXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 22:23:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34658 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241442AbhLCDXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 22:23:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 427EEB825AF
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 03:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D410BC00446;
        Fri,  3 Dec 2021 03:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638501611;
        bh=Ih6QJE8jAZ5PiGqV1Zd0Pq/yzOpCiEibh5Mp9nw/fY8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XspwGG3IwkfyOjRtFQXU17GptmmOF5QqhH/7jkZiv/BrLhYjn6r03P8v8+r4iDWJf
         hHBa30YlGDCp/CBbjGJnGPraT90omv1qnwDq667//MiEeiuNUAoDuVXn8aClvfKPkS
         761b/fDleGrHrJFogQ7XbOC85hNxvzzQu6hAyWUmJ15HAzMkjn6zNB/onSVVlqco+f
         clMCSJlIsHuQpiiAUUSTWFdAUuLLelQSx7r2rdTyzzEtC231JcvePxrH2C87fsOjt0
         xoLROzk533K5adP4wfvQet/ZhAX8ZmDhNZbOM2+h8yfBqYU+ap6a9V9pVVHpJgmhcm
         o152FEqG5uCHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BD3F260A5A;
        Fri,  3 Dec 2021 03:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v0 01/14] mlx5: fix psample_sample_packet link error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163850161177.31717.8006639067892103879.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 03:20:11 +0000
References: <20211203005622.183325-2-saeed@kernel.org>
In-Reply-To: <20211203005622.183325-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        arnd@arndb.de, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Thu,  2 Dec 2021 16:56:09 -0800 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When PSAMPLE is a loadable module, built-in drivers cannot use it:
> 
> aarch64-linux-ld: drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.o: in function `mlx5e_tc_sample_skb':
> sample.c:(.text+0xd68): undefined reference to `psample_sample_packet'
> 
> [...]

Here is the summary with links:
  - [net-next,v0,01/14] mlx5: fix psample_sample_packet link error
    https://git.kernel.org/netdev/net-next/c/7a7dd5114f53
  - [net-next,v0,02/14] mlx5: fix mlx5i_grp_sw_update_stats() stack usage
    https://git.kernel.org/netdev/net-next/c/d2b8c7ba3c79
  - [net-next,v0,03/14] net/mlx5: Fix error return code in esw_qos_create()
    https://git.kernel.org/netdev/net-next/c/baf5c001300e
  - [net-next,v0,04/14] net/mlx5: Fix some error handling paths in 'mlx5e_tc_add_fdb_flow()'
    https://git.kernel.org/netdev/net-next/c/31108d142f36
  - [net-next,v0,05/14] net/mlx5: SF, silence an uninitialized variable warning
    https://git.kernel.org/netdev/net-next/c/c64d01b3ceba
  - [net-next,v0,06/14] net/mlx5: Print more info on pci error handlers
    https://git.kernel.org/netdev/net-next/c/fad1783a6d66
  - [net-next,v0,07/14] net/mlx5e: SHAMPO, clean MLX5E_MAX_KLM_PER_WQE macro
    https://git.kernel.org/netdev/net-next/c/3ef1f8e795ba
  - [net-next,v0,08/14] net/mlx5e: Hide function mlx5e_num_channels_changed
    https://git.kernel.org/netdev/net-next/c/e9542221c4f5
  - [net-next,v0,09/14] net/mlx5e: TC, Remove redundant action stack var
    https://git.kernel.org/netdev/net-next/c/9745dbe03669
  - [net-next,v0,10/14] net/mlx5e: Remove redundant actions arg from validate_goto_chain()
    https://git.kernel.org/netdev/net-next/c/3cc78411f3f4
  - [net-next,v0,11/14] net/mlx5e: Remove redundant actions arg from vlan push/pop funcs
    https://git.kernel.org/netdev/net-next/c/70a140ea6f79
  - [net-next,v0,12/14] net/mlx5e: TC, Move common flow_action checks into function
    https://git.kernel.org/netdev/net-next/c/df990477242f
  - [net-next,v0,13/14] net/mlx5e: TC, Set flow attr ip_version earlier
    https://git.kernel.org/netdev/net-next/c/d4bb053139e7
  - [net-next,v0,14/14] net/mlx5: Dynamically resize flow counters query buffer
    https://git.kernel.org/netdev/net-next/c/b247f32aecad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


