Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4AA362F2C1
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 11:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241247AbiKRKkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 05:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiKRKkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 05:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA4B1B9DF;
        Fri, 18 Nov 2022 02:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E372662428;
        Fri, 18 Nov 2022 10:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B1A5C433D6;
        Fri, 18 Nov 2022 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668768016;
        bh=rFrsercBtRHJomGCLpcMsmxtrpGC8ffnHIYQv47hOTE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W4hS07/sZ2zE3CvEAScKsqPcMzYXVC+gbMlbREMYjVBL+UQNjD4CSUkWvbCHVS2eF
         k97UXP1U2tcVBdWnQuEInIjAsJH46XS3+2ZZ3HPyd4ilmVcJcBNPJSkaMFWgHmLhzI
         aeqMGQz8/IUaQH6s+XMJZIr0mVw6y8tFKs98ueFNumtEQEyvCZEUnkZWn0dxD3eB7r
         fbd8WiuC2guRjejfLVb0nySraQbkWqZjvhTSGLc95wRItWaJvORUE1yuZA81jV2j+D
         B0VHvd1ulWD/wmSnuFZLbgQ7CWfaxdllOmrfX0kpw9Hedcx8YSiWaf+91XNaxCASeG
         QnWa7AdIsUKlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16A2AE29F43;
        Fri, 18 Nov 2022 10:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: neigh: decrement the family specific qlen
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166876801608.1818.5528288792107220995.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 10:40:16 +0000
References: <Y3QNGHkhvWnxo2LD@x1.ze-it.at>
In-Reply-To: <Y3QNGHkhvWnxo2LD@x1.ze-it.at>
To:     Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
Cc:     pabeni@redhat.com, davem@davemloft.net,
        alexander.mikhalitsyn@virtuozzo.com, den@openvz.org,
        edumazet@google.com, kuba@kernel.org, dsahern@kernel.org,
        daniel@iogearbox.net, yangyingliang@huawei.com,
        songmuchun@bytedance.com, vasily.averin@linux.dev,
        wangyuweihx@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 15 Nov 2022 23:09:41 +0100 you wrote:
> Commit 0ff4eb3d5ebb ("neighbour: make proxy_queue.qlen limit
> per-device") introduced the length counter qlen in struct neigh_parms.
> There are separate neigh_parms instances for IPv4/ARP and IPv6/ND, and
> while the family specific qlen is incremented in pneigh_enqueue(), the
> mentioned commit decrements always the IPv4/ARP specific qlen,
> regardless of the currently processed family, in pneigh_queue_purge()
> and neigh_proxy_process().
> 
> [...]

Here is the summary with links:
  - [v2] net: neigh: decrement the family specific qlen
    https://git.kernel.org/netdev/net/c/8207f253a097

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


