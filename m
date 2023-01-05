Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8188765E4CF
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjAEEow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjAEEo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:44:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A7551318
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:44:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 048A4B819C9
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9814EC433F0;
        Thu,  5 Jan 2023 04:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672893851;
        bh=eDIZnAiC7H+k5iZqYjsd5E0+EP4kiQ7S31x8z95PO+4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mvS3o3lUjUcbRziIIDKUDpWrt/DoVnZ70Y/T7hjXFAOiou0inSW07/DcjY4QqP/ot
         jdcfQ2QEqC5st99T5uge5onSmi60NIlew1voOBhTvO7jxS/s3DDXNDjKxMJpVSnF8C
         yJC/PHAMzlXAqEKcedSiVctudcC7qMZJsBp+Y4kuMdRTFJPgg04cY/YwfG146s6v9c
         zRgnTHsEgiP0AuYYEtGzToXyyEuDAfAB2riuEAfMIOACkYB0vDq/ROcMt5GBFaDMNd
         LYOPZeVJ4SdU/99biUxngEr9m4XoPAPzTWEo7JdHr1q4BLJex5hmUMWF3Oq4Vhkzh5
         B5kyi3P/LMtLQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C89FE5724A;
        Thu,  5 Jan 2023 04:44:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] inet: control sockets should not use current thread
 task_frag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167289385150.19861.4532286036655661620.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Jan 2023 04:44:11 +0000
References: <20230103192736.454149-1-edumazet@google.com>
In-Reply-To: <20230103192736.454149-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzbot+bebc6f1acdf4cbb79b03@syzkaller.appspotmail.com,
        gnault@redhat.com, bcodding@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  3 Jan 2023 19:27:36 +0000 you wrote:
> Because ICMP handlers run from softirq contexts,
> they must not use current thread task_frag.
> 
> Previously, all sockets allocated by inet_ctl_sock_create()
> would use the per-socket page fragment, with no chance of
> recursion.
> 
> [...]

Here is the summary with links:
  - [net] inet: control sockets should not use current thread task_frag
    https://git.kernel.org/netdev/net/c/1ac885574470

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


