Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF7C5AD46D
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 16:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238272AbiIEOAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 10:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238252AbiIEOAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 10:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0AA101E9;
        Mon,  5 Sep 2022 07:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11269B811E0;
        Mon,  5 Sep 2022 14:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF067C433D6;
        Mon,  5 Sep 2022 14:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662386414;
        bh=XSSZTD2ALu36RR1GIQU7d/Edf2hF0Lo9I0MxTJEt9wk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AsRmGm9gXizIaHVFqbK7m9xJApGH6O4wmI0ylwbO0Xrb3mdn8Aj+1sbaT7pCyQPpJ
         x6o6vLq/Ape+j/U0tLaIEhgpdD55wBhq4ZASeMHXwxA2E3xnFyHqdzQ3sJ/VyJWM2s
         ok/XmsBeqavC5vIWqByFiTfJQbHI3i14CcOG4hJZ9YRIXjc5bqpu0bPW6kb7svE8A7
         nmyTOBIStY/1NLYFHcU30gtwC9ixY81GxnZqGPZR+nEwHbDibbVjRAwyyVRng+nDYI
         I6cOZA1vOHhG1H+dNqM8/rAas0oE3F4m1+8Cwz/Xwq8/q9j6Jr2DOCsnOkwi4HA9B+
         4b4GlJrYj/AJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 994F3C73FE8;
        Mon,  5 Sep 2022 14:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] netlink: Bounds-check struct nlmsgerr creation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166238641462.11602.3818616103545497339.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 14:00:14 +0000
References: <20220903043749.3102675-1-keescook@chromium.org>
In-Reply-To: <20220903043749.3102675-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     kuba@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, syzkaller@googlegroups.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Sep 2022 21:37:49 -0700 you wrote:
> In preparation for FORTIFY_SOURCE doing bounds-check on memcpy(),
> switch from __nlmsg_put to nlmsg_put(), and explain the bounds check
> for dealing with the memcpy() across a composite flexible array struct.
> Avoids this future run-time warning:
> 
>   memcpy: detected field-spanning write (size 32) of single field "&errmsg->msg" at net/netlink/af_netlink.c:2447 (size 16)
> 
> [...]

Here is the summary with links:
  - [v4] netlink: Bounds-check struct nlmsgerr creation
    https://git.kernel.org/netdev/net-next/c/710d21fdff9a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


