Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EDB439760
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhJYNWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230085AbhJYNWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 09:22:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9502060FE8;
        Mon, 25 Oct 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635168008;
        bh=zxIRa4174MqR58zsyaUxTtCqqHMGXDKn0/es9PND6Kc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mTqJZwJXIgBc4wciPtkoXST5PbqaDjdwNa/jNitbMktHQ4JG7atAQS4fm4efSfe1V
         InjxYwdBrKPhrO6VJbrqcBgSeXUt7WrmNtbJYENEM01TbX9e8y+EN7jtWI4wWimu66
         asGg0D2tXON40kAZkAQaaZbbd6FiD/v5C5iSQ7wmo8NXv+mX/Y76xxGOcG8zThbxD/
         CwKJ7Xk/eV7jU62hL8yP1ZvlH7KmhspmSQ4fD+F+rOald+fkK9KwSSrVobhw/ZSJ4q
         TbhDsIoJsSb0SPssQEN5Cfi1pP0SSZskzoGwREHKInbs2nA8gTV/uHbWHmFjmB43QU
         GeR4OJhmmwk9Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 887DA60A21;
        Mon, 25 Oct 2021 13:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] selftests: mlxsw: Various updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163516800855.2904.2219626049407594313.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 13:20:08 +0000
References: <20211024071911.1064322-1-idosch@idosch.org>
In-Reply-To: <20211024071911.1064322-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 24 Oct 2021 10:19:08 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset contains various updates to mlxsw selftests.
> 
> Patch #1 replaces open-coded compatibility checks with dedicated
> helpers. These helpers are used to skip tests when run on incompatible
> machines.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] selftests: mlxsw: Add helpers for skipping selftests
    https://git.kernel.org/netdev/net-next/c/b8bfafe43481
  - [net-next,2/3] selftests: mlxsw: Use permanent neighbours instead of reachable ones
    https://git.kernel.org/netdev/net-next/c/535ac9a5fba5
  - [net-next,3/3] selftests: mlxsw: Reduce test run time
    https://git.kernel.org/netdev/net-next/c/e860419684b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


