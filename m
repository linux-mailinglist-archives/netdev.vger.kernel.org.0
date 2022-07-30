Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBAAE5858A7
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 06:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiG3EuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 00:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiG3EuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 00:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B63FBE02
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 21:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D89DA60691
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 04:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4009FC433C1;
        Sat, 30 Jul 2022 04:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659156617;
        bh=X6b2uyF1kiSc3C0vcWPrkQSbAOy9ELbybhCAgu02Srw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S8U7hrbE682Pv4O9tH1kxFe6LRC5QXDG4x3jV9isHTaJGHALUKnmcS2LkjbqCXYaZ
         ESzZLO0Po9dt5E+pTEwu0awfbM8tX8HmteCa/sXTtWVf1Se7oIY954PypvOMPzaqAu
         F2ef0G+fLN8rdiAme0bGsDpvMy7xVwUja9Nn0GNAk1HorfgVjma+84pjBl2BHTlsci
         jOXiTrD1XOHsn14yTIJKe52aIBj61dpIyvHnJO1vnq3QwEuUdJ6T2087epXz7bmnlQ
         bpvdPMms+ljmM4lCLquTN4HQN7pGATmJ/5ACOjH1Xf5cNkAnoSTtwbHDxgHrSs8MOK
         np6imdQeYrQvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2BA64C43143;
        Sat, 30 Jul 2022 04:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5e: Fix wrong use of skb_tcp_all_headers()
 with encapsulation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165915661717.14353.11968411809421038202.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jul 2022 04:50:17 +0000
References: <20220728205728.143074-2-saeed@kernel.org>
In-Reply-To: <20220728205728.143074-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, gal@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 28 Jul 2022 13:57:14 -0700 you wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> Use skb_inner_tcp_all_headers() instead of skb_tcp_all_headers() when
> transmitting an encapsulated packet in mlx5e_tx_get_gso_ihs().
> 
> Fixes: 504148fedb85 ("net: add skb_[inner_]tcp_all_headers helpers")
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: Fix wrong use of skb_tcp_all_headers() with encapsulation
    https://git.kernel.org/netdev/net-next/c/ec082d31c161
  - [net-next,02/15] net/mlx5: DR, Add support for flow metering ASO
    https://git.kernel.org/netdev/net-next/c/8920d92b8be6
  - [net-next,03/15] net/mlx5e: TC, Allocate post meter ft per rule
    https://git.kernel.org/netdev/net-next/c/e5b1db27410e
  - [net-next,04/15] net/mlx5e: Add red and green counters for metering
    https://git.kernel.org/netdev/net-next/c/b50ce4350c10
  - [net-next,05/15] net/mlx5e: TC, Separate get/update/replace meter functions
    https://git.kernel.org/netdev/net-next/c/f8e9d413a28a
  - [net-next,06/15] net/mlx5e: TC, Support tc action api for police
    https://git.kernel.org/netdev/net-next/c/7d1a5ce46e47
  - [net-next,07/15] net/mlx5e: Convert mlx5e_tc_table member of mlx5e_flow_steering to pointer
    https://git.kernel.org/netdev/net-next/c/65f586c2730c
  - [net-next,08/15] net/mlx5e: Make mlx5e_tc_table private
    https://git.kernel.org/netdev/net-next/c/23bde065c3a2
  - [net-next,09/15] net/mlx5e: Allocate VLAN and TC for featured profiles only
    https://git.kernel.org/netdev/net-next/c/454533aa87f4
  - [net-next,10/15] net/mlx5e: Convert mlx5e_flow_steering member of mlx5e_priv to pointer
    https://git.kernel.org/netdev/net-next/c/af8bbf730068
  - [net-next,11/15] net/mlx5e: Report flow steering errors with mdev err report API
    https://git.kernel.org/netdev/net-next/c/6a7bc5d0e1c3
  - [net-next,12/15] net/mlx5e: Add mdev to flow_steering struct
    https://git.kernel.org/netdev/net-next/c/7bb7071568e3
  - [net-next,13/15] net/mlx5e: Separate mlx5e_set_rx_mode_work and move caller to en_main
    https://git.kernel.org/netdev/net-next/c/5b031add2f94
  - [net-next,14/15] net/mlx5e: Split en_fs ndo's and move to en_main
    https://git.kernel.org/netdev/net-next/c/a02c07ea5d0b
  - [net-next,15/15] net/mlx5e: Move mlx5e_init_l2_addr to en_main
    https://git.kernel.org/netdev/net-next/c/069448b2fd0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


