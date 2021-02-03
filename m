Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6B030D1FE
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 04:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhBCDKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 22:10:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231704AbhBCDKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 22:10:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0DE2664F69;
        Wed,  3 Feb 2021 03:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612321812;
        bh=cvSVyumrUPiTsAJFW0Btae6Wu3ruTfn4+WT/DZUH18c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lt5CfBYGDDPmfi4S3UnIOtLHPKF14oc6jL1uxf4E4euzllV+n1of5TikqqeXS1LtR
         xKawO21EgK49UR7NzNL55VxVkTBo1V5CVbW4K3OQ4zQBLI+OuPDfMerCUX8FBl2Rcr
         1UMcStxvv8HmU29fAl4ok8eG1xCgO6EUMhzbvvPH69a9+XNah04BVhagF+JURFejs1
         ehEDb7WgRLhqxcaI+iCiDVl2oaeEnOC2YJ2oiAD15YPDZgF4DoIrZNRT7Ug+Jh5Kzx
         r82XllJklRiD/aJ53IZJ3UDMWb8q19B1jNkhNWrB1WQVum/UfwCWifsT9U/KM3x/oQ
         AEVAIUH6Sq7sg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F3639609CE;
        Wed,  3 Feb 2021 03:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/15] mptcp: ADD_ADDR enhancements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161232181199.32173.5744869483811208677.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Feb 2021 03:10:11 +0000
References: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mptcp@lists.01.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  1 Feb 2021 15:09:05 -0800 you wrote:
> This patch series from the MPTCP tree contains enhancements and
> associated tests for the ADD_ADDR ("add address") MPTCP option. This
> option allows already-connected MPTCP peers to share additional IP
> addresses with each other, which can then be used to create additional
> subflows within those MPTCP connections.
> 
> Patches 1 & 2 remove duplicated data in the per-connection path manager
> structure.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/15] mptcp: use WRITE_ONCE for the pernet *_max
    https://git.kernel.org/netdev/net-next/c/72603d207d59
  - [net-next,v2,02/15] mptcp: drop *_max fields in mptcp_pm_data
    https://git.kernel.org/netdev/net-next/c/a914e586689f
  - [net-next,v2,03/15] mptcp: create subflow or signal addr for newly added address
    https://git.kernel.org/netdev/net-next/c/875b76718f68
  - [net-next,v2,04/15] mptcp: send ack for every add_addr
    https://git.kernel.org/netdev/net-next/c/b5a7acd3bd63
  - [net-next,v2,05/15] selftests: mptcp: use minus values for removing address numbers
    https://git.kernel.org/netdev/net-next/c/2e8cbf45cfb3
  - [net-next,v2,06/15] selftests: mptcp: add testcases for newly added addresses
    https://git.kernel.org/netdev/net-next/c/6208fd822a2c
  - [net-next,v2,07/15] mptcp: create the listening socket for new port
    https://git.kernel.org/netdev/net-next/c/1729cf186d8a
  - [net-next,v2,08/15] mptcp: drop unused skb in subflow_token_join_request
    https://git.kernel.org/netdev/net-next/c/b5e2e42fe566
  - [net-next,v2,09/15] mptcp: add a new helper subflow_req_create_thmac
    https://git.kernel.org/netdev/net-next/c/ec20e14396ae
  - [net-next,v2,10/15] mptcp: add port number check for MP_JOIN
    https://git.kernel.org/netdev/net-next/c/5bc56388c74f
  - [net-next,v2,11/15] mptcp: enable use_port when invoke addresses_equal
    https://git.kernel.org/netdev/net-next/c/60b57bf76cff
  - [net-next,v2,12/15] mptcp: deal with MPTCP_PM_ADDR_ATTR_PORT in PM netlink
    https://git.kernel.org/netdev/net-next/c/a77e9179c765
  - [net-next,v2,13/15] selftests: mptcp: add port argument for pm_nl_ctl
    https://git.kernel.org/netdev/net-next/c/d4a7726a79e2
  - [net-next,v2,14/15] mptcp: add the mibs for ADD_ADDR with port
    https://git.kernel.org/netdev/net-next/c/2fbdd9eaf174
  - [net-next,v2,15/15] selftests: mptcp: add testcases for ADD_ADDR with port
    https://git.kernel.org/netdev/net-next/c/8a127bf68a6f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


