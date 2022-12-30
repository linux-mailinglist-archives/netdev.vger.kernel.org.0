Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D5B6595CA
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 08:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbiL3Hkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 02:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiL3HkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 02:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB92BD8
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 23:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A85061A5E
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 07:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79C59C433F0;
        Fri, 30 Dec 2022 07:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672386018;
        bh=zY4bracxqJf2usszJg0+2fUSCgigTg/bmQu29/gVS3Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tF7ABKBeNlD8nblVT5zUvAby/aCU3HNegc4ACamyRe0Y/qrm79lDPtVVatI4svXLb
         juaHgw50fPDiJc7eGeQs9WRVtD/CRNxE+UPsqklyyPgIaXi5vj2GjVI+oclozZBUWu
         u0ACcHV1WL7dyGLEnLQkwnD5XBjE6ldICc36ipt+YLF7KTnUTei6ALV1V43gOATFW4
         T5vaYywIKnC6QiDddGCc4D6JNhSAoHAz7O6SQa+ltmWsfC47BdNWMarYbrMaL59X8X
         K66mvlYhUxhclHtbf1lmriGiOD28fHTD5IiTmRdvO9aObYRfxlCkWvwJGJF/xv1owp
         grKWTKGOBAIpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5EF8FC395DF;
        Fri, 30 Dec 2022 07:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/12] net/mlx5: E-Switch,
 properly handle ingress tagged packets on VST
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167238601838.1408.541095940522692461.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Dec 2022 07:40:18 +0000
References: <20221228194331.70419-2-saeed@kernel.org>
In-Reply-To: <20221228194331.70419-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, moshe@nvidia.com, mbloch@nvidia.com
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

On Wed, 28 Dec 2022 11:43:20 -0800 you wrote:
> From: Moshe Shemesh <moshe@nvidia.com>
> 
> Fix SRIOV VST mode behavior to insert cvlan when a guest tag is already
> present in the frame. Previous VST mode behavior was to drop packets or
> override existing tag, depending on the device version.
> 
> In this patch we fix this behavior by correctly building the HW steering
> rule with a push vlan action, or for older devices we ask the FW to stack
> the vlan when a vlan is already present.
> 
> [...]

Here is the summary with links:
  - [net,01/12] net/mlx5: E-Switch, properly handle ingress tagged packets on VST
    https://git.kernel.org/netdev/net/c/1f0ae22ab470
  - [net,02/12] net/mlx5: Add forgotten cleanup calls into mlx5_init_once() error path
    https://git.kernel.org/netdev/net/c/2a35b2c2e6a2
  - [net,03/12] net/mlx5: Fix io_eq_size and event_eq_size params validation
    https://git.kernel.org/netdev/net/c/44aee8ea15ac
  - [net,04/12] net/mlx5: Avoid recovery in probe flows
    https://git.kernel.org/netdev/net/c/9078e843efec
  - [net,05/12] net/mlx5: Fix RoCE setting at HCA level
    https://git.kernel.org/netdev/net/c/c4ad5f2bdad5
  - [net,06/12] net/mlx5e: IPoIB, Don't allow CQE compression to be turned on by default
    https://git.kernel.org/netdev/net/c/b12d581e83e3
  - [net,07/12] net/mlx5e: Fix RX reporter for XSK RQs
    https://git.kernel.org/netdev/net/c/f8c18a5749cf
  - [net,08/12] net/mlx5e: CT: Fix ct debugfs folder name
    https://git.kernel.org/netdev/net/c/849190e3e4cc
  - [net,09/12] net/mlx5e: Always clear dest encap in neigh-update-del
    https://git.kernel.org/netdev/net/c/2951b2e142ec
  - [net,10/12] net/mlx5e: Fix hw mtu initializing at XDP SQ allocation
    https://git.kernel.org/netdev/net/c/1e267ab88dc4
  - [net,11/12] net/mlx5e: Set geneve_tlv_option_0_exist when matching on geneve option
    https://git.kernel.org/netdev/net/c/e54638a8380b
  - [net,12/12] net/mlx5: Lag, fix failure to cancel delayed bond work
    https://git.kernel.org/netdev/net/c/4d1c1379d717

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


