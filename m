Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B403B3CF8B6
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 13:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbhGTKj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 06:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233406AbhGTKj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 06:39:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9B86F61165;
        Tue, 20 Jul 2021 11:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626780005;
        bh=bjCSTDsNnZcM6Rf4+njSyX2tnJwMT/TUdE6nL7Hn3mM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LURPow1Brmq+EUDGnp0EepLdaA+525NP7HRJgQWy0TzfzbiWkOKdBK9vMnQdigL/c
         KOyB2Tn8qM1MMZW+Ivy7ZeUgLcHyj4kbEM8wlOjghQAMY4lpWWo14hj/xW9Lrd5VJP
         3mUhcwslbN/Tdb+5VuvkVTZXoCl1CwUNHUMrN+zp3iQSalpz/arLX5rLg5HTu70Rex
         ROmk07Yxx534punF6Nk38RiYfgBSTDqORPA9RFAco1XM4SYrOWRwaTL9W2dMEoqiUz
         F36K8MOXjXeQUb5PdU78siOa9xTFb1sbbx4+qa0I9mRl/mXIDsv5up4vwEllxlOCFc
         UAh+nsutWgOaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8F74560CCF;
        Tue, 20 Jul 2021 11:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bridge: do not replay fdb entries pointing towards
 the bridge twice
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162678000558.21231.2477207642313158352.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 11:20:05 +0000
References: <20210719093916.4099032-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210719093916.4099032-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@resnulli.us, idosch@idosch.org, tobias@waldekranz.com,
        roopa@nvidia.com, nikolay@nvidia.com, stephen@networkplumber.org,
        bridge@lists.linux-foundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 19 Jul 2021 12:39:16 +0300 you wrote:
> This simple script:
> 
> ip link add br0 type bridge
> ip link set swp2 master br0
> ip link set br0 address 00:01:02:03:04:05
> ip link del br0
> 
> [...]

Here is the summary with links:
  - [net] net: bridge: do not replay fdb entries pointing towards the bridge twice
    https://git.kernel.org/netdev/net/c/cbb56b03ec3f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


