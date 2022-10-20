Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9951605495
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 02:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiJTAu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 20:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiJTAuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 20:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B472DCAD3
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 17:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5748D6131F
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 00:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4B30C433D7;
        Thu, 20 Oct 2022 00:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666227016;
        bh=+IJEuv0PTELYvRufVsKZU1taRmAEWg4GuU7SsPouzYY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=txbU+oReeCs4e50Ohgf54yPieSxDIvcRCTRmPqwu8raYD9eUQ7IF05syQoxp4fK7u
         Jp0+jjfakzM1zX4kc/h0NIM7N4jY35Jnvcwd733g39P+hbCt6wPMl7ImmiGH1mNYel
         ojKuzu/BtdEuzg8j/9r0+S6jlFnM5E/VlacA5geAI7l9QpqSntdNk9b0gvS0hw9tii
         fvIowmlRGEjxsEFSd11deKnoQjaQsiNH/ENfvCPvFON/K1c3R1FbaqcMTp/fsgnovf
         GviPnKsNEu+OJAXimXmnO4uhzUIsX1MdbXULN2mDjvVgAtuGHlWV2DNLn8SLE8Uyuk
         0e4JeP2ZcjDwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9EC82E29F37;
        Thu, 20 Oct 2022 00:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sched: fix race condition in qdisc_graft()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166622701664.778.15488892117399826495.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Oct 2022 00:50:16 +0000
References: <20221018203258.2793282-1-edumazet@google.com>
In-Reply-To: <20221018203258.2793282-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        eric.dumazet@gmail.com, syzkaller@googlegroups.com,
        dvyukov@google.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 18 Oct 2022 20:32:58 +0000 you wrote:
> We had one syzbot report [1] in syzbot queue for a while.
> I was waiting for more occurrences and/or a repro but
> Dmitry Vyukov spotted the issue right away.
> 
> <quoting Dmitry>
> qdisc_graft() drops reference to qdisc in notify_and_destroy
> while it's still assigned to dev->qdisc
> </quoting>
> 
> [...]

Here is the summary with links:
  - [net] net: sched: fix race condition in qdisc_graft()
    https://git.kernel.org/netdev/net/c/ebda44da44f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


