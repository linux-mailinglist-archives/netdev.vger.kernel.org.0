Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C9848767E
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 12:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347118AbiAGLaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 06:30:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60516 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236893AbiAGLaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 06:30:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53DAA616FF
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 11:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BDDD4C36AEF;
        Fri,  7 Jan 2022 11:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641555015;
        bh=/NN+NXtxMk5htp7s04TEB6JA93aeFS5I02JHoZAeLf0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XThIoenY8URmNVimztVUoyo5+mwLqyZlCI6dp+rHr4Z9tpLoH6w5jbi7/Wr9ZW+EF
         QfrZVVjndnfzJYac9G4bIOUn550rZDRnIjgbFH/mEE1uVODFmEm58RcGgdXCzhCwUM
         cW/2VK4G+18sdGnzTBBvY+E5SDK+rmb4suzNNYGrH622NMS/C5NGXAGDpBzTYNMlRN
         YzEjfin9q3IX6Q/hJ9FI0+QXc67Ecffi36ww14HKpNietu2vsUeHf6et1GRSHM46OK
         FtfUlBER0MD701HhJVGIJ77yQ8APJkFyLE+z/RrJJAf5WVney4Lk3ij/wtOz1sxO9X
         pnZuj20WdiG/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 998E0F79401;
        Fri,  7 Jan 2022 11:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/13] mptcp: New features and cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164155501560.4388.12709862178008288896.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Jan 2022 11:30:15 +0000
References: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Jan 2022 16:20:13 -0800 you wrote:
> These patches have been tested in the MPTCP tree for a longer than usual
> time (thanks to holiday schedules), and are ready for the net-next
> branch. Changes include feature updates, small fixes, refactoring, and
> some selftest changes.
> 
> Patch 1 fixes an OUTQ ioctl issue with TCP fallback sockets.
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] mptcp: keep snd_una updated for fallback socket
    https://git.kernel.org/netdev/net-next/c/58cd405b83b3
  - [net-next,02/13] mptcp: implement fastclose xmit path
    https://git.kernel.org/netdev/net-next/c/f284c0c77321
  - [net-next,03/13] mptcp: full disconnect implementation
    https://git.kernel.org/netdev/net-next/c/b29fcfb54cd7
  - [net-next,04/13] mptcp: cleanup accept and poll
    https://git.kernel.org/netdev/net-next/c/71ba088ce0aa
  - [net-next,05/13] mptcp: implement support for user-space disconnect
    https://git.kernel.org/netdev/net-next/c/3d1d6d66e156
  - [net-next,06/13] selftests: mptcp: add disconnect tests
    https://git.kernel.org/netdev/net-next/c/05be5e273c84
  - [net-next,07/13] mptcp: fix per socket endpoint accounting
    https://git.kernel.org/netdev/net-next/c/f7d6a237d742
  - [net-next,08/13] mptcp: clean-up MPJ option writing
    https://git.kernel.org/netdev/net-next/c/71b077e48377
  - [net-next,09/13] mptcp: keep track of local endpoint still available for each msk
    https://git.kernel.org/netdev/net-next/c/86e39e04482b
  - [net-next,10/13] mptcp: do not block subflows creation on errors
    https://git.kernel.org/netdev/net-next/c/a88c9e496937
  - [net-next,11/13] selftests: mptcp: add tests for subflow creation failure
    https://git.kernel.org/netdev/net-next/c/46e967d187ed
  - [net-next,12/13] mptcp: cleanup MPJ subflow list handling
    https://git.kernel.org/netdev/net-next/c/3e5014909b56
  - [net-next,13/13] mptcp: avoid atomic bit manipulation when possible
    https://git.kernel.org/netdev/net-next/c/e9d09baca676

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


