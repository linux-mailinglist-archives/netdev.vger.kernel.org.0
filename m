Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431B1339AFC
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 03:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbhCMCA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 21:00:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231392AbhCMCAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 21:00:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 734B664F8F;
        Sat, 13 Mar 2021 02:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615600810;
        bh=PJVpMp/SN6uCcZuDv0YJKqV/ua2MmvsHemxO6uCthv4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gukvi4LDL8/oZpvLrikx5ODNSy3gbpW9q6jIOqW91BMG1zZ5ZmFKHbldXWTuhMVAy
         sT/838kJMHzbHM1Rx2uiFnWl0cVTKQ0TazL7gSm5Lm7wHm3SyQ/YlsXRetmjxXfaCI
         f9jb9FadsUZoGjPk8OkmBP4hUv7zytiqfN1QmGvWEJhG6+CrHVTM4bE8wEQLQMA7o5
         AyvOgTQaWhQriPaPJQQCbm3Rz6zRUJ6QqGxNtJYIFde1H/PE4HD7SEh0c6bBiZNSq4
         Gr2y0lYtKDe1pboc/4vtajYAxnJgPronzlA5Tp4Anj/LZnB7f1K9dvgK3WmDh/a5sn
         /BX/EPe9CXeOQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6EF1C60A57;
        Sat, 13 Mar 2021 02:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] mptcp: Include multiple address ids in RM_ADDR
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161560081045.26528.4223411553383544597.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Mar 2021 02:00:10 +0000
References: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.01.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Mar 2021 17:16:10 -0800 you wrote:
> Here's a patch series from the MPTCP tree that extends the capabilities
> of the MPTCP RM_ADDR header.
> 
> MPTCP peers can exchange information about their IP addresses that are
> available for additional MPTCP subflows. IP addresses are advertised
> with an ADD_ADDR header type, and those advertisements are revoked with
> the RM_ADDR header type. RFC 8684 allows the RM_ADDR header to include
> more than one address ID, so multiple advertisements can be revoked in a
> single header. Previous kernel versions have only used RM_ADDR with a
> single address ID, so multiple removals required multiple packets.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] mptcp: add rm_list in mptcp_out_options
    https://git.kernel.org/netdev/net-next/c/6445e17af7c5
  - [net-next,02/11] mptcp: add rm_list_tx in mptcp_pm_data
    https://git.kernel.org/netdev/net-next/c/cbde27871896
  - [net-next,03/11] mptcp: add rm_list in mptcp_options_received
    https://git.kernel.org/netdev/net-next/c/5c4a824dcb58
  - [net-next,04/11] mptcp: add rm_list_rx in mptcp_pm_data
    https://git.kernel.org/netdev/net-next/c/b5c55f334c7f
  - [net-next,05/11] mptcp: remove multi addresses in PM
    https://git.kernel.org/netdev/net-next/c/d0b698ca9a27
  - [net-next,06/11] mptcp: remove multi subflows in PM
    https://git.kernel.org/netdev/net-next/c/ddd14bb85dd8
  - [net-next,07/11] mptcp: remove multi addresses and subflows in PM
    https://git.kernel.org/netdev/net-next/c/06faa2271034
  - [net-next,08/11] mptcp: remove a list of addrs when flushing
    https://git.kernel.org/netdev/net-next/c/0e4a3e68862b
  - [net-next,09/11] selftests: mptcp: add invert argument for chk_rm_nr
    https://git.kernel.org/netdev/net-next/c/7028ba8ac968
  - [net-next,10/11] selftests: mptcp: set addr id for removing testcases
    https://git.kernel.org/netdev/net-next/c/f87744ad4244
  - [net-next,11/11] selftests: mptcp: add testcases for removing addrs
    https://git.kernel.org/netdev/net-next/c/d2c4333a801c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


