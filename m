Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99FC6BC592
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 06:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjCPFUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 01:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjCPFUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 01:20:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AE2ACB86
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 22:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AB9161F27
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9CCFCC433D2;
        Thu, 16 Mar 2023 05:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678944020;
        bh=MHG0WQSMsxuL5n5puTbKrrlmIWZqscexIoNIHE0zKNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=btWvypdNXRT/dPFIaEo9R8FZHO/9hFtZ6cLII3AUPScgiDt4I6EEuRv98lOJbEmre
         mEXUd8oZy/wFptNXe+24DlDAmEWocXO4LGPoEMjVQNKi9s7yMJBY8ojLmEerxQJn9w
         gHZFR3KP6qTs3H4Ta79ZgyFU/1hW/dD7DxRdRFff6Rd7vFq2NmxR2/Hur+mzoh1dJB
         Tzv/sKCLo2V+mftDX3cqVwsPVdvDhiwGS+pgeGnxThMM84tYYE18KWz8GPly3HbGrp
         axBnTXdx4F5JeP89MLp2vWJeMgJPHx4hhNNhL8ik7TeRVcM93E0eZG8jsd7XTAcWOA
         IULpRC/4MVgsQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79DEDE66CBF;
        Thu, 16 Mar 2023 05:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: remove redundant clear_bit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167894402049.17806.16003249846354613363.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 05:20:20 +0000
References: <20230314054234.267365-2-saeed@kernel.org>
In-Reply-To: <20230314054234.267365-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, moshe@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 13 Mar 2023 22:42:20 -0700 you wrote:
> From: Moshe Shemesh <moshe@nvidia.com>
> 
> When shutdown or remove callbacks are called the driver sets the flag
> MLX5_BREAK_FW_WAIT, to stop waiting for FW as teardown was called. There
> is no need to clear the bit as once shutdown or remove were called as
> there is no way back, the driver is going down. Furthermore, if not
> cleared the flag can be used also in other loops where we may wait while
> teardown was already called.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: remove redundant clear_bit
    https://git.kernel.org/netdev/net-next/c/c05d145abea1
  - [net-next,02/15] net/mlx5: Stop waiting for PCI up if teardown was triggered
    https://git.kernel.org/netdev/net-next/c/8ff38e730c3f
  - [net-next,03/15] net/mlx5: Add comment to mlx5_devlink_params_register()
    https://git.kernel.org/netdev/net-next/c/ceefcfb8a375
  - [net-next,04/15] net/mlx5: Implement thermal zone
    https://git.kernel.org/netdev/net-next/c/c1fef618d611
  - [net-next,05/15] net/mlx5e: Correct SKB room check to use all room in the fifo
    https://git.kernel.org/netdev/net-next/c/aa98d15ea40b
  - [net-next,06/15] net/mlx5e: Rename RQ/SQ adaptive moderation state flag
    https://git.kernel.org/netdev/net-next/c/2b5bd5b1611b
  - [net-next,07/15] net/mlx5e: Stringify RQ SW state in RQ devlink health diagnostics
    https://git.kernel.org/netdev/net-next/c/1fe7bc109e3e
  - [net-next,08/15] net/mlx5e: Expose SQ SW state as part of SQ health diagnostics
    https://git.kernel.org/netdev/net-next/c/fc9d982a2512
  - [net-next,09/15] net/mlx5e: Add XSK RQ state flag for RQ devlink health diagnostics
    https://git.kernel.org/netdev/net-next/c/bb76d250e55c
  - [net-next,10/15] net/mlx5: Move needed PTYS functions to core layer
    https://git.kernel.org/netdev/net-next/c/028522e28443
  - [net-next,11/15] net/mlx5e: Add devlink hairpin queues parameters
    https://git.kernel.org/netdev/net-next/c/1bffcea42926
  - [net-next,12/15] net/mlx5e: Add more information to hairpin table dump
    https://git.kernel.org/netdev/net-next/c/8a0594c09610
  - [net-next,13/15] net/mlx5e: TC, Extract indr setup block checks to function
    https://git.kernel.org/netdev/net-next/c/244fd698207f
  - [net-next,14/15] net/mlx5e: Enable TC offload for ingress MACVLAN over bond
    https://git.kernel.org/netdev/net-next/c/d5d006bb27ad
  - [net-next,15/15] net/mlx5e: Enable TC offload for egress MACVLAN over bond
    https://git.kernel.org/netdev/net-next/c/63b02048f9a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


