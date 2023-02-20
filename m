Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B39969CA38
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjBTLuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbjBTLuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:50:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB57510C1
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 03:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3DC1BCE0F58
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 11:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C2A2C433EF;
        Mon, 20 Feb 2023 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676893816;
        bh=MMCstRtQpaH4dAE7x+YrUjDFBnnzkoTgoFnb3sXzIJc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KsvxnKImU0tBhJCYTc6cajdGKymkLS3zymmWkH4A0JjtrETPYsl8MSwsKifZWliAI
         raLc84GN/XRQYb/yrXQskYTjWMKFr/qo+mlxAiDPN8s5nXJGt712wvHd7kZEQtDqG6
         vVoRwp+9XcpVgSTmNZF4LYMx1QrHGWow13x/7xVylD5faRISUM4+I5f2NoZU7hn/Zk
         DdQPUkfj7he1wvVA26HZkzZDXB15HBvUJ0yTgO/DVtPm/x6wXwGNUsoJNGjmxlvHbo
         g5YrlyMWPUxLMzjx5muicGKgrsOTNcDGxampXcB8BlsWPwrz7AjuvvICZMT8on+rtn
         a9DKiXt2TRvKw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76B90E68D23;
        Mon, 20 Feb 2023 11:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] scm: add user copy checks to put_cmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167689381648.15107.12443340858774771825.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 11:50:16 +0000
References: <20230217182454.2432057-1-edumazet@google.com>
In-Reply-To: <20230217182454.2432057-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        keescook@chromium.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Feb 2023 18:24:54 +0000 you wrote:
> This is a followup of commit 2558b8039d05 ("net: use a bounce
> buffer for copying skb->mark")
> 
> x86 and powerpc define user_access_begin, meaning
> that they are not able to perform user copy checks
> when using user_write_access_begin() / unsafe_copy_to_user()
> and friends [1]
> 
> [...]

Here is the summary with links:
  - [net-next] scm: add user copy checks to put_cmsg()
    https://git.kernel.org/netdev/net-next/c/5f1eb1ff58ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


