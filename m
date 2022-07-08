Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241DE56AF95
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbiGHBAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 21:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236735AbiGHBAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 21:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9151E26134
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 18:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47A70B824B6
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 01:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2966C3411E;
        Fri,  8 Jul 2022 01:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657242016;
        bh=FsKURgf5qWeTDsS3evAWv8sYT6pXntbMd+dmmutq674=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kl0xoJWbf4shLRGDcbZAxFmhNz0SKFOcRHPqGeYPQuw9gIJZ5Fd1XCleMqEGKk0Ya
         sIqwPqXoj7u8pQTFRl9UY9hC+4bOmR6kVdDaO126C4XztauDB2HB9PbJB3VvFmee5q
         1aL3PNZmuXmYE8yED215bJzPG1BOW67w12RoWd4xI3emPbOvnroLyAlcr8Pr24ufmn
         IPZ3UXfn6Wu1eA3qVgCxFjXKPhn/YcnhR3omz69M0wmJ8IK+utf4Nkf+4YZkfC6LFy
         dYE+RxnipVfSV5U0HYgr43OiHhWMVblE1JQe6aANRJBrC1Psa2/Sk0O115NXX1Zp8E
         1DVJekr7BcBuw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DECCDE45BDA;
        Fri,  8 Jul 2022 01:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/9] net/mlx5: TC, allow offload from uplink to other PF's VF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165724201590.26389.17738345938373719550.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 01:00:15 +0000
References: <20220706231309.38579-2-saeed@kernel.org>
In-Reply-To: <20220706231309.38579-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        elic@nvidia.com, maord@nvidia.com, mbloch@nvidia.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  6 Jul 2022 16:13:01 -0700 you wrote:
> From: Eli Cohen <elic@nvidia.com>
> 
> Redirecting traffic from uplink to a VF is a legal operation of
> mulitport eswitch mode. Remove the limitation.
> 
> Fixes: 94db33177819 ("net/mlx5: Support multiport eswitch mode")
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,1/9] net/mlx5: TC, allow offload from uplink to other PF's VF
    https://git.kernel.org/netdev/net/c/d6c13d74b5c0
  - [net,2/9] net/mlx5: Lag, decouple FDB selection and shared FDB
    https://git.kernel.org/netdev/net/c/4892bd9830c3
  - [net,3/9] net/mlx5e: kTLS, Fix build time constant test in TX
    https://git.kernel.org/netdev/net/c/6cc2714e8575
  - [net,4/9] net/mlx5e: kTLS, Fix build time constant test in RX
    https://git.kernel.org/netdev/net/c/2ec6cf9b742a
  - [net,5/9] net/mlx5e: Fix enabling sriov while tc nic rules are offloaded
    https://git.kernel.org/netdev/net/c/0c9d876545a5
  - [net,6/9] net/mlx5: Lag, correct get the port select mode str
    https://git.kernel.org/netdev/net/c/1afbd1e283d6
  - [net,7/9] net/mlx5e: CT: Use own workqueue instead of mlx5e priv
    https://git.kernel.org/netdev/net/c/6c4e8fa03fde
  - [net,8/9] net/mlx5e: Fix capability check for updating vnic env counters
    https://git.kernel.org/netdev/net/c/452133dd5808
  - [net,9/9] net/mlx5e: Ring the TX doorbell on DMA errors
    https://git.kernel.org/netdev/net/c/5b759bf2f9d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


