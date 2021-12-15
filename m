Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AB3475B0B
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 15:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243412AbhLOOuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 09:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243365AbhLOOuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 09:50:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCEA4C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 06:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80F3FB81F53
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 14:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C3BAC34606;
        Wed, 15 Dec 2021 14:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639579812;
        bh=HDx+TjFo78q2tsUARw84hnRjrVsukYILZ4NTpCo0foA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r6JPpa5gMcXnoYBiJvryWqLaRES02K/38J2JqgA+tYDHIgxULtYgtQ54L8YJGiCub
         xTOzbayOs509j+M6h4K5uA7nRe8VoF/gyxFETIIN0jfk+VwmONwMmENvi5Ox/ptXlc
         hqRyCTqwNDIoa90v43zbw8HEWWtqU68d+FPRXTnMhVcgB3J8CiXluPQO1kjN9/tdPt
         0NSupmDiFUzfFBhumP1jo/2wFMq/I+tgDM2e32AM4vcgSxXKhZitZCKxIXw4mz9Dqw
         Ut0rNWKdpaUp0s3k8EdrQGsafo+VyG8LcgMfwlYTb5pUNta9JV1uZY0iAh+BY4wKIg
         mOJ93/JbTlVvA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 216BC60A4F;
        Wed, 15 Dec 2021 14:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v0 01/16] net/mlx5e: Add tc action infrastructure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163957981213.14546.11998485762382827498.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 14:50:12 +0000
References: <20211215053300.130679-2-saeed@kernel.org>
In-Reply-To: <20211215053300.130679-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        roid@nvidia.com, ozsh@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 14 Dec 2021 21:32:45 -0800 you wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> Add an infrastructure to help parsing tc actions in a generic way.
> 
> Supporting an action parser means implementing struct mlx5e_tc_act
> for that action.
> 
> [...]

Here is the summary with links:
  - [net-next,v0,01/16] net/mlx5e: Add tc action infrastructure
    https://git.kernel.org/netdev/net-next/c/fad547906980
  - [net-next,v0,02/16] net/mlx5e: Add goto to tc action infra
    https://git.kernel.org/netdev/net-next/c/67d62ee7f46b
  - [net-next,v0,03/16] net/mlx5e: Add tunnel encap/decap to tc action infra
    https://git.kernel.org/netdev/net-next/c/c65686d79c95
  - [net-next,v0,04/16] net/mlx5e: Add csum to tc action infra
    https://git.kernel.org/netdev/net-next/c/9ca1bb2cf69b
  - [net-next,v0,05/16] net/mlx5e: Add pedit to tc action infra
    https://git.kernel.org/netdev/net-next/c/e36db1ee7a88
  - [net-next,v0,06/16] net/mlx5e: Add vlan push/pop/mangle to tc action infra
    https://git.kernel.org/netdev/net-next/c/8ee72638347c
  - [net-next,v0,07/16] net/mlx5e: Add mpls push/pop to tc action infra
    https://git.kernel.org/netdev/net-next/c/163b766f5662
  - [net-next,v0,08/16] net/mlx5e: Add mirred/redirect to tc action infra
    https://git.kernel.org/netdev/net-next/c/ab3f3d5efffa
  - [net-next,v0,09/16] net/mlx5e: Add ct to tc action infra
    https://git.kernel.org/netdev/net-next/c/758bc1342277
  - [net-next,v0,10/16] net/mlx5e: Add sample and ptype to tc_action infra
    https://git.kernel.org/netdev/net-next/c/3929ff583d8e
  - [net-next,v0,11/16] net/mlx5e: Add redirect ingress to tc action infra
    https://git.kernel.org/netdev/net-next/c/922d69ed9666
  - [net-next,v0,12/16] net/mlx5e: TC action parsing loop
    https://git.kernel.org/netdev/net-next/c/8333d53e3f74
  - [net-next,v0,13/16] net/mlx5e: Move sample attr allocation to tc_action sample parse op
    https://git.kernel.org/netdev/net-next/c/6bcba1bdeda5
  - [net-next,v0,14/16] net/mlx5e: Add post_parse() op to tc action infrastructure
    https://git.kernel.org/netdev/net-next/c/dd5ab6d11565
  - [net-next,v0,15/16] net/mlx5e: Move vlan action chunk into tc action vlan post parse op
    https://git.kernel.org/netdev/net-next/c/c22080352ecf
  - [net-next,v0,16/16] net/mlx5e: Move goto action checks into tc_action goto post parse op
    https://git.kernel.org/netdev/net-next/c/35bb5242148f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


