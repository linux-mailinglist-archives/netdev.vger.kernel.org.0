Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DD73AD25C
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbhFRSwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:52:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231441AbhFRSwR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 14:52:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9D196613E2;
        Fri, 18 Jun 2021 18:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624042207;
        bh=ivdV7t61vdAfTwP9qR3mjUR8O1DjMNHgQ0kv94qACvI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jSWRnvfueMPL1Ae+T5MVQXNdu6sVj/3kNWlry1IB14rvoQrQvuPpVAQ9kqYeM+9zG
         0+Ts53CKFWHAV1ntJWSfmZXYPsU4AHxAL5r2wQJB6XDI/ELyxANVjhiVPQWVWzBoGa
         yVRD7tDgzzYnZKkE/hnrt4oDwXZ/wkSeFUaXnuF+cVd/D7BOBjjC7tdhg1FysGeW9w
         sGokZ0NltAeiZav5/VgRM2CkehWgB9Wsy2RyFrEHFxSqU5DcWgar2NSzVbul9Yo+1X
         fCJHE1cI9vXONQuyowt2gLkgkqmnSoScWS/WXmZWTzAR5VOXhv+UATRcuJZCjtJyB+
         fkJR8zeAnIQ8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8BE3A60A17;
        Fri, 18 Jun 2021 18:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/16] mptcp: DSS checksum support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404220756.29148.11727219703950288907.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 18:50:07 +0000
References: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        geliangtang@gmail.com, pabeni@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 17 Jun 2021 16:46:06 -0700 you wrote:
> RFC 8684 defines a DSS checksum feature that allows MPTCP to detect
> middlebox interference with the MPTCP DSS header and the portion of the
> data stream associated with that header. So far, the MPTCP
> implementation in the Linux kernel has not supported this feature.
> 
> This patch series adds DSS checksum support. By default, the kernel will
> not request checksums when sending SYN or SYN/ACK packets for MPTCP
> connections. Outgoing checksum requests can be enabled with a
> per-namespace net.mptcp.checksum_enabled sysctl. MPTCP connections will
> now proceed with DSS checksums when the peer requests them, whether the
> sysctl is enabled or not.
> 
> [...]

Here is the summary with links:
  - [net-next,01/16] mptcp: add csum_enabled in mptcp_sock
    https://git.kernel.org/netdev/net-next/c/752e906732c6
  - [net-next,02/16] mptcp: generate the data checksum
    https://git.kernel.org/netdev/net-next/c/d0cc298745f5
  - [net-next,03/16] mptcp: add csum_reqd in mptcp_out_options
    https://git.kernel.org/netdev/net-next/c/06fe1719aa50
  - [net-next,04/16] mptcp: send out checksum for MP_CAPABLE with data
    https://git.kernel.org/netdev/net-next/c/c94b1f96dcfb
  - [net-next,05/16] mptcp: send out checksum for DSS
    https://git.kernel.org/netdev/net-next/c/c5b39e26d003
  - [net-next,06/16] mptcp: add sk parameter for mptcp_get_options
    https://git.kernel.org/netdev/net-next/c/c863225b7942
  - [net-next,07/16] mptcp: add csum_reqd in mptcp_options_received
    https://git.kernel.org/netdev/net-next/c/0625118115cf
  - [net-next,08/16] mptcp: receive checksum for MP_CAPABLE with data
    https://git.kernel.org/netdev/net-next/c/208e8f66926c
  - [net-next,09/16] mptcp: receive checksum for DSS
    https://git.kernel.org/netdev/net-next/c/390b95a5fb84
  - [net-next,10/16] mptcp: validate the data checksum
    https://git.kernel.org/netdev/net-next/c/dd8bcd1768ff
  - [net-next,11/16] mptcp: tune re-injections for csum enabled mode
    https://git.kernel.org/netdev/net-next/c/4e14867d5e91
  - [net-next,12/16] mptcp: add the mib for data checksum
    https://git.kernel.org/netdev/net-next/c/fe3ab1cbd357
  - [net-next,13/16] mptcp: add a new sysctl checksum_enabled
    https://git.kernel.org/netdev/net-next/c/fc3c82eebf8e
  - [net-next,14/16] mptcp: dump csum fields in mptcp_dump_mpext
    https://git.kernel.org/netdev/net-next/c/401e3030e68f
  - [net-next,15/16] selftests: mptcp: enable checksum in mptcp_connect.sh
    https://git.kernel.org/netdev/net-next/c/94d66ba1d8e4
  - [net-next,16/16] selftests: mptcp: enable checksum in mptcp_join.sh
    https://git.kernel.org/netdev/net-next/c/af66d3e1c3fa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


