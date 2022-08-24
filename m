Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779D159F07C
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 03:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiHXBAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 21:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiHXBAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 21:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FB886C1B
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 18:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E60B61536
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 01:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70E76C433D7;
        Wed, 24 Aug 2022 01:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661302819;
        bh=M8MC2bKFUvuSpWAKNP0FjyKAXbf/nOKb6GrrHGm2tjw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tyAqcT57j0adn8TxAt53kEr4+8b16jryYK2mw26kQ1FDzVyYMtFESXQLuss9y71Vj
         HJCpI105pG0MRSHS10Jm2zK5XM5nN5DsxTwvWtaQpIf4CLfr/DBb4npPCMTPwACGB2
         fI3ZRBtW7Iy7tN3Fm9j7FI+Lhr4wPH5LXoUnLgbKh6MgNYKGf6AzL7n4RNoVyXji+l
         8G2jZhSV/AonK81l6IcwkBmP2bU0QqJX5Ee10p9aFDH+5xqJaeeIFLISFYL93+eDLI
         bqsVwIwEw3EMqthP2yUjlwUEvaGnTGJWl/h9gQZhh/esUmvNmdVUep2JCxIXHSRaGZ
         WVEGCg5lsCAwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F031C004EF;
        Wed, 24 Aug 2022 01:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/13] net/mlx5e: Properly disable vlan strip on non-UL reps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166130281931.24197.12062466321400824526.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 01:00:19 +0000
References: <20220822195917.216025-2-saeed@kernel.org>
In-Reply-To: <20220822195917.216025-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        vladbu@nvidia.com, roid@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 22 Aug 2022 12:59:05 -0700 you wrote:
> From: Vlad Buslov <vladbu@nvidia.com>
> 
> When querying mlx5 non-uplink representors capabilities with ethtool
> rx-vlan-offload is marked as "off [fixed]". However, it is actually always
> enabled because mlx5e_params->vlan_strip_disable is 0 by default when
> initializing struct mlx5e_params instance. Fix the issue by explicitly
> setting the vlan_strip_disable to 'true' for non-uplink representors.
> 
> [...]

Here is the summary with links:
  - [net,01/13] net/mlx5e: Properly disable vlan strip on non-UL reps
    https://git.kernel.org/netdev/net/c/f37044fd759b
  - [net,02/13] net/mlx5: LAG, fix logic over MLX5_LAG_FLAG_NDEVS_READY
    https://git.kernel.org/netdev/net/c/a6e675a66175
  - [net,03/13] net/mlx5: Eswitch, Fix forwarding decision to uplink
    https://git.kernel.org/netdev/net/c/942fca7e762b
  - [net,04/13] net/mlx5: Disable irq when locking lag_lock
    https://git.kernel.org/netdev/net/c/8e93f29422ff
  - [net,05/13] net/mlx5: Fix cmd error logging for manage pages cmd
    https://git.kernel.org/netdev/net/c/090f3e4f4089
  - [net,06/13] net/mlx5: Avoid false positive lockdep warning by adding lock_class_key
    https://git.kernel.org/netdev/net/c/d59b73a66e5e
  - [net,07/13] net/mlx5e: Fix wrong application of the LRO state
    https://git.kernel.org/netdev/net/c/7b3707fc7904
  - [net,08/13] net/mlx5e: TC, Add missing policer validation
    https://git.kernel.org/netdev/net/c/f7a4e867f48c
  - [net,09/13] net/mlx5e: Fix wrong tc flag used when set hw-tc-offload off
    https://git.kernel.org/netdev/net/c/550f96432e6f
  - [net,10/13] net/mlx5: unlock on error path in esw_vfs_changed_event_handler()
    https://git.kernel.org/netdev/net/c/b868c8fe37bd
  - [net,11/13] net/mlx5e: kTLS, Use _safe() iterator in mlx5e_tls_priv_tx_list_cleanup()
    https://git.kernel.org/netdev/net/c/6514210b6d0d
  - [net,12/13] net/mlx5e: Fix use after free in mlx5e_fs_init()
    https://git.kernel.org/netdev/net/c/21234e3a84c7
  - [net,13/13] net/mlx5: Unlock on error in mlx5_sriov_enable()
    https://git.kernel.org/netdev/net/c/35419025cb1e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


