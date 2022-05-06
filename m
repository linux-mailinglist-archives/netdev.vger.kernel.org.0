Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6048F51CEF9
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388305AbiEFCYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 22:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388328AbiEFCX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 22:23:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CA72624
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 19:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2262B831CD
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 02:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58E0DC385AC;
        Fri,  6 May 2022 02:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651803613;
        bh=j+6BGiPTO3E/mW2NwULlDaHPBcBa1H2rq7yRLvwIOOo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F9h3g2ExgHPXVRxqAf8WXZwoykSLQis2d1nFtEbprHHi31dlrY2JPqqejoEHY8WZz
         8Q4Atyz2EmuexBa7yQFzLEtPhlAZBWSk5RPNTv9byd9F4AS4FLgGZ86+tEXO4MHQum
         ozSeMH9yeTadxpwyv0sveiQcL9oGypESiYwZDH7pGTdzHv8az9rhYGuu6LOab6/laB
         ngJGnJeuv465N2FsE6BrDxsggwarE8IzTSGBGEs+zwg0lSVrAeYWpap17HHKyNg5c7
         +L28RmvzdlZE5uRuwUOrjpR+6mqLdTwbwbId/xqgUlLN5aWT+iVTSPcL1lb8rAcqYP
         4WpoRvDDZdbbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38675F03874;
        Fri,  6 May 2022 02:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] mptcp: Improve MPTCP-level window tracking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165180361322.11309.2801636924198252902.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 02:20:13 +0000
References: <20220504215408.349318-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220504215408.349318-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 May 2022 14:54:03 -0700 you wrote:
> This series improves MPTCP receive window compliance with RFC 8684 and
> helps increase throughput on high-speed links. Note that patch 3 makes a
> change in tcp_output.c
> 
> For the details, Paolo says:
> 
> I've been chasing bad/unstable performance with multiple subflows
> on very high speed links.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] mptcp: really share subflow snd_wnd
    https://git.kernel.org/netdev/net-next/c/b713d0067574
  - [net-next,2/5] mptcp: add mib for xmit window sharing
    https://git.kernel.org/netdev/net-next/c/92be2f522777
  - [net-next,3/5] tcp: allow MPTCP to update the announced window
    https://git.kernel.org/netdev/net-next/c/ea66758c1795
  - [net-next,4/5] mptcp: never shrink offered window
    https://git.kernel.org/netdev/net-next/c/f3589be0c420
  - [net-next,5/5] mptcp: add more offered MIBs counter
    https://git.kernel.org/netdev/net-next/c/38acb6260f60

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


