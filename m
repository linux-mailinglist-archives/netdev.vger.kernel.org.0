Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058386BE398
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjCQIcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjCQIcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:32:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B0924BF8
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 01:31:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D50C6222A
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F7E2C4339B;
        Fri, 17 Mar 2023 08:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679041821;
        bh=cbl/8kY59m0VJBtiWs1fFUFoxkXKmWi7XtVc3FRjM5Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dg5vl+q4w0KSsLyQ7H3KLJ0yT3HK/NFNZwrnJx22uO521jyy/7WkWgPIQdV+cBdsW
         nSgpbbvZfM1mDIk5EBvZaZSv2WWAkEozhpbEPzNQS+Ptg1QaoPf6A6FJHc7L2+MlrR
         wL0lGgin3YRvWQNJG++d/1wumutsR7m9BQJKhKWHHL31pmwTD97Wir9b4llW2GLGZd
         w0FCiZ8Z15+lP29U+TYh1SICxAaIJJXvr/AOL1IKkfbeM8HDTqrYls8nClFp1jZiVM
         wfZy/hrmJzJD4glvwC7SMm9KK723R3TT1jAZDNsQ1PH0yHrYXCs/7FLyhUyExs7RLJ
         yEwe2dfVTsm5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 736D7E21EE9;
        Fri, 17 Mar 2023 08:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/11] vxlan: Add MDB support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167904182146.13932.7277544520750366068.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 08:30:21 +0000
References: <20230315131155.4071175-1-idosch@nvidia.com>
In-Reply-To: <20230315131155.4071175-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Mar 2023 15:11:44 +0200 you wrote:
> tl;dr
> =====
> 
> This patchset implements MDB support in the VXLAN driver, allowing it to
> selectively forward IP multicast traffic to VTEPs with interested
> receivers instead of flooding it to all the VTEPs as BUM. The motivating
> use case is intra and inter subnet multicast forwarding using EVPN
> [1][2], which means that MDB entries are only installed by the user
> space control plane and no snooping is implemented, thereby avoiding a
> lot of unnecessary complexity in the kernel.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/11] net: Add MDB net device operations
    https://git.kernel.org/netdev/net-next/c/8c44fa12c8fa
  - [net-next,v2,02/11] bridge: mcast: Implement MDB net device operations
    https://git.kernel.org/netdev/net-next/c/c009de1061b5
  - [net-next,v2,03/11] rtnetlink: bridge: mcast: Move MDB handlers out of bridge driver
    https://git.kernel.org/netdev/net-next/c/cc7f5022f810
  - [net-next,v2,04/11] rtnetlink: bridge: mcast: Relax group address validation in common code
    https://git.kernel.org/netdev/net-next/c/da654c80a0eb
  - [net-next,v2,05/11] vxlan: Move address helpers to private headers
    https://git.kernel.org/netdev/net-next/c/f307c8bf37a3
  - [net-next,v2,06/11] vxlan: Expose vxlan_xmit_one()
    https://git.kernel.org/netdev/net-next/c/6ab271aaad25
  - [net-next,v2,07/11] vxlan: mdb: Add MDB control path support
    https://git.kernel.org/netdev/net-next/c/a3a48de5eade
  - [net-next,v2,08/11] vxlan: mdb: Add an internal flag to indicate MDB usage
    https://git.kernel.org/netdev/net-next/c/bc6c6b013ffe
  - [net-next,v2,09/11] vxlan: Add MDB data path support
    https://git.kernel.org/netdev/net-next/c/0f83e69f44bf
  - [net-next,v2,10/11] vxlan: Enable MDB support
    https://git.kernel.org/netdev/net-next/c/08f876a7d79e
  - [net-next,v2,11/11] selftests: net: Add VXLAN MDB test
    https://git.kernel.org/netdev/net-next/c/62199e3f1658

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


