Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232B266BCED
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjAPLam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjAPLaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:30:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A761F4A3
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 03:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08DBD60F7B
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 11:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 560FCC433F0;
        Mon, 16 Jan 2023 11:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673868616;
        bh=/34I9lVzsPTJb4398uI4DPfixBtWO1J6acrvoxfZP7c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o5YVNEjkwirSj6r7J7v+xViPXP4kkC+ICTzm8EGkFEbGT6xQ+VMq3KLP1gakWnfNk
         GlKWkendykVp5qEfsuR7Rcoo7NBRarZTDsCXKg54ofjDY9Y7UgsV/a7X6A7wLSO17h
         FtrNistwaOtR5PJbVynwYXUPc/Tx3ZMV9WiZqHc2qcAQoGV9SYEBgoFtgKTPiFQRPG
         UZZwpYO/eUpf4LhN+hdcbNY5TIurrO7B4x9uGrblGo5HUKrsfhdTG58mngefYggaWv
         7Fa+J6uYnZbfDiA6KVIy65TSefTIetXZCL54+jwPx7aNFReXv+DO5gKn3khREMP4/a
         DcJ6gDCa44yXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 329D7E54D2A;
        Mon, 16 Jan 2023 11:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] unix: Improve locking scheme in
 unix_show_fdinfo()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167386861620.7624.707492607828278885.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Jan 2023 11:30:16 +0000
References: <c6c7084c-56c7-cd37-befe-df718e080597@ya.ru>
In-Reply-To: <c6c7084c-56c7-cd37-befe-df718e080597@ya.ru>
To:     Kirill Tkhai <tkhai@ya.ru>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuniyu@amazon.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 14 Jan 2023 12:35:02 +0300 you wrote:
> After switching to TCP_ESTABLISHED or TCP_LISTEN sk_state, alive SOCK_STREAM
> and SOCK_SEQPACKET sockets can't change it anymore (since commit 3ff8bff704f4
> "unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()").
> 
> Thus, we do not need to take lock here.
> 
> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] unix: Improve locking scheme in unix_show_fdinfo()
    https://git.kernel.org/netdev/net-next/c/b27401a30ee4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


