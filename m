Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600AC45F7AE
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 01:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344460AbhK0AzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 19:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhK0AxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 19:53:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261BDC06175A
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 16:50:12 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACEF3623D8
        for <netdev@vger.kernel.org>; Sat, 27 Nov 2021 00:50:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id F26B560184;
        Sat, 27 Nov 2021 00:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637974211;
        bh=EarPkweg4UnWm9uw10OFHIej96e5uO9r33AWb4rEu0E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IO5Z9Dz4bwfCImj2V4USiaLrcXQxUzRvOyMrKCoD9jMw5y9j/X4i2kmeNKoFzi7GW
         K6YoTU2lPH10qWPc9x14dByXOF6AyqOHpvOzGbEmeI/CMRgidt+LKsNMCmeJVFYlVP
         YyHHjIIiqWWQ/A/AZ2f5TongtbK7CHDZmNMjNAgfCRnElCSFw7gXFAClXPKFqx4Q0F
         hU4p2rEkNh+ZIkiynis76nSJiBUtmkn2RmsUUUT0/0JTZp1mKg32xTPABQZakzUgIH
         v3dyMFnvNYeqjPg1vaQ+588NvvspR33sJIYjk+EDrqUBjVPmMqHJVsSARkNMN47SBY
         1ZPEr/6uV85AA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E3853609D2;
        Sat, 27 Nov 2021 00:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] selftests: net: bridge: vlan multicast tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163797421092.20298.18145877427977239715.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Nov 2021 00:50:10 +0000
References: <20211125140858.3639139-1-razor@blackwall.org>
In-Reply-To: <20211125140858.3639139-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, ivecera@redhat.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Nov 2021 16:08:48 +0200 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This patch-set adds selftests for the new vlan multicast options that
> were recently added. Most of the tests check for default values,
> changing options and try to verify that the changes actually take
> effect. The last test checks if the dependency between vlan_filtering
> and mcast_vlan_snooping holds. The rest are pretty self-explanatory.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] selftests: net: bridge: add vlan mcast snooping control test
    https://git.kernel.org/netdev/net-next/c/71ae450f97ad
  - [net-next,02/10] selftests: net: bridge: add vlan mcast querier test
    https://git.kernel.org/netdev/net-next/c/dee2cdc0e3bb
  - [net-next,03/10] selftests: net: bridge: add vlan mcast igmp/mld version tests
    https://git.kernel.org/netdev/net-next/c/2b75e9dd580c
  - [net-next,04/10] selftests: net: bridge: add vlan mcast_last_member_count/interval tests
    https://git.kernel.org/netdev/net-next/c/3825f1fb675b
  - [net-next,05/10] selftests: net: bridge: add vlan mcast_startup_query_count/interval tests
    https://git.kernel.org/netdev/net-next/c/bdf1b2c05e09
  - [net-next,06/10] selftests: net: bridge: add vlan mcast_membership_interval test
    https://git.kernel.org/netdev/net-next/c/a45fe9741736
  - [net-next,07/10] selftests: net: bridge: add vlan mcast_querier_interval tests
    https://git.kernel.org/netdev/net-next/c/4d8610ee8bd7
  - [net-next,08/10] selftests: net: bridge: add vlan mcast query and query response interval tests
    https://git.kernel.org/netdev/net-next/c/b4ce7b9523c4
  - [net-next,09/10] selftests: net: bridge: add vlan mcast_router tests
    https://git.kernel.org/netdev/net-next/c/2cd67a4e278e
  - [net-next,10/10] selftests: net: bridge: add test for vlan_filtering dependency
    https://git.kernel.org/netdev/net-next/c/f5a9dd58f48b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


