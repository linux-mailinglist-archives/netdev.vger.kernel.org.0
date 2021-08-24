Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEBBA3F59EF
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 10:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhHXIkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 04:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235068AbhHXIkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 04:40:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C9A7E61262;
        Tue, 24 Aug 2021 08:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629794407;
        bh=lkWPyRjSayK24aAOrWwv6ox2HliGIGhNCkeZx1vBdTU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WzFSdkJvtiUXe+Dx850bFKRhpCbyQGlMNu8BcdfjaCX2QSo9blRPkap3Jv1qcpJL0
         fkO4XHZqIp2KdyRamS8lngOlaPFjGyV29wri9iihcj5u42on1DpM9qB4IIwiz7toRc
         zAjl2ASqGyaE4XlCodiNmq7lGiBlHopahApwEWcyw4gdl+EW73pFi/KnzkCNc8yKHO
         mkFg/a3MLtY11Z4NiLpcr0nj6cKx5asoFMnVpNZR+iBExCOCnxWnqnW4dJRgojNfoM
         ZjLSV0l24Gn8+kA848TybSj7OCdrTCQnUDpouEeL9poS6spjVWUeW1uG1UJ7HRB8C3
         AkxA7ocr40ABw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BE71B608FC;
        Tue, 24 Aug 2021 08:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] mptcp: Refactor ADD_ADDR/RM_ADDR handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162979440777.30048.9430649440436990103.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Aug 2021 08:40:07 +0000
References: <20210824010544.68600-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210824010544.68600-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        liyonglong@chinatelecom.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 23 Aug 2021 18:05:38 -0700 you wrote:
> This patch set changes the way MPTCP ADD_ADDR and RM_ADDR options are
> handled to improve the reliability of sending and updating address
> advertisements. The information used to populate outgoing advertisement
> option headers is now stored separately to avoid rare cases where a more
> recent request would overwrite something that had not been sent
> yet. While the peers would recover from this, it's better to avoid the
> problem in the first place.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] mptcp: move drop_other_suboptions check under pm lock
    https://git.kernel.org/netdev/net-next/c/1f5e9e2f5fd5
  - [net-next,2/6] mptcp: make MPTCP_ADD_ADDR_SIGNAL and MPTCP_ADD_ADDR_ECHO separate
    https://git.kernel.org/netdev/net-next/c/18fc1a922e24
  - [net-next,3/6] mptcp: fix ADD_ADDR and RM_ADDR maybe flush addr_signal each other
    https://git.kernel.org/netdev/net-next/c/119c022096f5
  - [net-next,4/6] mptcp: build ADD_ADDR/echo-ADD_ADDR option according pm.add_signal
    https://git.kernel.org/netdev/net-next/c/f462a446384d
  - [net-next,5/6] mptcp: remove MPTCP_ADD_ADDR_IPV6 and MPTCP_ADD_ADDR_PORT
    https://git.kernel.org/netdev/net-next/c/c233ef139070
  - [net-next,6/6] selftests: mptcp: add_addr and echo race test
    https://git.kernel.org/netdev/net-next/c/33c563ad28e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


