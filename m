Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A34B56AA5D
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 20:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbiGGSUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 14:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236005AbiGGSUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 14:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE684D4ED;
        Thu,  7 Jul 2022 11:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9AB0B823CA;
        Thu,  7 Jul 2022 18:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22D80C341C0;
        Thu,  7 Jul 2022 18:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657218013;
        bh=gmKbwdmPu+vXtmvItExaixY2JC0je8fysM9xYKX1b0M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nkl6eLpYNQ7NM1AaJfcFRuEJFTb1XJDAyIp97VciTKPnLWfqWpoJTx2nDDo4UBvK+
         VwIKcp2eXhKm5W4iJVU5GG2W8lJfxRWgD/m5M382qI46VlbrolmI+lxSS5AJjXxC0G
         3RuPCcn68E8PirKtD0Jx9H4+wj9nNxRrYDm4C7iguJ1FJPp6THQO5pNsdar8rx5ZVM
         wtiF3WcwFmNeb3FVxXkNHJZIa1vXG0wbuTbHbLV/GBuIi++0lGGqhOb7qXI39FJEjl
         Rl+umFuv4f9cSujhJgZfQtCxfCSCMHSbvafKkTvq8wnIHPOIRS25MQQCRqMsKYbn9b
         nwau6qDo+AGRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0617FE45BDA;
        Thu,  7 Jul 2022 18:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: make sure mac_header was set before using it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165721801302.2116.12763817658962623961.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jul 2022 18:20:13 +0000
References: <20220707123900.945305-1-edumazet@google.com>
In-Reply-To: <20220707123900.945305-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        eric.dumazet@gmail.com, syzkaller@googlegroups.com
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

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu,  7 Jul 2022 12:39:00 +0000 you wrote:
> Classic BPF has a way to load bytes starting from the mac header.
> 
> Some skbs do not have a mac header, and skb_mac_header()
> in this case is returning a pointer that 65535 bytes after
> skb->head.
> 
> Existing range check in bpf_internal_load_pointer_neg_helper()
> was properly kicking and no illegal access was happening.
> 
> [...]

Here is the summary with links:
  - bpf: make sure mac_header was set before using it
    https://git.kernel.org/bpf/bpf/c/0326195f523a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


