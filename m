Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8363B4A8350
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 12:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350223AbiBCLuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 06:50:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32832 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237728AbiBCLuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 06:50:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FA01B833FE
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 11:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 109E5C340EC;
        Thu,  3 Feb 2022 11:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643889012;
        bh=RDX4HjaczzVI9yiG1jeSRzCM4VMoJhOYO4aHxCaHmVg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MTBBf/O7eOl1NtU/f4AXX5iUttiaqn56tLCSs4t9rVd5Z/s8cZSP5+FDuRwFSiefb
         8DFIDfQmic/PkAkBSHu7PJiZb7sV34zhO0aFUvpV2/y/2qHU1n4Np65yBmnXzsO0iU
         5aH1rIgv5O21kSONZBCSDWv7zu1LPBzMToRkOuGGJe2LAtp14r7x4htUGb+k8I6pkb
         pDrurN8AZhJrDusUe3N1TurKKI17FGTVLfSqCdd9X6rR3dKitYv4+4ZdyBMGBMehNs
         JNZwvuwNDPwhI2QTX8WSsnRKOaTp2IXJfQeLeq+DVYgAgSeF/xZ6PqWIjt+3pNCc4c
         tyCI6FEO/GEIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE64FE6BAC6;
        Thu,  3 Feb 2022 11:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] mptcp: Miscellaneous changes for 5.18
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164388901196.18714.17211200195167111456.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 11:50:11 +0000
References: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  2 Feb 2022 17:03:36 -0800 you wrote:
> Patch 1 has some minor cleanup in mptcp_write_options().
> 
> Patch 2 moves a rarely-needed branch to optimize mptcp_write_options().
> 
> Patch 3 adds a comment explaining which combinations of MPTCP option
> headers are expected.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] mptcp: move the declarations of ssk and subflow
    https://git.kernel.org/netdev/net-next/c/d7889cfa0b89
  - [net-next,2/7] mptcp: reduce branching when writing MP_FAIL option
    https://git.kernel.org/netdev/net-next/c/902c8f864882
  - [net-next,3/7] mptcp: clarify when options can be used
    https://git.kernel.org/netdev/net-next/c/8cca39e25171
  - [net-next,4/7] mptcp: print out reset infos of MP_RST
    https://git.kernel.org/netdev/net-next/c/9ddd1cac6fe1
  - [net-next,5/7] mptcp: set fullmesh flag in pm_netlink
    https://git.kernel.org/netdev/net-next/c/73c762c1f07d
  - [net-next,6/7] selftests: mptcp: set fullmesh flag in pm_nl_ctl
    https://git.kernel.org/netdev/net-next/c/c25d29be00c1
  - [net-next,7/7] selftests: mptcp: add fullmesh setting tests
    https://git.kernel.org/netdev/net-next/c/6a0653b96f5d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


