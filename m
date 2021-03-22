Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78C2345128
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhCVUuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230259AbhCVUuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 49A62619A4;
        Mon, 22 Mar 2021 20:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616446210;
        bh=/JcdPapT+PJMRUUV5p7cCgNExCaXSs1Rseksk5oNQsg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CPWok8/bSEeOSkGqEI1KG3/qF74fFqZJPrkxjBsGfX5umXI6a7MEQcfgZAjpOMccj
         4yXnnYSCVGkiymXThRmhpnqKoIOfVMN4q6zEOwkENl/jUAvG9ll2H8GToU9wrR59Sw
         3haAHtTG7Yk5MyUG9ASjjSOO2U9zbAUkcsasO2ReJNGVnsanWDqYE/Il5JwwLPkPvY
         I4MbwhxTl/iwnM7VvzDd4NXBVBuTNjosUbSaWxwRwqESy6hFX//fq/y1O38s5JkEZJ
         TJSZJD11NZR5HzOP3TG97M9YLOIWaJ+Qbe18jYBgXOBOXg3eRWhdXdnLkl5JQntHOB
         TTEoA+6xGYITQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3DA4F60A49;
        Mon, 22 Mar 2021 20:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/14] mlxsw: Preparations for resilient nexthop
 groups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644621024.7104.11749434615387440872.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:50:10 +0000
References: <20210322155855.3164151-1-idosch@idosch.org>
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 17:58:41 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset contains preparations for resilient nexthop groups support in
> mlxsw. A follow-up patchset will add support and selftests. Most of the
> patches are trivial and small to make review easier.
> 
> Patchset overview:
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] mlxsw: spectrum_router: Remove RTNL assertion
    https://git.kernel.org/netdev/net-next/c/08c99b92d76c
  - [net-next,02/14] mlxsw: spectrum_router: Consolidate nexthop helpers
    https://git.kernel.org/netdev/net-next/c/26df5acc275b
  - [net-next,03/14] mlxsw: spectrum_router: Only provide MAC address for valid nexthops
    https://git.kernel.org/netdev/net-next/c/c6a5011bec09
  - [net-next,04/14] mlxsw: spectrum_router: Adjust comments on nexthop fields
    https://git.kernel.org/netdev/net-next/c/248136fa251a
  - [net-next,05/14] mlxsw: spectrum_router: Introduce nexthop action field
    https://git.kernel.org/netdev/net-next/c/031d5c160656
  - [net-next,06/14] mlxsw: spectrum_router: Prepare for nexthops with trap action
    https://git.kernel.org/netdev/net-next/c/1be2361e3ca7
  - [net-next,07/14] mlxsw: spectrum_router: Add nexthop trap action support
    https://git.kernel.org/netdev/net-next/c/fc199d7c08c8
  - [net-next,08/14] mlxsw: spectrum_router: Rename nexthop update function to reflect its type
    https://git.kernel.org/netdev/net-next/c/424603ccdd5e
  - [net-next,09/14] mlxsw: spectrum_router: Encapsulate nexthop update in a function
    https://git.kernel.org/netdev/net-next/c/29017c643476
  - [net-next,10/14] mlxsw: spectrum_router: Break nexthop group entry validation to a separate function
    https://git.kernel.org/netdev/net-next/c/40f5429fce69
  - [net-next,11/14] mlxsw: spectrum_router: Avoid unnecessary neighbour updates
    https://git.kernel.org/netdev/net-next/c/c1efd50002c0
  - [net-next,12/14] mlxsw: spectrum_router: Create per-ASIC router operations
    https://git.kernel.org/netdev/net-next/c/d354fdd923e7
  - [net-next,13/14] mlxsw: spectrum_router: Encode adjacency group size ranges in an array
    https://git.kernel.org/netdev/net-next/c/164fa130dd16
  - [net-next,14/14] mlxsw: spectrum_router: Add Spectrum-{2, 3} adjacency group size ranges
    https://git.kernel.org/netdev/net-next/c/ea037b236a05

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


