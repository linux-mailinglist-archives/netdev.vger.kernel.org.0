Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE3F64C2C8
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 04:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237128AbiLNDaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 22:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiLNDaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 22:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2569422298
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 19:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB648B81689
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 03:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 953F2C433EF;
        Wed, 14 Dec 2022 03:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670988617;
        bh=xNz3cH+TbXNASTBfwLyF4qr7Ahh57c0nZsYDw9Zkg0I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nuXhFtH7mJvi6/l0zVdqxwh4qvh2dJkQoSqo96DRzywVS5qEkTg1/w45gFGhBOrk3
         o5pv1zaKsTqB+GGGe9GoWVf6LHEFCjNHOTc97Mcf6nEH7xWS7rEomOy7iHALmWoYap
         dtvzCX+9zXjiMZUD1ZsDSHOE7lMoBCP7C/F6q6qCWMZ4NKfWi5bfPZYRib9fKkpohu
         Jd4I3XM5DtY0tWy+gzARSGsbpTi+c3oPD7UXVtdCI203M8CqFWlO8xP0Phs3jthzrA
         PLVuuj34GXCpRfjqUDw+i+81PTVttqBl3WttSVvqY8BtPfa3YYiRgGD7B8PyucXyar
         VTtQ7RR9+0ZdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76ED6E4D02A;
        Wed, 14 Dec 2022 03:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] Bonding: fix high prio not effect issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167098861748.20181.2346186639120427683.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Dec 2022 03:30:17 +0000
References: <20221212035647.1053865-1-liuhangbin@gmail.com>
In-Reply-To: <20221212035647.1053865-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jtoppins@redhat.com, pabeni@redhat.com,
        edumazet@google.com, liali@redhat.com, saeed@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Dec 2022 11:56:44 +0800 you wrote:
> When a high prio link up, if there has current link, it will not do
> failover as we missed the check in link up event. Fix it in this patchset
> and add a prio option test case.
> 
> v2:
> 1. use rcu_access_pointer() instead of rtnl_dereference().
> 2: make do_failover after looping all slaves
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net,1/3] bonding: add missed __rcu annotation for curr_active_slave
    https://git.kernel.org/netdev/net/c/3d0b738fc5ad
  - [PATCHv2,net,2/3] bonding: do failover when high prio link up
    https://git.kernel.org/netdev/net/c/e95cc44763a4
  - [PATCHv2,net,3/3] selftests: bonding: add bonding prio option test
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


