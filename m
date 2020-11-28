Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7B42C6E70
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 03:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730991AbgK1CZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 21:25:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729459AbgK1BgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 20:36:17 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606527008;
        bh=/DaTCCeGBqemX9gPjwedotfwqzHhcd/AvhPNDC78PFE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eXd3KKnRr3KcKbzeQ+vkOBbyv7MlKkgbwdEntjxmDI/JHoPuqzLlwrBz4UYlNeNy3
         F27RBaKUYxDQ11Lgx0jMvH9SCdhEsEKCnLnqlK0ZeAzFIdJgYR/HWj3pJqaoCoZHvw
         DBCh2xVDzlgjD4Bx4RebqVJJSlUuayB8Pi6PYOug=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] mlxsw: Update adjacency index more efficiently
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160652700842.25160.16344799025246510988.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Nov 2020 01:30:08 +0000
References: <20201125193505.1052466-1-idosch@idosch.org>
In-Reply-To: <20201125193505.1052466-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Nov 2020 21:35:00 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The device supports an operation that allows the driver to issue one
> request to update the adjacency index for all the routes in a given
> virtual router (VR) from old index and size to new ones. This is useful
> in case the configuration of a certain nexthop group is updated and its
> adjacency index changes.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] mlxsw: spectrum_router: Fix error handling issue
    https://git.kernel.org/netdev/net-next/c/1c2c5eb6e108
  - [net-next,2/5] mlxsw: spectrum_router: Pass virtual router parameters directly instead of pointer
    https://git.kernel.org/netdev/net-next/c/40e4413d5dde
  - [net-next,3/5] mlxsw: spectrum_router: Rollback virtual router adjacency pointer update
    https://git.kernel.org/netdev/net-next/c/9a4ab10c74a0
  - [net-next,4/5] mlxsw: spectrum_router: Track nexthop group virtual router membership
    https://git.kernel.org/netdev/net-next/c/d2141a42b96a
  - [net-next,5/5] mlxsw: spectrum_router: Update adjacency index more efficiently
    https://git.kernel.org/netdev/net-next/c/ff47fa13c991

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


