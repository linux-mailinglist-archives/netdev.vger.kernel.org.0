Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA3C535E0E
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 12:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243292AbiE0KUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 06:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbiE0KUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 06:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B13A127193;
        Fri, 27 May 2022 03:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0049261A7E;
        Fri, 27 May 2022 10:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 341EAC34100;
        Fri, 27 May 2022 10:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653646813;
        bh=jvnPReh8DPVAulPqNc7lgpX+gkU6l71D8r+uEIYci3k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iT599zI4LiJKqphntBpME2QCkl4tucbxOsyeCFTfsdp1Lz2Ih9rhOKRL2XH7AlJTX
         6jtgeNAXFS9Ykk3gz2UOHW5hTKvNL7aMxjgiEWISF0IM0e9t/LYpAsc8rWsbZ/8o+o
         OqK5echCnFvTaRJeyMlSLCJ09amrPtA9eGUABX5rOdh3GTosZcfIX9dsMaK8u2fE2g
         MK6mnyJEdyowDaAWhgHQk64yivZyTR6yvmRANiCa6Q/rdkYMCqSFfiyp61mjEJ8FoF
         OhXP9gMJp7noWiTr/9TouTHk4dZt1t4ANznzOy/LjDZBmFtQa2/gGIE81r0tILPz8a
         FSkG9dL8Iiasg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18FE4EAC081;
        Fri, 27 May 2022 10:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: nfnetlink: fix warn in nfnetlink_unbind
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165364681309.2785.11914681329235837316.git-patchwork-notify@kernel.org>
Date:   Fri, 27 May 2022 10:20:13 +0000
References: <20220527092023.327441-2-pablo@netfilter.org>
In-Reply-To: <20220527092023.327441-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 27 May 2022 11:20:20 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> syzbot reports following warn:
> WARNING: CPU: 0 PID: 3600 at net/netfilter/nfnetlink.c:703 nfnetlink_unbind+0x357/0x3b0 net/netfilter/nfnetlink.c:694
> 
> The syzbot generated program does this:
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: nfnetlink: fix warn in nfnetlink_unbind
    https://git.kernel.org/netdev/net/c/ffd219efd9ee
  - [net,2/4] netfilter: conntrack: re-fetch conntrack after insertion
    https://git.kernel.org/netdev/net/c/56b14ecec97f
  - [net,3/4] netfilter: cttimeout: fix slab-out-of-bounds read in cttimeout_net_exit
    https://git.kernel.org/netdev/net/c/aeed55a08d0b
  - [net,4/4] netfilter: nf_tables: set element extended ACK reporting support
    https://git.kernel.org/netdev/net/c/b53c11664250

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


