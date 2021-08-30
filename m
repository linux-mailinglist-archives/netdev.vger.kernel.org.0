Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEC63FB4D3
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 13:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbhH3LvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 07:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236511AbhH3Lu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 07:50:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 04AD361153;
        Mon, 30 Aug 2021 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324206;
        bh=HpVmdF4QAkhZw1bOkEIQFkTWCDXDdp6WRvOPJGIpkOA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mg5VyRXRU6bHEy2Mygz2sUpVsPvrxoBNDEhDjODcROyOVo23d54NmbyjbGPU3ER91
         4aY9Xd3nxHaxo+5Qco8fub3Lc9f/i0ZsE+cOBwTeGdhmKJv0NhzB0Zn2hugvVehan9
         DuMrOiDBZBJqQSlv0koqE7rt3qdELfFfZPejMND0b9qwAhqvPL8bxTTvFP5o3W8Zp9
         ofve2hix4VVDTUTm/gpSGBgYlCrcjXMfXt+BLDlCIcAMvkRxpF4BtiZMwL7t/XaLGO
         bzYDPYf+YLH4eBIKO9RTaiKTct6o558T9JZlwbXJTkAH3Xh04+uziBH0B6tf087tid
         XtQEZ5pxW+veA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EB1B060A6C;
        Mon, 30 Aug 2021 11:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipv4: Fix the warning for dereference
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163032420595.13141.14066934004693192877.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Aug 2021 11:50:05 +0000
References: <20210830091640.14739-1-yajun.deng@linux.dev>
In-Reply-To: <20210830091640.14739-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 30 Aug 2021 17:16:40 +0800 you wrote:
> Add a if statements to avoid the warning.
> 
> Dan Carpenter report:
> The patch faf482ca196a: "net: ipv4: Move ip_options_fragment() out of
> loop" from Aug 23, 2021, leads to the following Smatch complaint:
> 
>     net/ipv4/ip_output.c:833 ip_do_fragment()
>     warn: variable dereferenced before check 'iter.frag' (see line 828)
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipv4: Fix the warning for dereference
    https://git.kernel.org/netdev/net-next/c/1b9fbe813016

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


