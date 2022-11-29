Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE43D63BEF9
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 12:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbiK2LaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 06:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbiK2LaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 06:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDCF43AD7;
        Tue, 29 Nov 2022 03:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C440616C6;
        Tue, 29 Nov 2022 11:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA175C433D7;
        Tue, 29 Nov 2022 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669721415;
        bh=PUlaidBpf2xkGSd4qFylC/FoAdatRiTWoy/lntihV94=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LujU2APGfw/IM+cxJpTd6KNi6glkCaU+DfwkTRn6HL8cy+/iTRJSU2plnG389L/pK
         pTigw6tvt/Bifw1r/lHydtoovE/nyb5Tqn3LW5uP2MszXKGX71NuwXpjZqDTdG2PCz
         BW/oP9e66b+2uaPQlmVM9txfULWaBAu42O+WNwoe4dipPLpNYJGJf62hJuCQLzWmb6
         PW0OOcY31ua/yww2ScEOG115qG+VNt/mTDNUoJSUmfKXRy0/e2TOjZsPLKwe7nd15Q
         +qitAOCjfBj2jSXkN1KfoA4PCPtJC6NNjctTOcuT7yh1FSWzCyyLE8wOO9Utw+esae
         3AYurcsemkebg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB666E29F38;
        Tue, 29 Nov 2022 11:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: tun: Fix use-after-free in tun_detach()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166972141476.8787.4197826127657020730.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 11:30:14 +0000
References: <20221124175134.1589053-1-syoshida@redhat.com>
In-Reply-To: <20221124175134.1589053-1-syoshida@redhat.com>
To:     Shigeru Yoshida <syoshida@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        jasowang@redhat.com,
        syzbot+106f9b687cd64ee70cd1@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 25 Nov 2022 02:51:34 +0900 you wrote:
> syzbot reported use-after-free in tun_detach() [1].  This causes call
> trace like below:
> 
> ==================================================================
> BUG: KASAN: use-after-free in notifier_call_chain+0x1ee/0x200 kernel/notifier.c:75
> Read of size 8 at addr ffff88807324e2a8 by task syz-executor.0/3673
> 
> [...]

Here is the summary with links:
  - [v3] net: tun: Fix use-after-free in tun_detach()
    https://git.kernel.org/netdev/net/c/5daadc86f27e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


