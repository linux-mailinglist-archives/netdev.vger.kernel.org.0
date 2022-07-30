Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD655858A6
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 06:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiG3EuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 00:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiG3EuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 00:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26919FD6
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 21:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 509DF60691
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 04:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A13D8C433D7;
        Sat, 30 Jul 2022 04:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659156614;
        bh=F7y9lSBDNgDKc0v3XQ7FNke38gTharI4oYwKiEXqip4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ic/8ah7nnrlq+LoLbQvfGAUgQHSl/AheqaM/+G6P4R0pBPgpUGSfqo1o0A28SVcl5
         tzzoaPd9Ki96Fkh/lIPO5u8AcAkZwHRonPxs5b16VsJBa/yJbJ3LWGV2m6WzSUib+U
         bQovPzgyH5R0c8FSeFF3pQFR1xDHlIaWzi+Gqru2rlltkFuzVVBosCMsJCcmeI9gvh
         H41aTw87X31ujaidYCW5n711PD4VF5OO3y+HoIF72CBJs+xGlnfdQ6fEau0g4b7TES
         dgtUhSg/2lHOUbnqIofKE9gQUrAzYS1+zZg2AhzGB6LqlWOY1CPaKDpim0Hj3QWEfk
         YlZ2HisbSEd5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86619C43140;
        Sat, 30 Jul 2022 04:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/9] net/mlx5e: Remove WARN_ON when trying to offload an
 unsupported TLS cipher/version
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165915661454.14353.17221040839604592491.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jul 2022 04:50:14 +0000
References: <20220728204640.139990-2-saeed@kernel.org>
In-Reply-To: <20220728204640.139990-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, gal@nvidia.com, maximmi@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 28 Jul 2022 13:46:32 -0700 you wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> The driver reports whether TX/RX TLS device offloads are supported, but
> not which ciphers/versions, these should be handled by returning
> -EOPNOTSUPP when .tls_dev_add() is called.
> 
> Remove the WARN_ON kernel trace when the driver gets a request to
> offload a cipher/version that is not supported as it is expected.
> 
> [...]

Here is the summary with links:
  - [net,1/9] net/mlx5e: Remove WARN_ON when trying to offload an unsupported TLS cipher/version
    https://git.kernel.org/netdev/net/c/115d9f95ea7a
  - [net,2/9] net/mlx5e: TC, Fix post_act to not match on in_port metadata
    https://git.kernel.org/netdev/net/c/903f2194f74b
  - [net,3/9] net/mlx5e: Fix the value of MLX5E_MAX_RQ_NUM_MTTS
    https://git.kernel.org/netdev/net/c/562696c3c62c
  - [net,4/9] net/mlx5e: xsk: Account for XSK RQ UMRs when calculating ICOSQ size
    https://git.kernel.org/netdev/net/c/52586d2f56b3
  - [net,5/9] net/mlx5e: Fix calculations related to max MPWQE size
    https://git.kernel.org/netdev/net/c/677e78c8d44f
  - [net,6/9] net/mlx5e: Modify slow path rules to go to slow fdb
    https://git.kernel.org/netdev/net/c/c0063a43700f
  - [net,7/9] net/mlx5: Adjust log_max_qp to be 18 at most
    https://git.kernel.org/netdev/net/c/a6e9085d791f
  - [net,8/9] net/mlx5: DR, Fix SMFS steering info dump format
    https://git.kernel.org/netdev/net/c/62d2664351ef
  - [net,9/9] net/mlx5: Fix driver use of uninitialized timeout
    https://git.kernel.org/netdev/net/c/42b4f7f66a43

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


