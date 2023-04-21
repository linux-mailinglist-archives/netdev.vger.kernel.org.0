Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E806EA53E
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjDUHuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbjDUHuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:50:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1B540C7
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 143A664E92
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B8BFC4339B;
        Fri, 21 Apr 2023 07:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682063430;
        bh=6/y8G0ZiqPAifVh+i5PDY7VpETrfy1glOu1IyKXJtnA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UOgmSicvboaxb7lj0j+c2vpcta80Fwxh3175QxIhJq1cMJj4taQBfY5hcLH50oR4v
         4bQ9MPXU63G9zLBtVFT1sN0MDJLiw+FAh6QOb3EnVGLA41N10es7RPuAHpWSBDxYsG
         ygXnTDlKwrWoC09NCADZAJihpsmkgmVkiRlvPIOgl6dx65v8xo+65eYVTa7n3sUxmh
         1zAXIc6dGzoCMxT2WDeughA+zEg/X4Hor3pUv5RoasA5zp8CFX6BAmcj9NYaDYI8pk
         /csAwyLvML6J9cmhaZmQ+T/NaBj3FcuYq9DlgDwNkbSmMBpeNeMSSDeCnOzNq5JoqU
         Eo8sSYW8ZOITg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4D543E501E2;
        Fri, 21 Apr 2023 07:50:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/9] bridge: Add per-{Port,
 VLAN} neighbor suppression
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168206343031.30967.17590346122475626236.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 07:50:30 +0000
References: <20230419153500.2655036-1-idosch@nvidia.com>
In-Reply-To: <20230419153500.2655036-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 19 Apr 2023 18:34:51 +0300 you wrote:
> Background
> ==========
> 
> In order to minimize the flooding of ARP and ND messages in the VXLAN
> network, EVPN includes provisions [1] that allow participating VTEPs to
> suppress such messages in case they know the MAC-IP binding and can
> reply on behalf of the remote host. In Linux, the above is implemented
> in the bridge driver using a per-port option called "neigh_suppress"
> that was added in kernel version 4.15 [2].
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/9] bridge: Reorder neighbor suppression check when flooding
    https://git.kernel.org/netdev/net-next/c/013a7ce81dd8
  - [net-next,v2,2/9] bridge: Pass VLAN ID to br_flood()
    https://git.kernel.org/netdev/net-next/c/e408336a693e
  - [net-next,v2,3/9] bridge: Add internal flags for per-{Port, VLAN} neighbor suppression
    https://git.kernel.org/netdev/net-next/c/a714e3ec2308
  - [net-next,v2,4/9] bridge: Take per-{Port, VLAN} neighbor suppression into account
    https://git.kernel.org/netdev/net-next/c/6be42ed0a5f4
  - [net-next,v2,5/9] bridge: Encapsulate data path neighbor suppression logic
    https://git.kernel.org/netdev/net-next/c/3aca683e0654
  - [net-next,v2,6/9] bridge: Add per-{Port, VLAN} neighbor suppression data path support
    https://git.kernel.org/netdev/net-next/c/412614b1457a
  - [net-next,v2,7/9] bridge: vlan: Allow setting VLAN neighbor suppression state
    https://git.kernel.org/netdev/net-next/c/83f6d600796c
  - [net-next,v2,8/9] bridge: Allow setting per-{Port, VLAN} neighbor suppression state
    https://git.kernel.org/netdev/net-next/c/160656d7201d
  - [net-next,v2,9/9] selftests: net: Add bridge neighbor suppression test
    https://git.kernel.org/netdev/net-next/c/7648ac72dcd7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


