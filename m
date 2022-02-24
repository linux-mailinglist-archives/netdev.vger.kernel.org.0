Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD30B4C2319
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 05:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiBXEkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 23:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiBXEkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 23:40:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F14B20B3AD
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 20:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEF5E6178F
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 04:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 159E2C340EF;
        Thu, 24 Feb 2022 04:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645677615;
        bh=TgLh/TG904rA7c0fs7BKavsNSB8M6vPKk7vPFo6PACs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N7eksRMyxJ1qWPPABXW8qwh3rE89ffrWqgRWSAl+mgU1qW574/DMZEJXU1AAnjS0D
         KjGq1BrtrwlukuQsZJI5S0gz3CdsEuVlRDDFMxB1dnOPz4tNZnWDjuazwjmDDUa2SN
         7vAzbjgPiOfROW8mCj6Bmr2Gk8l/Y7RZwtWGkELDBzx34eYZBQXrSo5gt5ZtqpumlS
         kP01rNfmdq/OTCisRK3AnYtk8xUYgID4SXt1JyWUJo0nI0qtwwAGkPuB/QCp4MybxZ
         DNItH/KHjE2VJjgyMqW3Vr74gFTp5duZot9Fv77SRtosI1PoKpEqD54EGl0NPECxFG
         RclZ1uNow4RWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE685EAC096;
        Thu, 24 Feb 2022 04:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [v2 net 01/19] net/mlx5: Update the list of the PCI supported devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164567761497.18817.13199817664246956659.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Feb 2022 04:40:14 +0000
References: <20220224001123.365265-2-saeed@kernel.org>
In-Reply-To: <20220224001123.365265-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        meirl@nvidia.com, gal@nvidia.com, tariqt@nvidia.com,
        saeedm@nvidia.com
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

On Wed, 23 Feb 2022 16:11:05 -0800 you wrote:
> From: Meir Lichtinger <meirl@nvidia.com>
> 
> Add the upcoming BlueField-4 and ConnectX-8 device IDs.
> 
> Fixes: 2e9d3e83ab82 ("net/mlx5: Update the list of the PCI supported devices")
> Signed-off-by: Meir Lichtinger <meirl@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [v2,net,01/19] net/mlx5: Update the list of the PCI supported devices
    https://git.kernel.org/netdev/net/c/f908a35b2218
  - [v2,net,02/19] net/mlx5: DR, Cache STE shadow memory
    https://git.kernel.org/netdev/net/c/e5b2bc30c211
  - [v2,net,03/19] net/mlx5: DR, Fix slab-out-of-bounds in mlx5_cmd_dr_create_fte
    https://git.kernel.org/netdev/net/c/0aec12d97b20
  - [v2,net,04/19] net/mlx5: DR, Don't allow match on IP w/o matching on full ethertype/ip_version
    https://git.kernel.org/netdev/net/c/ffb0753b9547
  - [v2,net,05/19] net/mlx5: DR, Fix the threshold that defines when pool sync is initiated
    https://git.kernel.org/netdev/net/c/ecd9c5cd46e0
  - [v2,net,06/19] net/mlx5: Update log_max_qp value to be 17 at most
    https://git.kernel.org/netdev/net/c/7f839965b2d7
  - [v2,net,07/19] net/mlx5: Fix wrong limitation of metadata match on ecpf
    https://git.kernel.org/netdev/net/c/07666c75ad17
  - [v2,net,08/19] net/mlx5: Fix tc max supported prio for nic mode
    https://git.kernel.org/netdev/net/c/be7f4b0ab149
  - [v2,net,09/19] net/mlx5: Fix possible deadlock on rule deletion
    https://git.kernel.org/netdev/net/c/b645e57debca
  - [v2,net,10/19] net/mlx5e: Fix wrong return value on ioctl EEPROM query failure
    https://git.kernel.org/netdev/net/c/0b8942972235
  - [v2,net,11/19] net/mlx5e: kTLS, Use CHECKSUM_UNNECESSARY for device-offloaded packets
    https://git.kernel.org/netdev/net/c/7eaf1f37b881
  - [v2,net,12/19] net/mlx5e: TC, Reject rules with drop and modify hdr action
    https://git.kernel.org/netdev/net/c/23216d387c40
  - [v2,net,13/19] net/mlx5e: TC, Reject rules with forward and drop actions
    https://git.kernel.org/netdev/net/c/3d65492a86d4
  - [v2,net,14/19] net/mlx5e: TC, Skip redundant ct clear actions
    https://git.kernel.org/netdev/net/c/fb7e76ea3f3b
  - [v2,net,15/19] net/mlx5e: Add feature check for set fec counters
    https://git.kernel.org/netdev/net/c/7fac05290380
  - [v2,net,16/19] net/mlx5e: Fix MPLSoUDP encap to use MPLS action information
    https://git.kernel.org/netdev/net/c/c63741b426e1
  - [v2,net,17/19] net/mlx5e: MPLSoUDP decap, fix check for unsupported matches
    https://git.kernel.org/netdev/net/c/fdc18e4e4bde
  - [v2,net,18/19] net/mlx5e: Add missing increment of count
    https://git.kernel.org/netdev/net/c/5ee02b7a8006
  - [v2,net,19/19] net/mlx5e: Fix VF min/max rate parameters interchange mistake
    https://git.kernel.org/netdev/net/c/ca49df96f9f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


