Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6155592DA2
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 13:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiHOLAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 07:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiHOLAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 07:00:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C872DA
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 04:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F0FB9CE0FCF
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11E9FC433B5;
        Mon, 15 Aug 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660561216;
        bh=YNH3QZKWKutnAqnDSa9j46EAX6LA7+6lHHagqbdUUKY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PFLALiwSd20v9nZcpFJf3WKfBEC7Xdz8jzGC2FZ8g+aLtIvr700DL3Ii5bR+Cx5lr
         78EUilhBGV7erHH/O+IL9fn8GQbqYtrgNPXzNEfDz0unKFEuy0kkGax3PxgTH5vAAa
         yRzzFeC1eTYKG/XWUTyPZLj4OpaKYDOOW7HMDKIIWAH+QcOL7InYwlmf6q9GFiYgWp
         R9gTkkuJxOXMV8/clQlP38/a7U7SwINF7IGD5UQjrxdKWGk73TDVBjRvrNaXalzTZX
         +v/VRAflZOl2sIDJjnG0mMBndjCiG/1Mah2p7PT+G/ou1oneNDqo489rE6CAPBUx66
         6wph978mz1SmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E3FE3E2A051;
        Mon, 15 Aug 2022 11:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net_sched: cls_route: disallow handle of 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166056121592.24739.9305141105554811084.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Aug 2022 11:00:15 +0000
References: <20220814112758.3088655-1-jhs@mojatatu.com>
In-Reply-To: <20220814112758.3088655-1-jhs@mojatatu.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuznet@ms2.inr.ac.ru,
        cascardo@canonical.com, linux-distros@vs.openwall.org,
        security@kernel.org, stephen@networkplumber.org, dsahern@gmail.com,
        gregkh@linuxfoundation.org
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
by David S. Miller <davem@davemloft.net>:

On Sun, 14 Aug 2022 11:27:58 +0000 you wrote:
> Follows up on:
> https://lore.kernel.org/all/20220809170518.164662-1-cascardo@canonical.com/
> 
> handle of 0 implies from/to of universe realm which is not very
> sensible.
> 
> Lets see what this patch will do:
> $sudo tc qdisc add dev $DEV root handle 1:0 prio
> 
> [...]

Here is the summary with links:
  - [net,1/1] net_sched: cls_route: disallow handle of 0
    https://git.kernel.org/netdev/net/c/02799571714d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


