Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D9E4EDE9F
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239826AbiCaQWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239816AbiCaQV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:21:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465931F160C
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 09:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB4EA612B1
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 16:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1EA7BC34112;
        Thu, 31 Mar 2022 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648743611;
        bh=/N8Jh4jDTLPyvrQ2/Ot2aQ/ngwHurX0F11o1drKbBws=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WVycNSY1HxBuiJy4JWDUGo000N6cl9MahTuSOt0eS/HfMzYAgbldedZMORFDQtn1V
         vNldPqJB6J5KgwzlQ7xxuO6VZEbjwoEuBOfqLiC29/b1VhuyMRyg5dFgWz+M7y36B5
         VYKz4gGujuJYCEpsBzfSs9qa0z6LP8B4cOadHzQSV1XvxvECcg9KyGTYu2adUNHole
         f3mz1WsyWOpjW8I1eBYri1NSzqa6e57qaFdY+U6PRyl52psH/60YTSFPmmA5dlo6sp
         D2kvzGPWdLPBHwcKVuZx3H/OHnadZwcHyYt6Vm/5wp5qV5i3rlw1dlMLuQCd1HZ5nS
         5pub/XMJDp2tA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3A04EAC09B;
        Thu, 31 Mar 2022 16:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vxlan: do not feed vxlan_vnifilter_dump_dev with non
 vxlan devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164874361099.27032.14828662809698790028.git-patchwork-notify@kernel.org>
Date:   Thu, 31 Mar 2022 16:20:10 +0000
References: <20220330194643.2706132-1-eric.dumazet@gmail.com>
In-Reply-To: <20220330194643.2706132-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com, roopa@nvidia.com,
        syzkaller@googlegroups.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 30 Mar 2022 12:46:43 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> vxlan_vnifilter_dump_dev() assumes it is called only
> for vxlan devices. Make sure it is the case.
> 
> BUG: KASAN: slab-out-of-bounds in vxlan_vnifilter_dump_dev+0x9a0/0xb40 drivers/net/vxlan/vxlan_vnifilter.c:349
> Read of size 4 at addr ffff888060d1ce70 by task syz-executor.3/17662
> 
> [...]

Here is the summary with links:
  - [net] vxlan: do not feed vxlan_vnifilter_dump_dev with non vxlan devices
    https://git.kernel.org/netdev/net/c/9d570741aec1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


