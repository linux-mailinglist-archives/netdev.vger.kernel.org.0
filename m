Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEC25E71E7
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 04:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiIWCaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 22:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiIWCaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 22:30:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4903A99D1
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 19:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56250B8204A
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 02:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DCD2C433C1;
        Fri, 23 Sep 2022 02:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663900218;
        bh=18ikXXy6jJoJ11FqRyv48qrphSc6ir93dQ3I3Nrtcg0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mNKjGCI5/CwvP4hUtDkw5lyEG5JPoC0nM8pSSJ7OYA5t3XwpM4AahcUhRIXd8l440
         7iCD6XlzPMXswso05aVQ141hKIllRrjAhM+1SeinwSclJAknSVYTZvYGa3RkC+Z+AC
         nfyqnA4aVjcZPYdMSf8Sh7nbeBMZmLr+8X9qluro+UwqPgu5GdSXNTiIyRcFmb6iFi
         EJoEB35SAS8Ki4APF/0jIAB/4czMr3+omF0+LAY7Yv39IF8LU2oIh2yxur/WFpaHyi
         b5wmcycadYFY+XvU9J9gInpgCrLudNEcegTlpvgsDlAyu9zSeThxXrdtYnwuHKNZVt
         CDBhM9r9elUQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1549E4D03C;
        Fri, 23 Sep 2022 02:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V3 00/10] mlx5 MACSec Extended packet number and
 replay window offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166390021791.22964.2008016071106720144.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 02:30:17 +0000
References: <20220921181054.40249-1-saeed@kernel.org>
In-Reply-To: <20220921181054.40249-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 21 Sep 2022 11:10:44 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> v2->v3:
>   - rebased
> 
> v1->v2:
>   - Fix 32bit build isse
>   - Replay protection can work without EPN being enabled so moved the code out
>     of the EPN enabled check
> 
> [...]

Here is the summary with links:
  - [net-next,V3,01/10] net: macsec: Expose extended packet number (EPN) properties to macsec offload
    https://git.kernel.org/netdev/net-next/c/0a6e9b718dbb
  - [net-next,V3,02/10] net/mlx5: Fix fields name prefix in MACsec
    https://git.kernel.org/netdev/net-next/c/21803630c4ff
  - [net-next,V3,03/10] net/mlx5e: Fix MACsec initialization error path
    https://git.kernel.org/netdev/net-next/c/6c5e0b25db3a
  - [net-next,V3,04/10] net/mlx5e: Fix MACsec initial packet number
    https://git.kernel.org/netdev/net-next/c/cb6d3c0f1bae
  - [net-next,V3,05/10] net/mlx5: Add ifc bits for MACsec extended packet number (EPN) and replay protection
    https://git.kernel.org/netdev/net-next/c/23cc83c6ca87
  - [net-next,V3,06/10] net/mlx5e: Expose memory key creation (mkey) function
    https://git.kernel.org/netdev/net-next/c/0e1e03c02f12
  - [net-next,V3,07/10] net/mlx5e: Create advanced steering operation (ASO) object for MACsec
    https://git.kernel.org/netdev/net-next/c/1f53da676439
  - [net-next,V3,08/10] net/mlx5e: Move MACsec initialization from profile init stage to profile enable stage
    https://git.kernel.org/netdev/net-next/c/3fd3fb6b6b88
  - [net-next,V3,09/10] net/mlx5e: Support MACsec offload extended packet number (EPN)
    https://git.kernel.org/netdev/net-next/c/4411a6c0abd3
  - [net-next,V3,10/10] net/mlx5e: Support MACsec offload replay window
    https://git.kernel.org/netdev/net-next/c/eb43846b43c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


