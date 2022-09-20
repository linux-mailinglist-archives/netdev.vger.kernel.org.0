Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800B55BD97C
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiITBkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiITBkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44973DF26;
        Mon, 19 Sep 2022 18:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 817BEB822FF;
        Tue, 20 Sep 2022 01:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C30FC433D7;
        Tue, 20 Sep 2022 01:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663638017;
        bh=rwLvn3VkBU5KV5IslYbkFXJLACc79KCCalOdlifBzR8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qWCklRA1NXon8XI6F+w6RN2hGAwQ/uecsnaJGZoA2mvngswqjo80p/hqh9QuDfCkr
         4BjpGJ9Z82nI4+cy+46j+wvGEypmz2d5YQ9AKVAUdH1yVcg26MpaktNdq8s36LD7FP
         UUfePb4dRTUaq2gzOaPgylgkLKFl0sp+Lde0w6dzRwDnlYeMKAM0UZH+PUZ+gtyXD/
         OkI4IqorWvOcfo2zkipxyT45/ShQoyT2ftzBgl+4hpZLrfetL8tltAsJnt5PLGTmqL
         uy0eFDXzSifPj1C1w2elmZSZM5TAkBmZYt/AG+YSmniFRLWXlghS3tGMDDT88ZQGfi
         gdI6sqQe8FlWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 06B19C43141;
        Tue, 20 Sep 2022 01:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: korina: Fix return type of korina_send_packet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363801702.6857.15735774566278514927.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:40:17 +0000
References: <20220912214344.928925-1-nhuck@google.com>
In-Reply-To: <20220912214344.928925-1-nhuck@google.com>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     error27@gmail.com, llvm@lists.linux.dev, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Sep 2022 14:43:40 -0700 you wrote:
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
> 
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
> 
> The return type of korina_send_packet should be changed from int to
> netdev_tx_t.
> 
> [...]

Here is the summary with links:
  - net: korina: Fix return type of korina_send_packet
    https://git.kernel.org/netdev/net-next/c/106c67ce46f3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


