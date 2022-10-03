Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11FB5F3061
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 14:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiJCMkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 08:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiJCMkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 08:40:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B8022B11
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 05:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 468F6CE0BA6
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 12:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87296C433D7;
        Mon,  3 Oct 2022 12:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664800814;
        bh=tJvsmyimVDmWaiVTWG/lLcCJKCcwqv9ESCOXAGjiHDk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ew8shJLqQDTJi5M2F8OR3x7lzfCFosDe4eXkWpKl+0CeFdgbSTG6hPl8FC2r5JIZH
         zBJiy/UI1P2xEB3k/CIoF/OKhS8c+ejIgTx5N9uVMpY6H1hGTX3Q3oLqTJ5dxYodtJ
         zWKctJ3tVhKoNRoEOcblQQ20jDPo9QpySNjEzOFm7LAvNCXI/6C/mlipBl/BOWKxL6
         T91UgF8swwbBw+aWgyu2qreZmmJ2W7b1Mr9QPxMiaeed26FtKVYKkSe8j5NzW1PJXI
         b0Rmmd3Nv9/9i2ZPynS+WP8Xv55k5NKcRZcafA53pPlj3PkyznuS8YgC/2dW2RewPe
         LQ3gor7AlZ6Tg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67FDEE4D013;
        Mon,  3 Oct 2022 12:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] once: add DO_ONCE_SLOW() for sleepable contexts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166480081442.18787.18225641567071597506.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 12:40:14 +0000
References: <20221001205102.2319658-1-eric.dumazet@gmail.com>
In-Reply-To: <20221001205102.2319658-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com,
        christophe.leroy@csgroup.eu, w@1wt.eu
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

On Sat,  1 Oct 2022 13:51:02 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Christophe Leroy reported a ~80ms latency spike
> happening at first TCP connect() time.
> 
> This is because __inet_hash_connect() uses get_random_once()
> to populate a perturbation table which became quite big
> after commit 4c2c8f03a5ab ("tcp: increase source port perturb table to 2^16")
> 
> [...]

Here is the summary with links:
  - [net-next] once: add DO_ONCE_SLOW() for sleepable contexts
    https://git.kernel.org/netdev/net-next/c/62c07983bef9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


