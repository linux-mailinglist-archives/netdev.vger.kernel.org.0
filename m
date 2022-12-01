Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9FD63E9F2
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 07:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiLAGkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 01:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiLAGkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 01:40:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DDE66C83
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 22:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45D0261EB3
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 06:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5115CC433D7;
        Thu,  1 Dec 2022 06:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669876819;
        bh=MObo5mpaq0RdZ1CizwCMYCImEBVgYvGiqPpgJyfFkBY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sX/2eYlDd8L9xKDS1TbyyZNp573Pxs42wY4CxIwYx8Zh6IcKgMqTnSODK2lWpWjCH
         xJAuFZcrGTT3q8WN+ndYCM916FNVhbYt+8JsZVPHXtHfYWekt4O9UNq8kiqd0OLA+Q
         mFuOQyzE9D/UqqAV82XMHBnKAMeLEN53kVMfUhE+p4WduMwhAOSey/u+UKqsf0OIgH
         M0tmDSxJErpsyYsTwBdms7Tk0ay18vU6xoE3l+hfk5d6K27iHUdMfBqYVaNZE0+qQM
         vZrUSHxrVmh2Q8BX/5aLLT5ejDtalJxHdinlawdCR76LsjUxJgPdORc2KouY2BOftY
         gWaQy1MU1yCsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 32994E29F38;
        Thu,  1 Dec 2022 06:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5e: Remove unneeded io-mapping.h #include
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166987681920.1827.16257138477985513331.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 06:40:19 +0000
References: <20221130051152.479480-2-saeed@kernel.org>
In-Reply-To: <20221130051152.479480-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, christophe.jaillet@wanadoo.fr,
        pavan.chebbi@broadcom.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 29 Nov 2022 21:11:38 -0800 you wrote:
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> The mlx5 net files don't use io_mapping functionalities. So there is no
> point in including <linux/io-mapping.h>.
> Remove it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: Remove unneeded io-mapping.h #include
    https://git.kernel.org/netdev/net-next/c/02ca1732f41b
  - [net-next,02/15] net/mlx5e: Replace zero-length arrays with DECLARE_FLEX_ARRAY() helper
    https://git.kernel.org/netdev/net-next/c/5df5365ae4f7
  - [net-next,03/15] net/mlx5: Remove unused ctx variables
    https://git.kernel.org/netdev/net-next/c/12eb0f84a601
  - [net-next,04/15] net/mlx5e: Add padding when needed in UMR WQEs
    https://git.kernel.org/netdev/net-next/c/b146658f2ed9
  - [net-next,05/15] net/mlx5: Remove unused UMR MTT definitions
    https://git.kernel.org/netdev/net-next/c/683d78a0d462
  - [net-next,06/15] net/mlx5: Generalize name of UMR alignment definition
    https://git.kernel.org/netdev/net-next/c/02648b4b09d5
  - [net-next,07/15] net/mlx5: Use generic definition for UMR KLM alignment
    https://git.kernel.org/netdev/net-next/c/daab2e9c54a5
  - [net-next,08/15] net/mlx5: Fix orthography errors in documentation
    https://git.kernel.org/netdev/net-next/c/2d04e1ce52a8
  - [net-next,09/15] net/mlx5e: Don't use termination table when redundant
    https://git.kernel.org/netdev/net-next/c/14624d7247fc
  - [net-next,10/15] net/mlx5e: Don't access directly DMA device pointer
    https://git.kernel.org/netdev/net-next/c/7c11eae2fdc8
  - [net-next,11/15] net/mlx5e: Delete always true DMA check
    https://git.kernel.org/netdev/net-next/c/d11c0ec2b831
  - [net-next,12/15] net/mlx5: Remove redundant check
    https://git.kernel.org/netdev/net-next/c/3c683429b078
  - [net-next,13/15] net/mlx5e: Do early return when setup vports dests for slow path flow
    https://git.kernel.org/netdev/net-next/c/42760d95a0c1
  - [net-next,14/15] net/mlx5e: TC, Add offload support for trap with additional actions
    https://git.kernel.org/netdev/net-next/c/dcf19b9ce4fd
  - [net-next,15/15] net/mlx5e: Support devlink reload of IPsec core
    https://git.kernel.org/netdev/net-next/c/953d771587e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


