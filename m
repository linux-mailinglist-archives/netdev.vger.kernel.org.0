Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFFC4AA70F
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 07:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351601AbiBEGKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 01:10:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57184 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351751AbiBEGKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 01:10:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70460B839DB
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 06:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F6D1C340EC;
        Sat,  5 Feb 2022 06:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644041412;
        bh=9y0hRMLG81HDrfK+/FsShH8IK6aHwlF0NfzKK/DvnuY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q9jI//r6hmXbkQnP4kU2gl39wTcL/CbZM86QLEeXJI+6/A4KU4WWPnnpyFGt9xt8I
         E9aoVbX9bGCWlsHYb493FB+k+aSvADzd5M4Rf0zbPore7WMUca4+vqyx0sZrUYOBLh
         yI/RGxX/TgIP0+X+kOXXY2h2JxewLq2PFjOcniLIC2Eu+ZuTyy/N5V9PdVz5N2DB6o
         wpI49lRL1mQ7+ceOPa/vQDBox2nlB9/Dtz6T72P7eUg7ud+klZX8jevLUmMWDI3yE2
         EEMjjEs1ilJyPc2OLXAr0HQAnrepP/vj5fHp2++2wVCiYju7LIVJh1bEOcOFYQemtr
         aloWhSZ3aw7Aw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3607E5D07E;
        Sat,  5 Feb 2022 06:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] mptcp: Improve set-flags command and update self
 tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164404141198.19196.16444853469420129139.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 06:10:11 +0000
References: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  4 Feb 2022 16:03:28 -0800 you wrote:
> Patches 1-3 allow more flexibility in the combinations of features and
> flags allowed with the MPTCP_PM_CMD_SET_FLAGS netlink command, and add
> self test case coverage for the new functionality.
> 
> Patches 4-6 and 9 refactor the mptcp_join.sh self tests to allow them to
> configure all of the test cases using either the pm_nl_ctl utility (part
> of the mptcp self tests) or the 'ip mptcp' command (from iproute2). The
> default remains to use pm_nl_ctl.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] mptcp: allow to use port and non-signal in set_flags
    https://git.kernel.org/netdev/net-next/c/09f12c3ab7a5
  - [net-next,2/9] selftests: mptcp: add the port argument for set_flags
    https://git.kernel.org/netdev/net-next/c/d6a676e0e1a8
  - [net-next,3/9] selftests: mptcp: add backup with port testcase
    https://git.kernel.org/netdev/net-next/c/33397b83eee6
  - [net-next,4/9] selftests: mptcp: add ip mptcp wrappers
    https://git.kernel.org/netdev/net-next/c/34aa6e3bccd8
  - [net-next,5/9] selftests: mptcp: add wrapper for showing addrs
    https://git.kernel.org/netdev/net-next/c/dda61b3dbea0
  - [net-next,6/9] selftests: mptcp: add wrapper for setting flags
    https://git.kernel.org/netdev/net-next/c/f01403862592
  - [net-next,7/9] selftests: mptcp: add the id argument for set_flags
    https://git.kernel.org/netdev/net-next/c/a224a847ae7a
  - [net-next,8/9] selftests: mptcp: add set_flags tests in pm_netlink.sh
    https://git.kernel.org/netdev/net-next/c/6da1dfdd037e
  - [net-next,9/9] selftests: mptcp: set ip_mptcp in command line
    https://git.kernel.org/netdev/net-next/c/621bd393039e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


