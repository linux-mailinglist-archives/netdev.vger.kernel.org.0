Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA5D698B34
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 04:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjBPDa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 22:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBPDaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 22:30:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C9229161
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 19:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38420B8254D
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 03:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDDF1C433A1;
        Thu, 16 Feb 2023 03:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676518222;
        bh=pxO564Gz4ywAd8Je7jQFDebLQZqOftaX7VWjxAm786s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HzsJBPq/ciuRyawL8AdfCIMK3pbbsAyywd1PI0xDy8UTmyZiTZ9KmhkBRHoM5nVvb
         c+zQGhwbGXI1ciQFm5PAyBTC8sAtPQls0xpPZATYgyO6MR4AwUQtCcbyTKEWCyLbEc
         BpDfjZkwX6tiaSY0yHoM7lDe2LhpzENSDp9flXcsVvMPZueaZxDCFfTnIW4Ys4edn5
         g8TKQWkav4R8JmpUgqHQYNF4u2HWk9sehNxdxLtPJZmJtUvJ/mkgw7GEriPCNZ7uKO
         bTQEALkDpEnA+liJ5NaP0YfWuDctD1/6ody9qYhS11pAezHGpJy/j9A6cFjYNwKqHd
         FBTbzAbloGQGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB2D0E68D39;
        Thu, 16 Feb 2023 03:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next V2 01/15] net/mlx5: Lag,
 Control MultiPort E-Switch single FDB mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167651822189.29240.3697186307841113480.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 03:30:21 +0000
References: <20230214221239.159033-2-saeed@kernel.org>
In-Reply-To: <20230214221239.159033-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, roid@nvidia.com, maord@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 14 Feb 2023 14:12:25 -0800 you wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> MultiPort E-Switch builds on newer hardware's capabilities and introduces
> a mode where a single E-Switch is used and all the vports and physical
> ports on the NIC are connected to it.
> 
> The new mode will allow in the future a decrease in the memory used by the
> driver and advanced features that aren't possible today.
> 
> [...]

Here is the summary with links:
  - [net-next,V2,01/15] net/mlx5: Lag, Control MultiPort E-Switch single FDB mode
    https://git.kernel.org/netdev/net-next/c/a32327a3a02c
  - [net-next,V2,02/15] net/mlx5e: TC, Add peer flow in mpesw mode
    https://git.kernel.org/netdev/net-next/c/8ce81fc01b52
  - [net-next,V2,03/15] net/mlx5: E-Switch, rename bond update function to be reused
    https://git.kernel.org/netdev/net-next/c/ab9fc405ffd9
  - [net-next,V2,04/15] net/mlx5: Lag, set different uplink vport metadata in multiport eswitch mode
    https://git.kernel.org/netdev/net-next/c/73af3711c702
  - [net-next,V2,05/15] net/mlx5: Lag, Add single RDMA device in multiport mode
    https://git.kernel.org/netdev/net-next/c/27f9e0ccb6da
  - [net-next,V2,06/15] net/mlx5e: Use a simpler comparison for uplink rep
    https://git.kernel.org/netdev/net-next/c/197c00029294
  - [net-next,V2,07/15] net/mlx5e: TC, Remove redundant parse_attr argument
    https://git.kernel.org/netdev/net-next/c/b97653d87bda
  - [net-next,V2,08/15] net/mlx5: Remove outdated comment
    https://git.kernel.org/netdev/net-next/c/29a299cb6b20
  - [net-next,V2,09/15] net/mlx5e: Pass mdev to mlx5e_devlink_port_register()
    https://git.kernel.org/netdev/net-next/c/ccd672bcf3e5
  - [net-next,V2,10/15] net/mlx5e: Replace usage of mlx5e_devlink_get_dl_port() by netdev->devlink_port
    https://git.kernel.org/netdev/net-next/c/bc1536f369f0
  - [net-next,V2,11/15] net/mlx5e: Move dl_port to struct mlx5e_dev
    https://git.kernel.org/netdev/net-next/c/c30f3faa2a81
  - [net-next,V2,12/15] net/mlx5e: Move devlink port registration to be done before netdev alloc
    https://git.kernel.org/netdev/net-next/c/6d6e71e6e5e3
  - [net-next,V2,13/15] net/mlx5e: Create auxdev devlink instance in the same ns as parent devlink
    https://git.kernel.org/netdev/net-next/c/de411a8226df
  - [net-next,V2,14/15] net/mlx5: Remove "recovery" arg from mlx5_load_one() function
    https://git.kernel.org/netdev/net-next/c/5977ac3910f1
  - [net-next,V2,15/15] net/mlx5: Suspend auxiliary devices only in case of PCI device suspend
    https://git.kernel.org/netdev/net-next/c/72ed5d5624af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


