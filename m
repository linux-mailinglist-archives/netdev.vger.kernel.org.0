Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CF1634F4A
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 06:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbiKWFA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 00:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiKWFAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 00:00:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8EDE675D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 21:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AA056CE2083
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 05:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5D9CC433C1;
        Wed, 23 Nov 2022 05:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179619;
        bh=nXxzYnakUwTedDD4+i0VTrIdN0bZRvlZR0KvH728uWY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RUTGAhuw17mr1hxCnbkdQ3anoOMDMWbyWLu44uMWKoFu8VSnunASO1ATdM7NvuKRi
         O7LpgzGznVNnkX2IeQdDIedF/V/RSoQe/leNqpRmyckDMaxKY7hT67bjlGx7zp0Hn5
         av3cgBb+hRzYGdUzigujK23RAcjgxpNbPFwVfjoCJtH5er4s19r64g223fB8EuN/J0
         Iej1bFkrtJvMBiBwqpIoiXaXpuMN5SJMooWzpW2WDDEtlecTDo8PuDLDzR6BJPV3w2
         mNYl9/Yy4JKrgI0HT8mJnmogQ4815jKw6oK+aMy7c7OSAmRmUkQlzFr7CyupTP1YUe
         VVW6sk5fZ0y9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F733C395F0;
        Wed, 23 Nov 2022 05:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/14] net/mlx5: Do not query pci info while pci disabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166917961964.4515.3606365128327297591.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 05:00:19 +0000
References: <20221122022559.89459-2-saeed@kernel.org>
In-Reply-To: <20221122022559.89459-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, royno@nvidia.com, moshe@nvidia.com,
        ayal@nvidia.com
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

On Mon, 21 Nov 2022 18:25:46 -0800 you wrote:
> From: Roy Novich <royno@nvidia.com>
> 
> The driver should not interact with PCI while PCI is disabled. Trying to
> do so may result in being unable to get vital signs during PCI reset,
> driver gets timed out and fails to recover.
> 
> Fixes: fad1783a6d66 ("net/mlx5: Print more info on pci error handlers")
> Signed-off-by: Roy Novich <royno@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Aya Levin <ayal@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,01/14] net/mlx5: Do not query pci info while pci disabled
    https://git.kernel.org/netdev/net/c/394164f9d5a3
  - [net,02/14] net/mlx5: Fix FW tracer timestamp calculation
    https://git.kernel.org/netdev/net/c/61db3d7b99a3
  - [net,03/14] net/mlx5: SF: Fix probing active SFs during driver probe phase
    https://git.kernel.org/netdev/net/c/4f57332d6a55
  - [net,04/14] net/mlx5: cmdif, Print info on any firmware cmd failure to tracepoint
    https://git.kernel.org/netdev/net/c/870c2481174b
  - [net,05/14] net/mlx5: Fix handling of entry refcount when command is not issued to FW
    https://git.kernel.org/netdev/net/c/aaf2e65cac7f
  - [net,06/14] net/mlx5: Lag, avoid lockdep warnings
    https://git.kernel.org/netdev/net/c/0d4e8ed139d8
  - [net,07/14] net/mlx5: E-Switch, Set correctly vport destination
    https://git.kernel.org/netdev/net/c/6d942e404489
  - [net,08/14] net/mlx5: Fix sync reset event handler error flow
    https://git.kernel.org/netdev/net/c/e1ad07b9227f
  - [net,09/14] net/mlx5e: Fix missing alignment in size of MTT/KLM entries
    https://git.kernel.org/netdev/net/c/3e874cb1e0a3
  - [net,10/14] net/mlx5e: Offload rule only when all encaps are valid
    https://git.kernel.org/netdev/net/c/f377422044b2
  - [net,11/14] net/mlx5e: Remove leftovers from old XSK queues enumeration
    https://git.kernel.org/netdev/net/c/11abca031ee3
  - [net,12/14] net/mlx5e: Fix MACsec SA initialization routine
    https://git.kernel.org/netdev/net/c/d20a56b0eb00
  - [net,13/14] net/mlx5e: Fix MACsec update SecY
    https://git.kernel.org/netdev/net/c/94ffd6e0c7db
  - [net,14/14] net/mlx5e: Fix possible race condition in macsec extended packet number update routine
    https://git.kernel.org/netdev/net/c/8514e325ef01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


