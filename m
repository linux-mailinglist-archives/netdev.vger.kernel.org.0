Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A651E5EEC18
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbiI2Cue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbiI2Cu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:50:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6617228E21
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:50:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC9ABB82331
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73E53C433D7;
        Thu, 29 Sep 2022 02:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664419825;
        bh=Kdh42c22YiAVfGjWkaYhPoy4CSL0tiDZVdMvZ/L3UYM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QTzhDDXUfCv5RAF85uPuHMUmzJV/IWMJhGs04o8XkaG1XIkVMD9YyehmJlAyeZCK7
         nvOicwJe3f/dmTejDQHtUBPkWKLLLKDIhAGWsfj/EJH3QM4atH0FwFvEQi/bSBiHgf
         QXY1NZT9dzRWJUFUPHW5svJCf0mtnVxnny/NHFqwsohg5+s+KX15oX1yfT+BxOuhG3
         fwZkkPgl7AOrQnZXw4+5n3nJUDHP9NtIMDdCBsdJb7gIbLTuAyR/QwV/451Miyfiuq
         6zae84LHYpD30BJGpSFG3FaK5DjxjgX/I17LUoCfauDSvxtC2uMf1X2XjJ2XVgvQBc
         3/bgPn9Ev3mrg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58B16C395DA;
        Thu, 29 Sep 2022 02:50:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/16] net/mlx5: Add the log_min_mkey_entity_size
 capability
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166441982535.2371.10734224437050791536.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 02:50:25 +0000
References: <20220927203611.244301-2-saeed@kernel.org>
In-Reply-To: <20220927203611.244301-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, maximmi@nvidia.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 27 Sep 2022 13:35:56 -0700 you wrote:
> From: Maxim Mikityanskiy <maximmi@nvidia.com>
> 
> Add the capability that will allow the driver to determine the minimal
> MTT page size to be able to map the smallest possible pages in XSK. The
> older firmwares that don't have this capability default to 12 (i.e.
> 4096-byte pages).
> 
> [...]

Here is the summary with links:
  - [net-next,01/16] net/mlx5: Add the log_min_mkey_entity_size capability
    https://git.kernel.org/netdev/net-next/c/40b72108f9c6
  - [net-next,02/16] net/mlx5e: Convert mlx5e_get_max_sq_wqebbs to u8
    https://git.kernel.org/netdev/net-next/c/f060ccc2afaa
  - [net-next,03/16] net/mlx5e: Remove unused fields from datapath structs
    https://git.kernel.org/netdev/net-next/c/665f29de4ca3
  - [net-next,04/16] net/mlx5e: Make mlx5e_verify_rx_mpwqe_strides static
    https://git.kernel.org/netdev/net-next/c/7e49abb1e393
  - [net-next,05/16] net/mlx5e: Validate striding RQ before enabling XDP
    https://git.kernel.org/netdev/net-next/c/44f4fd03b517
  - [net-next,06/16] net/mlx5e: Let mlx5e_get_sw_max_sq_mpw_wqebbs accept mdev
    https://git.kernel.org/netdev/net-next/c/ed5c92ff0f3e
  - [net-next,07/16] net/mlx5e: Use mlx5e_stop_room_for_max_wqe where appropriate
    https://git.kernel.org/netdev/net-next/c/527918e9cc4d
  - [net-next,08/16] net/mlx5e: Fix a typo in mlx5e_xdp_mpwqe_is_full
    https://git.kernel.org/netdev/net-next/c/e3c4c496dc9a
  - [net-next,09/16] net/mlx5e: Use the aligned max TX MPWQE size
    https://git.kernel.org/netdev/net-next/c/21a0502d5910
  - [net-next,10/16] net/mlx5e: kTLS, Check ICOSQ WQE size in advance
    https://git.kernel.org/netdev/net-next/c/4c78782e2e98
  - [net-next,11/16] net/mlx5e: Simplify stride size calculation for linear RQ
    https://git.kernel.org/netdev/net-next/c/ddbef3656072
  - [net-next,12/16] net/mlx5e: xsk: Remove dead code in validation
    https://git.kernel.org/netdev/net-next/c/8c654a1bb686
  - [net-next,13/16] net/mlx5e: xsk: Fix SKB headroom calculation in validation
    https://git.kernel.org/netdev/net-next/c/411295fbe6f4
  - [net-next,14/16] net/mlx5e: Improve the MTU change shortcut
    https://git.kernel.org/netdev/net-next/c/3904d2afad4c
  - [net-next,15/16] net/mlx5e: Make dma_info array dynamic in struct mlx5e_mpw_info
    https://git.kernel.org/netdev/net-next/c/258e655c0073
  - [net-next,16/16] net/mlx5e: Use runtime values of striding RQ parameters in datapath
    https://git.kernel.org/netdev/net-next/c/997ce6affe26

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


