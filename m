Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308893881A4
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 22:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352133AbhERUvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 16:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243923AbhERUvb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 16:51:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EA61E6135C;
        Tue, 18 May 2021 20:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621371013;
        bh=wDZUESXAPY6kAETFt41Qn3g/L6BaPYsGaaHVXeuqj9k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hRWkt7cFHMSWfC4zPgRD9z1Nq3IiSCedbdUzgEN81YNBVnJLOIZHKbhHdkcC9BTj0
         zwEG/L646MrNzxlS9vEpJo8TsP7QknlbH7eFkWFTLOBE9MZN+6b8kmbiNEyr+bAzO8
         uWkqCKNIVH0dojoK8vHBZfSgiJr/BdqheIJgFYG0ckFOJVQFLoj/4OItUGbUwm9jWb
         6mvOezE1HZUqT3S65aj1p/n7RwMlyzOAx9lmzEykYgGq84z0pGXkXzsF12nc6qOsZZ
         KNBGTdoQ0aArgPZdyJ7zfCsEgIE5tPZF+bTB9ylhp8rdjoR3n2XE8vs5Q9dWrQtgGB
         zEXQzpLb9pJ7A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DA754608FB;
        Tue, 18 May 2021 20:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] Add support for custom multipath hash
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162137101289.13244.7446357799476667939.git-patchwork-notify@kernel.org>
Date:   Tue, 18 May 2021 20:50:12 +0000
References: <20210517181526.193786-1-idosch@nvidia.com>
In-Reply-To: <20210517181526.193786-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@OSS.NVIDIA.COM>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, petrm@OSS.NVIDIA.COM, roopa@OSS.NVIDIA.COM,
        nikolay@OSS.NVIDIA.COM, ssuryaextr@gmail.com, mlxsw@OSS.NVIDIA.COM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 17 May 2021 21:15:16 +0300 you wrote:
> This patchset adds support for custom multipath hash policy for both
> IPv4 and IPv6 traffic. The new policy allows user space to control the
> outer and inner packet fields used for the hash computation.
> 
> Motivation
> ==========
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] ipv4: Calculate multipath hash inside switch statement
    https://git.kernel.org/netdev/net-next/c/2e68ea926841
  - [net-next,02/10] ipv4: Add a sysctl to control multipath hash fields
    https://git.kernel.org/netdev/net-next/c/ce5c9c20d364
  - [net-next,03/10] ipv4: Add custom multipath hash policy
    https://git.kernel.org/netdev/net-next/c/4253b4986f98
  - [net-next,04/10] ipv6: Use a more suitable label name
    https://git.kernel.org/netdev/net-next/c/67db5ca73b1f
  - [net-next,05/10] ipv6: Calculate multipath hash inside switch statement
    https://git.kernel.org/netdev/net-next/c/b95b6e072a92
  - [net-next,06/10] ipv6: Add a sysctl to control multipath hash fields
    https://git.kernel.org/netdev/net-next/c/ed13923f980e
  - [net-next,07/10] ipv6: Add custom multipath hash policy
    https://git.kernel.org/netdev/net-next/c/73c2c5cbb15a
  - [net-next,08/10] selftests: forwarding: Add test for custom multipath hash
    https://git.kernel.org/netdev/net-next/c/511e8db54036
  - [net-next,09/10] selftests: forwarding: Add test for custom multipath hash with IPv4 GRE
    https://git.kernel.org/netdev/net-next/c/185b0c190bb6
  - [net-next,10/10] selftests: forwarding: Add test for custom multipath hash with IPv6 GRE
    https://git.kernel.org/netdev/net-next/c/b7715acba4d3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


