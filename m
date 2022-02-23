Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093904C06F7
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236581AbiBWBkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiBWBkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:40:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01C54E38C
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 17:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37CCB61480
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 01:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83E88C340F1;
        Wed, 23 Feb 2022 01:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645580409;
        bh=prseocMgnZMR6xSNtFy325XeTAwI2AWmgNBjxuwhF8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rAZ8/C3odNZaYBd+i6SjIGcXuO8fANM976FbdXXjTwwAsZFD1Zg21BREOUOvLl1V2
         KeEualosVeo4uISpQEkhAkJbJ7TKJzAcPw5XWMq72AKswe71CbGXpn2LDHFiPXauxH
         rQ6Umu2UufnHiAl1e/uo3moYj4PCHn8cmz9mxQKyG6l4Y0gzxxlHl7PVyQimFDFjL6
         rsbX+xoZoBo66Mbv7beNORsAk+8BXOJnC3p6nyxT+yC5UJeSfr5+ghoO5yiS6mKR5W
         DBDJvkWU/myWvlP4s6LN+parIZ/bGiEq7LjzFyaNHSd7hb0nN9tSQuSnlKJBzGlI4S
         kjl8uU5gHOuaA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69378E73590;
        Wed, 23 Feb 2022 01:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: tcp: consistently use MAX_TCP_HEADER
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164558040942.12003.10715542634405886412.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 01:40:09 +0000
References: <20220222031115.4005060-1-eric.dumazet@gmail.com>
In-Reply-To: <20220222031115.4005060-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 21 Feb 2022 19:11:15 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> All other skbs allocated for TCP tx are using MAX_TCP_HEADER already.
> 
> MAX_HEADER can be too small for some cases (like eBPF based encapsulation),
> so this can avoid extra pskb_expand_head() in lower stacks.
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6: tcp: consistently use MAX_TCP_HEADER
    https://git.kernel.org/netdev/net-next/c/0ebea8f9b81c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


