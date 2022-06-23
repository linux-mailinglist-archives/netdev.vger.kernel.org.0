Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8499E5575B1
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 10:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiFWIkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 04:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiFWIkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 04:40:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC4247AE9
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 01:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21E95B82215
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 08:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE996C3411B;
        Thu, 23 Jun 2022 08:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655973612;
        bh=h+qdn4T5sEE4YvO7VyM7tJGwP+MmM7V0+/Omu7PmP9I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A1M2zS8BltCjzdB+jPXG5cTxutEBlkyux8UJg5ESY9dYRH76jUrB5jrKLYR1nO+xC
         51YCAqbqP0U9lzoFl3O2HZRE+Kwtog8A4vuVlPlWK6a3gd9DdzG0F5PG+dKMu/Y2yK
         0vPp+Ty1Urlmz9V1sl6u7gRU8aPDgHxKswK4GIBRouEc+IF4Z1hOu5bPZysVP/DcXr
         XySwZyZERRKVyGFBIBo7KzhHmvd3RclQ/VsvSCAZLwt9X2C9VJhiTCX13BgJz0fyln
         BXP4Iaq1GYGVUVipjgco4EO4VtMNJjKxOmEaparaqhf2FbK8gweWmv+6kbPFOr+O6D
         0f+MsJx82v2iQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB271E73856;
        Thu, 23 Jun 2022 08:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] Revert "net/tls: fix tls_sk_proto_close executed
 repeatedly"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165597361276.31971.4377190749877849073.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 08:40:12 +0000
References: <20220620191353.1184629-1-kuba@kernel.org>
In-Reply-To: <20220620191353.1184629-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
        william.xuanziyang@huawei.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 20 Jun 2022 12:13:52 -0700 you wrote:
> This reverts commit 69135c572d1f84261a6de2a1268513a7e71753e2.
> 
> This commit was just papering over the issue, ULP should not
> get ->update() called with its own sk_prot. Each ULP would
> need to add this check.
> 
> Fixes: 69135c572d1f ("net/tls: fix tls_sk_proto_close executed repeatedly")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net,1/2] Revert "net/tls: fix tls_sk_proto_close executed repeatedly"
    https://git.kernel.org/netdev/net/c/1b205d948fbb
  - [net,2/2] sock: redo the psock vs ULP protection check
    https://git.kernel.org/netdev/net/c/e34a07c0ae39

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


