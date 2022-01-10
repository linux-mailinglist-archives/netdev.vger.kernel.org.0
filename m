Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F174488DA8
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbiAJBAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbiAJBAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AAEC061748
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 17:00:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3FB26109A
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 01:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3817BC36AF2;
        Mon, 10 Jan 2022 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776409;
        bh=sLhYql/jns/crEi7TdrjWgWmo9vY2U6elOwYC0BXkLQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tkyO8ugKciDbsDjAht+4PbXRY7YQEmStYIoVtwJzrk0RMldmECcY2AY/q4ifyctJY
         dOxXguw2DtuJaWKjik5pPsYmNBXalNDiv1pXnT2GgqbqrlG2+S8AyE6BemetLVM+zZ
         TsmhVL+AogRqzG2TA7tojRRZ7J8VjdUDkNu/wwiAHVOfido41h7yWh0cwCQWMDuMoq
         runtpuE7PPST47/bfe8fMlvAHyURB5FNsw1nxoiFNPgkgZg5zhWY9OqIknUxqU+ywO
         40cjPgfjLffIjKmXde2j+QqFEOlSV75MuBa9CqVI6HNkaI3PQYD7DkkQT5ZtqR3CxA
         aFeSiWOAx3ksA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C93DF6078E;
        Mon, 10 Jan 2022 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/1] net: openvswitch: Fix ct_state nat flags for conns
 arriving from tc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177640911.18208.11219008492707662501.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:09 +0000
References: <20220106153804.26451-1-paulb@nvidia.com>
In-Reply-To: <20220106153804.26451-1-paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jhs@mojatatu.com, pshelar@ovn.org,
        davem@davemloft.net, jiri@nvidia.com, kuba@kernel.org,
        saeedm@nvidia.com, ozsh@nvidia.com, vladbu@nvidia.com,
        roid@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 6 Jan 2022 17:38:04 +0200 you wrote:
> Netfilter conntrack maintains NAT flags per connection indicating
> whether NAT was configured for the connection. Openvswitch maintains
> NAT flags on the per packet flow key ct_state field, indicating
> whether NAT was actually executed on the packet.
> 
> When a packet misses from tc to ovs the conntrack NAT flags are set.
> However, NAT was not necessarily executed on the packet because the
> connection's state might still be in NEW state. As such, openvswitch
> wrongly assumes that NAT was executed and sets an incorrect flow key
> NAT flags.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] net: openvswitch: Fix ct_state nat flags for conns arriving from tc
    https://git.kernel.org/netdev/net/c/6f022c2ddbce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


