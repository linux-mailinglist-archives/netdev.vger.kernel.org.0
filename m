Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6922F6120B7
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 08:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiJ2Ga2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 02:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ2GaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 02:30:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BC754CA4
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 23:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1F3460C3E
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 06:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15A45C433D6;
        Sat, 29 Oct 2022 06:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667025022;
        bh=/sbLvIG23sBtl1amXt9PC/5HQcTlyUWS3dsau+D6RXw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IjfwzJNHMLGube+sJlSG05ftELQGAyy0nVpRVNJBLLzaxEffHGMH8Lq96N/bQs3DH
         9SfYba/tG07tcdeqZCQ1moz1FKn1LbmjTa7UWO3/7hMlOfJSGFRSeUeOMb5nMp215/
         KYl0MoHVnC44HF/yQhCbC9FO+tLJE5Nr1Q9BiHvKn6HdgS4XNugCFp2+HW7HRlxumb
         inyKVNIbfhqyGCP20JjI6PxZ2hNv7TXuxLDEgrS7jwK9nI4E1X+9+fEuo1kScjAebU
         ZnKVq1wQwDUmmbYnp0IOGzLXJdZnTcdei36Nraix82J2qoliCj9XyBCwFhVPIP9wis
         lXG2e9Z+n57CQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E5F86C41677;
        Sat, 29 Oct 2022 06:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next V2 01/14] net/mlx5: DR, In destroy flow,
 free resources even if FW command failed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166702502193.25217.18098583636278445187.git-patchwork-notify@kernel.org>
Date:   Sat, 29 Oct 2022 06:30:21 +0000
References: <20221027145643.6618-2-saeed@kernel.org>
In-Reply-To: <20221027145643.6618-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, kliteyn@nvidia.com, cmi@nvidia.com,
        valex@nvidia.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 27 Oct 2022 15:56:30 +0100 you wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> 
> Otherwise resources will never be freed and refcount will not be decreased.
> 
> Signed-off-by: Chris Mi <cmi@nvidia.com>
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Alex Vesker <valex@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,V2,01/14] net/mlx5: DR, In destroy flow, free resources even if FW command failed
    https://git.kernel.org/netdev/net-next/c/14335d54e721
  - [net-next,V2,02/14] net/mlx5: DR, Fix the SMFS sync_steering for fast teardown
    https://git.kernel.org/netdev/net-next/c/c4193a1281ac
  - [net-next,V2,03/14] net/mlx5: DR, Check device state when polling CQ
    https://git.kernel.org/netdev/net-next/c/5fd08f653991
  - [net-next,V2,04/14] net/mlx5: DR, Remove unneeded argument from dr_icm_chunk_destroy
    https://git.kernel.org/netdev/net-next/c/d277b55f0fa8
  - [net-next,V2,05/14] net/mlx5: DR, For short chains of STEs, avoid allocating ste_arr dynamically
    https://git.kernel.org/netdev/net-next/c/b9b81e1e9382
  - [net-next,V2,06/14] net/mlx5: DR, Initialize chunk's ste_arrays at chunk creation
    https://git.kernel.org/netdev/net-next/c/06ab4a4089d4
  - [net-next,V2,07/14] net/mlx5: DR, Handle domain memory resources init/uninit separately
    https://git.kernel.org/netdev/net-next/c/183a6706a07e
  - [net-next,V2,08/14] net/mlx5: DR, In rehash write the line in the entry immediately
    https://git.kernel.org/netdev/net-next/c/1bea2dc7f4ff
  - [net-next,V2,09/14] net/mlx5: DR, Manage STE send info objects in pool
    https://git.kernel.org/netdev/net-next/c/17b56073a066
  - [net-next,V2,10/14] net/mlx5: DR, Allocate icm_chunks from their own slab allocator
    https://git.kernel.org/netdev/net-next/c/fd785e5213f0
  - [net-next,V2,11/14] net/mlx5: DR, Allocate htbl from its own slab allocator
    https://git.kernel.org/netdev/net-next/c/fb628b71fb2a
  - [net-next,V2,12/14] net/mlx5: DR, Lower sync threshold for ICM hot memory
    https://git.kernel.org/netdev/net-next/c/133ea373a043
  - [net-next,V2,13/14] net/mlx5: DR, Keep track of hot ICM chunks in an array instead of list
    https://git.kernel.org/netdev/net-next/c/4519fc45beeb
  - [net-next,V2,14/14] net/mlx5: DR, Remove the buddy used_list
    https://git.kernel.org/netdev/net-next/c/edaea001442a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


