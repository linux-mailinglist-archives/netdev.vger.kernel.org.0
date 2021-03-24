Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698DB348588
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 00:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbhCXXuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 19:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235037AbhCXXuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 19:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BA88E61A17;
        Wed, 24 Mar 2021 23:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616629809;
        bh=eJjKKD9q7TFRS5+L9rAltjyLmqbSxmugPni6PakQ2Ws=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fv7nHvXGUIQUGefHz5G+pqjD7TgdVyzuOpUy0rVfz2r5elZDl8leA9EL9NTQigJAY
         c2DXNvzKL9zS2qfLK0bibW3utt/nYD2xjvpd+3+rgzApQRiIylrRwycpUhS1cJca9p
         RsmL1GsVdPvxXowbc6k1bzO5LeaHlyC7mXvI0hJoIMsT8S83ucZm592+lOL6+lYZae
         TtBXs4wQnl6An7aNhNR2HjRHQrwF4ta+0YSjGxRDyzk5KKFEp37rDuJtH8y3/B2oO2
         7Ft4YU3QmSAcvqJoIt0NYf0wKlUW1bwTYVL3oh7FRUfZJwpXcQX7jH/9XH5cJraiD9
         l5/PqgyR6c4kQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AF50B60A0E;
        Wed, 24 Mar 2021 23:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] mlxsw: Add support for resilient nexthop
 groups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161662980971.25610.8650360060132459829.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 23:50:09 +0000
References: <20210324201424.157387-1-idosch@idosch.org>
In-Reply-To: <20210324201424.157387-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 24 Mar 2021 22:14:14 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset adds support for resilient nexthop groups in mlxsw. As far
> as the hardware is concerned, resilient groups are the same as regular
> groups. The differences lie in how mlxsw manages the individual
> adjacency entries (nexthop buckets) that make up the group.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] mlxsw: spectrum_router: Add support for resilient nexthop groups
    https://git.kernel.org/netdev/net-next/c/c6fc65f48072
  - [net-next,02/10] mlxsw: spectrum_router: Add ability to overwrite adjacency entry only when inactive
    https://git.kernel.org/netdev/net-next/c/62b67ff33bee
  - [net-next,03/10] mlxsw: spectrum_router: Pass payload pointer to nexthop update function
    https://git.kernel.org/netdev/net-next/c/197fdfd107e3
  - [net-next,04/10] mlxsw: spectrum_router: Add nexthop bucket replacement support
    https://git.kernel.org/netdev/net-next/c/617a77f044ed
  - [net-next,05/10] mlxsw: spectrum_router: Update hardware flags on nexthop buckets
    https://git.kernel.org/netdev/net-next/c/d7761cb30374
  - [net-next,06/10] mlxsw: reg: Add Router Adjacency Table Activity Dump Register
    https://git.kernel.org/netdev/net-next/c/75d495b02982
  - [net-next,07/10] mlxsw: spectrum_router: Periodically update activity of nexthop buckets
    https://git.kernel.org/netdev/net-next/c/debd2b3bf573
  - [net-next,08/10] mlxsw: spectrum_router: Enable resilient nexthop groups to be programmed
    https://git.kernel.org/netdev/net-next/c/03490a823915
  - [net-next,09/10] selftests: mlxsw: Test unresolved neigh trap with resilient nexthop groups
    https://git.kernel.org/netdev/net-next/c/861584724c44
  - [net-next,10/10] selftests: mlxsw: Add resilient nexthop groups configuration tests
    https://git.kernel.org/netdev/net-next/c/ffd3e9b07b9e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


