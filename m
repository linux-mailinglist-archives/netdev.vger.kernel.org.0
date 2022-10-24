Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A96609F0F
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJXKaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiJXKaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57049317FE
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FF6A611DF
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC50DC43470;
        Mon, 24 Oct 2022 10:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666607419;
        bh=SNrncDmF8U381ePCAfD0WXagC22+sXnckb8M7dQFKb4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZnLKfb7rzOhw1g0NiWiuhXwaE9YJdRII/69vrpgup1jVeMHxOZsX9YyEGDmVs31Lc
         KxuYy0WqlSmRyrB5ojVYGWWRb6Xvg553s4r0UYqoFOtNfMoJOK8owQ2++j4IUj+N9O
         QVA0YuPDTWdSSRVvRXj3aww8pTbx0154jlyaEkoxeUiyIx4ZvHSo5POedSabeUmhiW
         6WXas+dKQphleXxzGNy5h5QMzq4ZiNKuhLxVBM9AbANHE2uwS3o7y/NZ9j2BG/myRn
         9ziK/pv5MrAojauuIdm9l4Jm4fZUD2qm+4TK8RlJVG7BD1eQhd1LcmJ+pfhW5tm6I7
         qveKApn3ZZbVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BE014E50D7D;
        Mon, 24 Oct 2022 10:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: add a refcount tracker for kernel sockets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166660741976.18313.18079373443384222635.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 10:30:19 +0000
References: <20221020232018.3333414-1-edumazet@google.com>
In-Reply-To: <20221020232018.3333414-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 20 Oct 2022 23:20:18 +0000 you wrote:
> Commit ffa84b5ffb37 ("net: add netns refcount tracker to struct sock")
> added a tracker to sockets, but did not track kernel sockets.
> 
> We still have syzbot reports hinting about netns being destroyed
> while some kernel TCP sockets had not been dismantled.
> 
> This patch tracks kernel sockets, and adds a ref_tracker_dir_print()
> call to net_free() right before the netns is freed.
> 
> [...]

Here is the summary with links:
  - [net-next] net: add a refcount tracker for kernel sockets
    https://git.kernel.org/netdev/net-next/c/0cafd77dcd03

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


