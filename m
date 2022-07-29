Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C505584B25
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbiG2Fa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234370AbiG2FaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34FBFC6
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 22:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F64661E9F
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 05:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7F5DC433D6;
        Fri, 29 Jul 2022 05:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659072619;
        bh=ULfow0chMbeGsaMVPvBNDi7g8QPrTy4HO8Ud0mNnALM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R7l5mKmqMhv3aH9dAvqvElkJ15udLww6TxH369ATbvFTvnbnr6sROT9z7sB1Oe5dQ
         EgC6g3Ard/hqjl1W6S23hFkno0XRfSsDy+Q1uc4WkZIwlZWlnMFUVFszN7QKi7rJ5L
         b+qGQu5BFYzncyvu+mpPgmnnhcE6/5F0I+6ajxAEYY3ZmhqDyNohUvc5V7Aiy5Od5M
         tbdoGp19KadO94GrGAmIFb/NQmDNrtNZQa4ZgxxrF1EpPL2F4PDvCirLVTKhqwpsrF
         fGfMusCHwSYF49kaym9GhaT1nGfiBdRVz8G94cG4Cy02+ukgJl91R5yArlpNzC9wXS
         bgvBLRzMmQg4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BCF32C43144;
        Fri, 29 Jul 2022 05:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/9] Take devlink lock on mlx4 and mlx5 callbacks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165907261977.17632.11543137109685745518.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 05:30:19 +0000
References: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
In-Reply-To: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@nvidia.com,
        leon@kernel.org, tariqt@nvidia.com, edumazet@google.com,
        pabeni@redhat.com, jiri@nvidia.com, netdev@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Jul 2022 18:53:41 +0300 you wrote:
> Prepare mlx4 and mlx5 drivers to have all devlink callbacks called with
> devlink instance locked. Change mlx4 driver to use devl_ API where
> needed to have devlink reload callbacks locked. Change mlx5 driver to
> use devl_ API where needed to have devlink reload and devlink health
> callbacks locked.
> 
> As mlx5 is the only driver which needed changes to enable calling health
> callbacks with devlink instance locked, this patchset also removes
> DEVLINK_NL_FLAG_NO_LOCK flag from devlink health callbacks.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/9] net: devlink: remove region snapshot ID tracking dependency on devlink->lock
    https://git.kernel.org/netdev/net-next/c/5502e8712c9b
  - [net-next,v2,2/9] net: devlink: remove region snapshots list dependency on devlink->lock
    https://git.kernel.org/netdev/net-next/c/2dec18ad826f
  - [net-next,v2,3/9] net/mlx5: Move fw reset unload to mlx5_fw_reset_complete_reload
    https://git.kernel.org/netdev/net-next/c/c12f4c6ac3b4
  - [net-next,v2,4/9] net/mlx5: Lock mlx5 devlink reload callbacks
    https://git.kernel.org/netdev/net-next/c/84a433a40d0e
  - [net-next,v2,5/9] net/mlx4: Use devl_ API for devlink region create / destroy
    https://git.kernel.org/netdev/net-next/c/9cb7e94a78b5
  - [net-next,v2,6/9] net/mlx4: Use devl_ API for devlink port register / unregister
    https://git.kernel.org/netdev/net-next/c/a8c05514b2f8
  - [net-next,v2,7/9] net/mlx4: Lock mlx4 devlink reload callback
    https://git.kernel.org/netdev/net-next/c/60d7ceea4b2a
  - [net-next,v2,8/9] net/mlx5: Lock mlx5 devlink health recovery callback
    https://git.kernel.org/netdev/net-next/c/d3dbdc9f8ddc
  - [net-next,v2,9/9] devlink: Hold the instance lock in health callbacks
    https://git.kernel.org/netdev/net-next/c/c90005b5f75c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


