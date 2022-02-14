Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3254B52D1
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 15:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354944AbiBNOKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 09:10:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354936AbiBNOKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 09:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0732ACA
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 06:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B69760FC0
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 14:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03956C340F6;
        Mon, 14 Feb 2022 14:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644847811;
        bh=kdIkmZOUcwi0NYPRxten1LKpD7yE1r8qz9ntkcEBwiE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xn7f+nq6HVAwqPNQWEFipYB5vEuy0IcPMhowG8Pf2KXro3+rxeJtTLU+m929dmwGs
         YmZKj6vFDX52iTDPbjGHcuXs+hZ81clB3y/LWrTdwSmU3dwAwj24qy/31ltYxqL6cd
         PYZ2b8yKs0CdgPIEuQ96utjn02rtvC/+eKMf6rjNMqgb6Ir7pgFf9k7p3Dk/UNGZUY
         k1WFRPi9xxhrXGKlkecHt8ACYDPCBSLCWCN2mXGjL6S40X8azwFKV0QWLpa0Xnjhue
         Mm4VBlDp65Hti52qBGiephH2n4MsTWiQayYEfypz9MM7T+LXLUuXZlMyf7Xc/Pjv+/
         OIPdFzCFc/GSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6A8FE5D09D;
        Mon, 14 Feb 2022 14:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: blackhole_netdev needs snmp6 counters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164484781094.8191.2940437617413416994.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 14:10:10 +0000
References: <20220214021056.389298-1-eric.dumazet@gmail.com>
In-Reply-To: <20220214021056.389298-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, idosch@nvidia.com, syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 13 Feb 2022 18:10:56 -0800 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Whenever rt6_uncached_list_flush_dev() swaps rt->rt6_idev
> to the blackhole device, parts of IPv6 stack might still need
> to increment one SNMP counter.
> 
> Root cause, patch from Ido, changelog from Eric :)
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6: blackhole_netdev needs snmp6 counters
    https://git.kernel.org/netdev/net-next/c/dd263a8cb194

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


