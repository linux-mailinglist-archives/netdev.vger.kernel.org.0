Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059CF47DD5E
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhLWBaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhLWBaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:30:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FB5C061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 17:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A106261CF6
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 01:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE57CC36AEA;
        Thu, 23 Dec 2021 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640223014;
        bh=7sTLxtMK7fkcs7ph0qhZy9WTvX5iM4KqbfuROM4S9Pc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=im7ptt3l8BnXP9sng32WPtUEkHCsqnclgeCgndkNdYftSoTxU7Cvxon+NyZXlu5er
         embvlWMHgEzn/TFCs1BPoc5+ygRtftcEM7uD2mPnkWeildKBgEvzylWcbA0vo85CED
         g1LUJqJGvISGBXILNdg3ZHF0ChD4naFRtngx7gZQUwRpMCxRDZMZBi6CCVcHMLV40b
         n+sr7idHRMJCagxy2KVerMOK0vgW4ZmB6JnTXpOvCgLMqRJuu2wHjO6b27GiK9ZD/K
         g+3BCrPYl82cUIMgtfUyCtkJ8J6GJHhEcptHlpda7LZE3IM3A64OSrf5uVbZ82GHSq
         U5QjInl3Ex+Fg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1991FE55A6;
        Thu, 23 Dec 2021 01:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] Add tests for VxLAN with IPv6 underlay
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164022301385.9224.9125052732945014616.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 01:30:13 +0000
References: <20211221144949.2527545-1-amcohen@nvidia.com>
In-Reply-To: <20211221144949.2527545-1-amcohen@nvidia.com>
To:     Amit Cohen <amcohen@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Dec 2021 16:49:41 +0200 you wrote:
> mlxsw driver lately added support for VxLAN with IPv6 underlay.
> This set adds the relevant tests for IPv6, most of them are same to
> IPv4 tests with the required changes.
> 
> Patch set overview:
> Patch #1 relaxes requirements for offloading TC filters that
> match on 802.1q fields. The following selftests make use of these
> newly-relaxed filters.
> Patch #2 adds preparation as part of selftests API, which will be used
> later.
> Patches #3-#4 add tests for VxLAN with bridge aware and unaware.
> Patche #5 cleans unused function.
> Patches #6-#7 add tests for VxLAN symmetric and asymmetric.
> Patch #8 adds test for Q-in-VNI.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mlxsw: spectrum_flower: Make vlan_id limitation more specific
    https://git.kernel.org/netdev/net-next/c/70ec72d5b6c2
  - [net-next,2/8] selftests: lib.sh: Add PING_COUNT to allow sending configurable amount of packets
    https://git.kernel.org/netdev/net-next/c/0cd0b1f7a6e4
  - [net-next,3/8] selftests: forwarding: Add VxLAN tests with a VLAN-unaware bridge for IPv6
    https://git.kernel.org/netdev/net-next/c/b07e9957f220
  - [net-next,4/8] selftests: forwarding: Add VxLAN tests with a VLAN-aware bridge for IPv6
    https://git.kernel.org/netdev/net-next/c/728b35259e28
  - [net-next,5/8] selftests: forwarding: vxlan_bridge_1q: Remove unused function
    https://git.kernel.org/netdev/net-next/c/dc498cdda0ce
  - [net-next,6/8] selftests: forwarding: Add a test for VxLAN asymmetric routing with IPv6
    https://git.kernel.org/netdev/net-next/c/2902bae465c0
  - [net-next,7/8] selftests: forwarding: Add a test for VxLAN symmetric routing with IPv6
    https://git.kernel.org/netdev/net-next/c/6c6ea78a1161
  - [net-next,8/8] selftests: forwarding: Add Q-in-VNI test for IPv6
    https://git.kernel.org/netdev/net-next/c/bf0a8b9bf2c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


