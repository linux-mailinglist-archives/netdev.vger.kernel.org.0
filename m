Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911F34BB8DB
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 13:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbiBRMK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 07:10:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbiBRMK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 07:10:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD221AC9D3
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 04:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB344B82585
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 12:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5DDD3C340EB;
        Fri, 18 Feb 2022 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645186209;
        bh=2lp25VV4ZOmCBD46WltTGVYHHNAc1/AyuqHEikz2Dp8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bLwXYovSVaiBIp2tUPcUE4wvZA3VeXlinQlLFILR9H1wtkZM6fcvUyI0YTaB5OTTs
         hanM8RiMvG92FHZEoeLxUa9MKZY0Pmq83uAahGlK5aOCwEu8hX7iHEtEMab/msFQ1f
         6PA3O92XMNsIMc6zJ1yXStlf+bK1l+uCE3ExoHJpzPCaoWvPjGFJ17vdTER25pl/Kv
         2OWf4XDr6qFDSLgeZ6cTfSDkiSO8ve7xDkK9LRg/XjxCsduWmovwWRkb5k1EfS/emV
         MEdKNMoEHLLgCbyZAkyHXnB2UaPg6DQam1zrjSkRXlnHxcUIDwEFD9YUzcp7J/fLCG
         SPA5k+CyfjcZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A489E5D07D;
        Fri, 18 Feb 2022 12:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: annotate some data-races around sk->sk_prot
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164518620929.21654.16519132087567182291.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 12:10:09 +0000
References: <20220217234841.1222299-1-eric.dumazet@gmail.com>
In-Reply-To: <20220217234841.1222299-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
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

On Thu, 17 Feb 2022 15:48:41 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> IPv6 has this hack changing sk->sk_prot when an IPv6 socket
> is 'converted' to an IPv4 one with IPV6_ADDRFORM option.
> 
> This operation is only performed for TCP and UDP, knowing
> their 'struct proto' for the two network families are populated
> in the same way, and can not disappear while a reader
> might use and dereference sk->sk_prot.
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6: annotate some data-races around sk->sk_prot
    https://git.kernel.org/netdev/net-next/c/086d49058cd8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


