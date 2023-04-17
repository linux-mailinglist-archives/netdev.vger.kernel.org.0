Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D3E6E409C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjDQHUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjDQHUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:20:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC253C18
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 00:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ADC461F0D
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 07:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64334C4339B;
        Mon, 17 Apr 2023 07:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681716022;
        bh=2og6HuUvIAyjUHoh54skJXf6pR1Db9CjtkZe6Czqshk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nX75PZwZZ7D++gUMbb0ZY6PHaTICcZx9fMqMXKTvQXfhYptAfjc+CsJBKZfRq/eu3
         pPe9dXaoFSKLEp0/Y1LhDMwbJQNXBxAPBWlx31Hyv548Ej1bfoybZy5CYVAMHtF+eh
         bmvrCDBjC9Er8uxCtUbgDqdkmcBWltqEZL1DqA0zKCh1cvWIIsB6Uw0gFJ1hQNv92N
         F9/9HP8Er4apQu2FBg5hZakWxgu3kbMPYzMENxjw2mCw+3YZDffTfkPirfupmQpBqZ
         911pMkLTY1ZRG9E7v4VaEQevO5AiXnW/e+uIDjGzfsfV9fPQEh+bRhSY80teez7yFX
         pgUpxrBpfGerQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47D19E3309F;
        Mon, 17 Apr 2023 07:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: DR,
 Move ACTION_CACHE_LINE_SIZE macro to header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168171602229.1935.5518330974522513366.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Apr 2023 07:20:22 +0000
References: <20230414220939.136865-2-saeed@kernel.org>
In-Reply-To: <20230414220939.136865-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, kliteyn@nvidia.com, valex@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Fri, 14 Apr 2023 15:09:25 -0700 you wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> 
> Move ACTION_CACHE_LINE_SIZE macro to header to be used by
> the pattern functions as well.
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Alex Vesker <valex@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: DR, Move ACTION_CACHE_LINE_SIZE macro to header
    https://git.kernel.org/netdev/net-next/c/b47dddc624ef
  - [net-next,02/15] net/mlx5: DR, Add cache for modify header pattern
    https://git.kernel.org/netdev/net-next/c/da5d0027d666
  - [net-next,03/15] net/mlx5: DR, Split chunk allocation to HW-dependent ways
    https://git.kernel.org/netdev/net-next/c/2533e726f472
  - [net-next,04/15] net/mlx5: DR, Check for modify_header_argument device capabilities
    https://git.kernel.org/netdev/net-next/c/b7ba743a2f1c
  - [net-next,05/15] net/mlx5: DR, Add create/destroy for modify-header-argument general object
    https://git.kernel.org/netdev/net-next/c/de69696b6eee
  - [net-next,06/15] net/mlx5: DR, Add support for writing modify header argument
    https://git.kernel.org/netdev/net-next/c/4605fc0a2b65
  - [net-next,07/15] net/mlx5: DR, Read ICM memory into dedicated buffer
    https://git.kernel.org/netdev/net-next/c/7d7c9453d679
  - [net-next,08/15] net/mlx5: DR, Fix QP continuous allocation
    https://git.kernel.org/netdev/net-next/c/17dc71c336aa
  - [net-next,09/15] net/mlx5: DR, Add modify header arg pool mechanism
    https://git.kernel.org/netdev/net-next/c/608d4f1769d8
  - [net-next,10/15] net/mlx5: DR, Add modify header argument pointer to actions attributes
    https://git.kernel.org/netdev/net-next/c/0caebadda57b
  - [net-next,11/15] net/mlx5: DR, Apply new accelerated modify action and decapl3
    https://git.kernel.org/netdev/net-next/c/62e40c856825
  - [net-next,12/15] net/mlx5: DR, Support decap L3 action using pattern / arg mechanism
    https://git.kernel.org/netdev/net-next/c/947e258537ea
  - [net-next,13/15] net/mlx5: DR, Modify header action of size 1 optimization
    https://git.kernel.org/netdev/net-next/c/40ff097f2503
  - [net-next,14/15] net/mlx5: DR, Add support for the pattern/arg parameters in debug dump
    https://git.kernel.org/netdev/net-next/c/a21e52bb8f37
  - [net-next,15/15] net/mlx5: DR, Enable patterns and arguments for supporting devices
    https://git.kernel.org/netdev/net-next/c/220ae987838c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


