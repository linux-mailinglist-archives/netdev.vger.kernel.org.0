Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4613EBED0
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbhHMXke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235330AbhHMXkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 19:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 51F71610F7;
        Fri, 13 Aug 2021 23:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628898006;
        bh=CAaltIe3U8fklVm2P7fWtZ5GM3sbUCb1660w6Pm9VAs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jS20W7L0bLKig4xkAClgg98wUorzcLWpST3lRrIGN56lhK0SDvJLqpuaK8fqN0wm0
         nzrhhFzvK++cPhHwh9gCPHhgFwsaBjh1Au/HEbpjfbdHOy9qtXD18RtBWGUp6cAuZX
         gs5IdYVuSmgefIQ9gVSxlEXAA2YXTZt2eolyWfItjn8ukw/kN3AW9rRY+loiiUHLdU
         mUK55DQHqalWnEs3RBCemK4oFpw/R+/XZ92VUT7fF4VvHLWh4M+fmmzrdhy5O5Lj4i
         9tQABQgar9a7fxMZdyzhZyYfBmf+0K6enwKN7wTI9rhRA9cNIKdDpFyYGZeBsMPSB8
         HWIHI2xBuNDng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 43EEB60A86;
        Fri, 13 Aug 2021 23:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3] Kconfig symbol clean-up on net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162889800627.16789.15412408508624833169.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Aug 2021 23:40:06 +0000
References: <20210812083806.28434-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20210812083806.28434-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        madalin.bucur@nxp.com, rdunlap@infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 12 Aug 2021 10:38:03 +0200 you wrote:
> Dear David, dear Jakub,
> 
> The script ./scripts/checkkconfigsymbols.py warns on invalid references to
> Kconfig symbols (often, minor typos, name confusions or outdated references).
> 
> This patch series addresses all issues reported by
> ./scripts/checkkconfigsymbols.py in ./net/ and ./drivers/net/ for Kconfig
> and Makefile files. Issues in the Kconfig and Makefile files indicate some
> shortcomings in the overall build definitions, and often are true actionable
> issues to address.
> 
> [...]

Here is the summary with links:
  - [1/3] net: Kconfig: remove obsolete reference to config MICROBLAZE_64K_PAGES
    https://git.kernel.org/netdev/net-next/c/4fb464db9c72
  - [2/3] net: 802: remove dead leftover after ipx driver removal
    https://git.kernel.org/netdev/net-next/c/d8d9ba8dc9c7
  - [3/3] net: dpaa_eth: remove dead select in menuconfig FSL_DPAA_ETH
    https://git.kernel.org/netdev/net-next/c/f75d81556a38

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


