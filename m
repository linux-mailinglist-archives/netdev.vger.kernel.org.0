Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E523530BF
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 23:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbhDBVaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 17:30:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234619AbhDBVaO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 17:30:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9EA0F61181;
        Fri,  2 Apr 2021 21:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617399012;
        bh=v5tf32z6nm/OFLA4CZvfIYWZwoEOphu58Ri8f797QnE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hGTY4SUfrew/99ARvjDx3bveh4sIMJNV5RkGRRoQbD0XweRK+9wGmC1maJjydolpX
         O5ousvlcjjW4PBH60r3v82Qv87K/65n9852+vxda2lIt3q+Kb/tA3/ogI0ActseACt
         XMUbXi4TipTIzdIeqZZ+p83AdGNZEDTfMhoZQWAhuOwQcjdCU7Sv5ZzKZZDXTgxm9u
         T/TOwQ/MLFOAk7699nJ3RJxOf0pYg8AkRVZwM+xQwxXeZqRBZkom1KLM16MyrsGvZC
         +9gv9b0Dl7/A/Yb283Yo7sscxgxw6pBplYIM10MPRdFFiSI3FC55qdwDlOiKnxORgC
         cPgfsKn20fD/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 964F3609E6;
        Fri,  2 Apr 2021 21:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] MPTCP: Miscellaneous changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161739901261.1946.14359498630889237518.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Apr 2021 21:30:12 +0000
References: <20210401231947.162836-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210401231947.162836-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  1 Apr 2021 16:19:40 -0700 you wrote:
> Here is a collection of patches from the MPTCP tree:
> 
> 
> Patches 1 and 2 add some helpful MIB counters for connection
> information.
> 
> Patch 3 cleans up some unnecessary checks.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] mptcp: add mib for token creation fallback
    https://git.kernel.org/netdev/net-next/c/a16195e35cd0
  - [net-next,2/7] mptcp: add active MPC mibs
    https://git.kernel.org/netdev/net-next/c/5695eb8891f9
  - [net-next,3/7] mptcp: remove unneeded check on first subflow
    https://git.kernel.org/netdev/net-next/c/781bf13d4f3b
  - [net-next,4/7] mptcp: add mptcp reset option support
    https://git.kernel.org/netdev/net-next/c/dc87efdb1a5c
  - [net-next,5/7] selftests: mptcp: launch mptcp_connect with timeout
    https://git.kernel.org/netdev/net-next/c/5888a61cb4e0
  - [net-next,6/7] selftests: mptcp: init nstat history
    https://git.kernel.org/netdev/net-next/c/76e5e27ca987
  - [net-next,7/7] selftests: mptcp: dump more info on mpjoin errors
    https://git.kernel.org/netdev/net-next/c/c2a55e8fd80f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


