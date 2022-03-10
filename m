Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB704D54DB
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344480AbiCJWvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344478AbiCJWvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:51:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3680FEBB9B
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4B3EB82916
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 22:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BA0AC340E9;
        Thu, 10 Mar 2022 22:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646952614;
        bh=5wfUze1f2QePkvQOx46oj8h6iAphJmsPoFgen2cNKd0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CIXp0iDdrSlf5GLNi+hp73w1e/dUHAX/R+0lkhS9yV1a5lSHWl+93AbMA0rtSQ8zO
         pNCefhDtSH36skZNzaM0wGpKtwnF2JK8LgieNUw7zJJEZabz2u5mjHErnk9EMXfnbO
         dbshkittyrCd7T17XgeCMHr32VXtuvFH7p5Ow3I6fhEiHBL3wmlShDvhdkhcJjhe+H
         OB7rq0KHJvr3DyuwtlobqAABCyOJ77meQcuHJyB/H2JXaz2RyOcDt0VP5RtgilUo6k
         npO0XUre8E9sPA+Sz1g+qdZ3K6aexmG6fc6Xh5y1vbQ7pLLuRU8yTilt1xjygIGxlK
         W24qUaNfj8d+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73E75E8DD5B;
        Thu, 10 Mar 2022 22:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/16] net/mlx5e: TC,
 Fix use after free in mlx5e_clone_flow_attr_for_post_act()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164695261447.1555.9085815435694091848.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 22:50:14 +0000
References: <20220309213755.610202-2-saeed@kernel.org>
In-Reply-To: <20220309213755.610202-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com, roid@nvidia.com, saeedm@nvidia.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  9 Mar 2022 13:37:40 -0800 you wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> This returns freed memory leading to a use after free.  It's supposed to
> return NULL.
> 
> Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/16] net/mlx5e: TC, Fix use after free in mlx5e_clone_flow_attr_for_post_act()
    https://git.kernel.org/netdev/net-next/c/371c2b349d92
  - [net-next,02/16] net/mlx5: Add command failures data to debugfs
    https://git.kernel.org/netdev/net-next/c/34f46ae0d4b3
  - [net-next,03/16] net/mlx5: Remove redundant notify fail on give pages
    https://git.kernel.org/netdev/net-next/c/4dac2f10ada0
  - [net-next,04/16] net/mlx5: Remove redundant error on give pages
    https://git.kernel.org/netdev/net-next/c/113fdaaad75a
  - [net-next,05/16] net/mlx5: Remove redundant error on reclaim pages
    https://git.kernel.org/netdev/net-next/c/8d564292a166
  - [net-next,06/16] net/mlx5: Change release_all_pages cap bit location
    https://git.kernel.org/netdev/net-next/c/d2cb8dda214f
  - [net-next,07/16] net/mlx5: Move debugfs entries to separate struct
    https://git.kernel.org/netdev/net-next/c/66771a1c729e
  - [net-next,08/16] net/mlx5: Add pages debugfs
    https://git.kernel.org/netdev/net-next/c/4e05cbf05c66
  - [net-next,09/16] net/mlx5: Add debugfs counters for page commands failures
    https://git.kernel.org/netdev/net-next/c/32071187e9fb
  - [net-next,10/16] net/mlx5: DR, Align mlx5dv_dr API vport action with FW behavior
    https://git.kernel.org/netdev/net-next/c/aa818fbf8f36
  - [net-next,11/16] net/mlx5: DR, Add support for matching on Internet Header Length (IHL)
    https://git.kernel.org/netdev/net-next/c/5c422bfad2fb
  - [net-next,12/16] net/mlx5: DR, Remove unneeded comments
    https://git.kernel.org/netdev/net-next/c/11659ef8d28e
  - [net-next,13/16] net/mlx5: DR, Fix handling of different actions on the same STE in STEv1
    https://git.kernel.org/netdev/net-next/c/bdc3ab5795a6
  - [net-next,14/16] net/mlx5: DR, Rename action modify fields to reflect naming in HW spec
    https://git.kernel.org/netdev/net-next/c/75a3926ca6a4
  - [net-next,15/16] net/mlx5: DR, Refactor ste_ctx handling for STE v0/1
    https://git.kernel.org/netdev/net-next/c/638a07f1090e
  - [net-next,16/16] net/mlx5: DR, Add support for ConnectX-7 steering
    https://git.kernel.org/netdev/net-next/c/6862c787c7e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


