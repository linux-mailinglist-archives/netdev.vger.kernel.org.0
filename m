Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B469665BF1
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbjAKNAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbjAKNAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:00:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBFB1A069
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AD60B81BE6
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 13:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C27CC433F0;
        Wed, 11 Jan 2023 13:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673442019;
        bh=RCVgb6CuKxUks++V/yoy/9fcKrAt0H7petnGxxEshq4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HeYCxeeWfI4JVjmxCI9qDSkaIu91kfvAZXo5Qquu9rGfpsdl/K8QYE8wvEnBdG4ZJ
         C1WxcjscaiM5Mf8AGbag4JK/YrXtXRurmZ6EQ0o8Jbe8cfD8+up6HcTWwBGIVYh5yj
         iJ6lr0+ytex7kuiY1MIPi7ijEE6uRDZD0Md8BY5NnPonQf6jDzwCJE6LUW1vJReYmJ
         9hrH1Pcy8dMkhKigZz9kCwY95EMTWC7+TtTcHIiRTY5uSBBmzZxG9umFB2ktku9UUp
         YbtDvf1NMUYLCmWVx8UWM7w1PpYkoWBhlG7d4pIK+lFSCMICsFyAnhxnnhrP7NNxNK
         s0ohqeuFNcVcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 073EBE270F6;
        Wed, 11 Jan 2023 13:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/16] net/mlx5: DR,
 Fix 'stack frame size exceeds limit' error in dr_rule
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167344201902.10656.17238842567216806347.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Jan 2023 13:00:19 +0000
References: <20230110061123.338427-2-saeed@kernel.org>
In-Reply-To: <20230110061123.338427-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, kliteyn@nvidia.com, lkp@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Mon,  9 Jan 2023 22:11:08 -0800 you wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> 
> If the kernel configuration asks the compiler to check frame limit of 1K,
> dr_rule_create_rule_nic exceed this limit:
>     "stack frame size (1184) exceeds limit (1024)"
> 
> Fixing this issue by checking configured frame limit and using the
> optimization STE array only for cases with the usual 2K (or larger)
> stack size warning.
> 
> [...]

Here is the summary with links:
  - [net,01/16] net/mlx5: DR, Fix 'stack frame size exceeds limit' error in dr_rule
    https://git.kernel.org/netdev/net/c/17b3222e9437
  - [net,02/16] net/mlx5: check attr pointer validity before dereferencing it
    https://git.kernel.org/netdev/net/c/e0bf81bf0d3d
  - [net,03/16] net/mlx5e: TC, Keep mod hdr actions after mod hdr alloc
    https://git.kernel.org/netdev/net/c/5e72f3f1c558
  - [net,04/16] net/mlx5: Fix command stats access after free
    https://git.kernel.org/netdev/net/c/da2e552b469a
  - [net,05/16] net/mlx5e: Verify dev is present for fix features ndo
    https://git.kernel.org/netdev/net/c/ab4b01bfdaa6
  - [net,06/16] net/mlx5e: IPoIB, Block queue count configuration when sub interfaces are present
    https://git.kernel.org/netdev/net/c/806a8df7126a
  - [net,07/16] net/mlx5e: IPoIB, Block PKEY interfaces with less rx queues than parent
    https://git.kernel.org/netdev/net/c/31c70bfe58ef
  - [net,08/16] net/mlx5e: IPoIB, Fix child PKEY interface stats on rx path
    https://git.kernel.org/netdev/net/c/b5e23931c45a
  - [net,09/16] net/mlx5e: TC, ignore match level for post meter rules
    https://git.kernel.org/netdev/net/c/2414c9b7a29d
  - [net,10/16] net/mlx5e: TC, Restore pkt rate policing support
    https://git.kernel.org/netdev/net/c/c09502d54dc1
  - [net,11/16] net/mlx5e: Fix memory leak on updating vport counters
    https://git.kernel.org/netdev/net/c/3099d2e62f90
  - [net,12/16] net/mlx5: Fix ptp max frequency adjustment range
    https://git.kernel.org/netdev/net/c/fe91d57277ee
  - [net,13/16] net/mlx5e: Don't support encap rules with gbp option
    https://git.kernel.org/netdev/net/c/d515d63cae2c
  - [net,14/16] net/mlx5: E-switch, Coverity: overlapping copy
    https://git.kernel.org/netdev/net/c/cd4f186dc110
  - [net,15/16] net/mlx5e: Fix macsec ssci attribute handling in offload path
    https://git.kernel.org/netdev/net/c/f5e1ed04aa2e
  - [net,16/16] net/mlx5e: Fix macsec possible null dereference when updating MAC security entity (SecY)
    https://git.kernel.org/netdev/net/c/9828994ac492

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


