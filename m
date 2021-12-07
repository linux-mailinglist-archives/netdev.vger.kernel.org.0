Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9F646C4C2
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 21:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241297AbhLGUnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 15:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241172AbhLGUnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 15:43:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DBAC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 12:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C2DFDCE1E6E
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 20:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9804C341C6;
        Tue,  7 Dec 2021 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638909611;
        bh=AzmHnAtztKERAOCBEyVt+Sws9hCKYFk9wQ1nUYzSyiQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bp3ug800lmkImhlNI5BK+/Np9zrPa1ih1rTW0K9mORjjSAL1ufMjjL/2LZJYGLh8c
         yoGMG3eBRL4J6ln4poIETolzWDJkrHFFMV3KO9tVUVONe2az68H8ABV1mTwkLYa0Qq
         db6m71wCK/opC+oPWgw3p7NdP5T3PBrG67Ic+eiaoX2tLekwqOZFyCTKsltQjUsTQd
         7I6w5DmBOLakm7xUp7fdfgJumXUTHM/zgZygQmvuxTo36hy9+pu8iLMRhtTw+rBdj+
         D/uM6mCM9mVkmxVAFcnUyqbt5nBTCh89+6Guk2UuXVTnOYj48THjiJlBNsz7Kv92Q6
         PVIT084LAbFgw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B60D260A39;
        Tue,  7 Dec 2021 20:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] mptcp: New features for MPTCP sockets and
 netlink PM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163890961074.15220.17789966096382310478.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Dec 2021 20:40:10 +0000
References: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  3 Dec 2021 14:35:31 -0800 you wrote:
> This collection of patches adds MPTCP socket support for a few socket
> options, ioctls, and one ancillary data type (specifics for each are
> listed below). There's also a patch modifying the netlink MPTCP path
> manager API to allow setting the backup flag on a configured interface
> using the endpoint ID instead of the full IP address.
> 
> Patches 1 & 2: TCP_INQ cmsg and selftests.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] mptcp: add TCP_INQ cmsg support
    https://git.kernel.org/netdev/net-next/c/2c9e77659a0c
  - [net-next,02/10] selftests: mptcp: add TCP_INQ support
    https://git.kernel.org/netdev/net-next/c/5cbd886ce2a9
  - [net-next,03/10] mptcp: add SIOCINQ, OUTQ and OUTQNSD ioctls
    https://git.kernel.org/netdev/net-next/c/644807e3e462
  - [net-next,04/10] selftests: mptcp: add inq test case
    https://git.kernel.org/netdev/net-next/c/b51880568f20
  - [net-next,05/10] mptcp: allow changing the "backup" bit by endpoint id
    https://git.kernel.org/netdev/net-next/c/602837e8479d
  - [net-next,06/10] mptcp: getsockopt: add support for IP_TOS
    https://git.kernel.org/netdev/net-next/c/3b1e21eb60e8
  - [net-next,07/10] selftests: mptcp: check IP_TOS in/out are the same
    https://git.kernel.org/netdev/net-next/c/edb596e80cee
  - [net-next,08/10] tcp: expose __tcp_sock_set_cork and __tcp_sock_set_nodelay
    https://git.kernel.org/netdev/net-next/c/6fadaa565882
  - [net-next,09/10] mptcp: expose mptcp_check_and_set_pending
    https://git.kernel.org/netdev/net-next/c/8b38217a2a98
  - [net-next,10/10] mptcp: support TCP_CORK and TCP_NODELAY
    https://git.kernel.org/netdev/net-next/c/4f6e14bd19d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


