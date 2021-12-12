Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16EDB471B92
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 17:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhLLQaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 11:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbhLLQaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 11:30:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C53FC061714
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 08:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CB4BB80D4A
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 16:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0086C341CC;
        Sun, 12 Dec 2021 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639326609;
        bh=nM4fj8ZNhC9BUEtWNd98L/cua/SsVgbx+VB7imxz95U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y1Tbg1MjmeGmpOusGnpwmkjANisMlg3EVGpN4L4wciXpe8+I+gVr5Y+QDfR6oaH55
         4ijbstHUYtN25kzzLtp6g5ROjPZt6P5DuE5eV3+F8Fk/hj2KsHl2QsjvsQj0vndz7n
         y2p1LbJUYeTk+CgU4YuMonVsUtWYh4P6kVDU7ePNWjynhCTSBNePKy9u0TWuumEG9x
         +FI2AdVBg1Epr0bc5MC885uw4qd5zBYCoLrxA7j2oeselAYFDnThndLnG7hida1LyD
         vPEN0VCqRSbMJQTOZ4q0tNeb30hmHWnrTHjchkeNVCJJ5lotp5RkB/DIT0RQdZ4D7F
         9sPaETMsZhchA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C65EB60C73;
        Sun, 12 Dec 2021 16:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: Fix IPv6 address bind tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163932660980.2571.2974512925430864063.git-patchwork-notify@kernel.org>
Date:   Sun, 12 Dec 2021 16:30:09 +0000
References: <20211211182616.74865-1-dsahern@kernel.org>
In-Reply-To: <20211211182616.74865-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, lizhijian@fujitsu.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 11 Dec 2021 11:26:16 -0700 you wrote:
> IPv6 allows binding a socket to a device then binding to an address
> not on the device (__inet6_bind -> ipv6_chk_addr with strict flag
> not set). Update the bind tests to reflect legacy behavior.
> 
> Fixes: 34d0302ab861 ("selftests: Add ipv6 address bind tests to fcnal-test")
> Reported-by: Li Zhijian <lizhijian@fujitsu.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] selftests: Fix IPv6 address bind tests
    https://git.kernel.org/netdev/net/c/28a2686c185e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


