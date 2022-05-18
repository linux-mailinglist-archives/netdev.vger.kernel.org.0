Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80ACD52B851
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 13:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbiERLKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 07:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbiERLKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 07:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B03533A2C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 04:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC19F6182A
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 11:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45019C385AA;
        Wed, 18 May 2022 11:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652872216;
        bh=eyw48SD2MJXkxmXnwjOZoaefYbwfVlU4Ih84sywTRe0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kuoj4W4d4tM4Sh1s/KuA5aENVXM0FmDKq/ptgRozP+rSIZvnaaEmtqORuPfTjuHCf
         VxUoNryPDXtqyaUCS7l7CeN9dUM8oJ83RnxLJpLRtEvGpKlNMJJE3w9JfrS94ufU+p
         94qdENV5qt5iNA7cZDfwPDrF75+aThN5dWaAmur3yiI298bVjdwUBjzj7Xo2RT1IlX
         Qk+EfgHRUcwh9xW0/xvuJnA6kJ5R6Faa65TUnnRXOIeqBAYcEQlK9hS0hkLbswUHh7
         kqejsmq1hDq0tcYWUVOWAydv0huO8UeAM+7HchJNSZTU/nVLKjgbqCm/ja/0V1JJmJ
         lnjo9lLZsv18A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3077AF0392C;
        Wed, 18 May 2022 11:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/16] net/mlx5: sparse: error: context imbalance in
 'mlx5_vf_get_core_dev'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287221619.23187.7382538538101425503.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 11:10:16 +0000
References: <20220518064938.128220-2-saeed@kernel.org>
In-Reply-To: <20220518064938.128220-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, saeedm@nvidia.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 17 May 2022 23:49:23 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Removing the annotation resolves the issue for some reason.
> 
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - [net-next,01/16] net/mlx5: sparse: error: context imbalance in 'mlx5_vf_get_core_dev'
    https://git.kernel.org/netdev/net-next/c/4c7c8a6d87a8
  - [net-next,02/16] net/mlx5: Add last command failure syndrome to debugfs
    https://git.kernel.org/netdev/net-next/c/1d2c717bc7f7
  - [net-next,03/16] net/mlx5: Inline db alloc API function
    https://git.kernel.org/netdev/net-next/c/9b45bde82c22
  - [net-next,04/16] net/mlx5: Allocate virtually contiguous memory in vport.c
    https://git.kernel.org/netdev/net-next/c/773c104d5333
  - [net-next,05/16] net/mlx5: Allocate virtually contiguous memory in pci_irq.c
    https://git.kernel.org/netdev/net-next/c/88468311c07a
  - [net-next,06/16] net/mlx5e: Allocate virtually contiguous memory for VLANs list
    https://git.kernel.org/netdev/net-next/c/035e0dd57392
  - [net-next,07/16] net/mlx5e: Allocate virtually contiguous memory for reps structures
    https://git.kernel.org/netdev/net-next/c/597c11232619
  - [net-next,08/16] net/mlx5e: IPoIB, Improve ethtool rxnfc callback structure in IPoIB
    https://git.kernel.org/netdev/net-next/c/675b9d51d6fb
  - [net-next,09/16] net/mlx5e: Support partial GSO for tunnels over vlans
    https://git.kernel.org/netdev/net-next/c/682adfa6ca80
  - [net-next,10/16] net/mlx5e: Allow relaxed ordering over VFs
    https://git.kernel.org/netdev/net-next/c/f05ec8d9d0d6
  - [net-next,11/16] net/mlx5e: CT: Add ct driver counters
    https://git.kernel.org/netdev/net-next/c/77422a8f6f61
  - [net-next,12/16] net/mlx5e: Correct the calculation of max channels for rep
    https://git.kernel.org/netdev/net-next/c/6d0ba49321a4
  - [net-next,13/16] net/mlx5e: Add XDP SQs to uplink representors steering tables
    https://git.kernel.org/netdev/net-next/c/65810a2d2ab3
  - [net-next,14/16] net/mlx5: Lag, refactor lag state machine
    https://git.kernel.org/netdev/net-next/c/ef9a3a4a813a
  - [net-next,15/16] net/mlx5: Remove unused argument
    https://git.kernel.org/netdev/net-next/c/a4a9c87ebb68
  - [net-next,16/16] net/mlx5: Support multiport eswitch mode
    https://git.kernel.org/netdev/net-next/c/94db33177819

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


