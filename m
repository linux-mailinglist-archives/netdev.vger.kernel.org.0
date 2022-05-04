Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2EF519C97
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 12:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347903AbiEDKOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 06:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347968AbiEDKOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 06:14:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23915F51
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 03:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68870B824B0
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 10:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25E38C385AF;
        Wed,  4 May 2022 10:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651659022;
        bh=kFXAksx68QFVzk5qnqgCw4UeItZ+VhljGQGjquvr9A0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AFHF98c/e3c0Q0mgw9OPGl8WFzNu2MWc0JB7TjRliMN93sG2UidfQjZtdfBK/Skpe
         OJEgLzvnwtXewRiCjwp06/kRBuNvWV3PUuFdriI6j1YaTiIykgLv36u4n+/odFlJQD
         m3TaUvRVZV00ph8V2yBP7o+WPMJd606YUB7czVUBv46jj0BXB7DtRC5Gy1tbgjzK9c
         sYqz/s52xHC3cVukL5VbbCLTJRzBqMaFAmQ75jBTFqiLvaY8wlDMR+n/Ts/tvOq6uR
         4+Gd9GxPnWd/ZCcBhANE/AQ4jWisqYuKfPG6QLcurHK/FhFprNIap8kfsClb/FgEs3
         IOM6q7AVdw/rg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0616BF03870;
        Wed,  4 May 2022 10:10:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/17] net/mlx5: Simplify IPsec flow steering init/cleanup
 functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165165902202.16679.2326363352718717936.git-patchwork-notify@kernel.org>
Date:   Wed, 04 May 2022 10:10:22 +0000
References: <20220504060231.668674-2-saeedm@nvidia.com>
In-Reply-To: <20220504060231.668674-2-saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, leonro@nvidia.com, raeds@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  3 May 2022 23:02:15 -0700 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Remove multiple function wrappers to make sure that IPsec FS initialization
> and cleanup functions present in one place to help with code readability.
> 
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/17] net/mlx5: Simplify IPsec flow steering init/cleanup functions
    https://git.kernel.org/netdev/net-next/c/301e0be800be
  - [net-next,02/17] net/mlx5: Check IPsec TX flow steering namespace in advance
    https://git.kernel.org/netdev/net-next/c/9af1968ee13b
  - [net-next,03/17] net/mlx5: Don't hide fallback to software IPsec in FS code
    https://git.kernel.org/netdev/net-next/c/021a429bdbde
  - [net-next,04/17] net/mlx5: Reduce useless indirection in IPsec FS add/delete flows
    https://git.kernel.org/netdev/net-next/c/a05a54694e40
  - [net-next,05/17] net/mlx5: Store IPsec ESN update work in XFRM state
    https://git.kernel.org/netdev/net-next/c/c674df973ad8
  - [net-next,06/17] net/mlx5: Remove useless validity check
    https://git.kernel.org/netdev/net-next/c/2ea36e2e4ad2
  - [net-next,07/17] net/mlx5: Merge various control path IPsec headers into one file
    https://git.kernel.org/netdev/net-next/c/c6e3b421c707
  - [net-next,08/17] net/mlx5: Remove indirections from esp functions
    https://git.kernel.org/netdev/net-next/c/a534e24d720f
  - [net-next,09/17] net/mlx5: Simplify HW context interfaces by using SA entry
    https://git.kernel.org/netdev/net-next/c/b73e67287b80
  - [net-next,10/17] net/mlx5: Clean IPsec FS add/delete rules
    https://git.kernel.org/netdev/net-next/c/82f7bdba3775
  - [net-next,11/17] net/mlx5: Make sure that no dangling IPsec FS pointers exist
    https://git.kernel.org/netdev/net-next/c/b7242ffc562c
  - [net-next,12/17] net/mlx5: Don't advertise IPsec netdev support for non-IPsec device
    https://git.kernel.org/netdev/net-next/c/a8444b0bdd1a
  - [net-next,13/17] net/mlx5: Simplify IPsec capabilities logic
    https://git.kernel.org/netdev/net-next/c/effbe2675165
  - [net-next,14/17] net/mlx5: Remove not-supported ICV length
    https://git.kernel.org/netdev/net-next/c/1c4a59b9fa98
  - [net-next,15/17] net/mlx5: Cleanup XFRM attributes struct
    https://git.kernel.org/netdev/net-next/c/6cd2126ac602
  - [net-next,16/17] net/mlx5: Don't perform lookup after already known sec_path
    https://git.kernel.org/netdev/net-next/c/bd24d1ffb445
  - [net-next,17/17] net/mlx5: Allow future addition of IPsec object modifiers
    https://git.kernel.org/netdev/net-next/c/656d33890732

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


