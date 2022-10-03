Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D095F3A0C
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 01:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiJCXuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 19:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJCXuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 19:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4961E71E;
        Mon,  3 Oct 2022 16:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 630E7B81687;
        Mon,  3 Oct 2022 23:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2374FC43142;
        Mon,  3 Oct 2022 23:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664841017;
        bh=MTw4vjaRF87XRbcIQUjvIN+CRxir5R/Df8BaHy/pdBc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YgfJ+o/32ncRm6UtRJG7Uc+3HifenOVeVzNqtFAAnlIrS4A468n2n+qrItSmi6byD
         k7PK04wqGn9S0xXCAUh/pPklpl2FfrmFmSNmgmyZAGd+N0sMD69jw3a35GuFYRsCbT
         We4sB8ZUjGUPezkdyA5EbWUeSe0sDjGpUU90JF/cSoplGXC7X9wgILQy7a6XwaM26X
         fUPdHSGEIajPmHVqHvcuXNufqlsnRHySD1R294/dW6+9uzznPqGqkMg7ivlHIgbc7j
         StZVVnSU952/kMnVB9axKsgNUuqlW5TOcLnmkBkVyuR94mv8fx00sTVjdxX/rjtsqI
         U3O/WK7WQHL0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0E140E4D013;
        Mon,  3 Oct 2022 23:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: lan966x: Fix return type of lan966x_port_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166484101705.29578.5196781681020235718.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 23:50:17 +0000
References: <20220929182704.64438-1-nhuck@google.com>
In-Reply-To: <20220929182704.64438-1-nhuck@google.com>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     error27@gmail.com, llvm@lists.linux.dev,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Thu, 29 Sep 2022 11:27:03 -0700 you wrote:
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
> 
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
> 
> The return type of lan966x_port_xmit should be changed from int to
> netdev_tx_t.
> 
> [...]

Here is the summary with links:
  - net: lan966x: Fix return type of lan966x_port_xmit
    https://git.kernel.org/netdev/net-next/c/450a580fc4b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


