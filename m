Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F0851ED18
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 12:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiEHKyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 06:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbiEHKyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 06:54:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F89EDECA
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 03:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAF8061117
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 10:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19DD1C385B0;
        Sun,  8 May 2022 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652007015;
        bh=esNzqPr5fkp5Q1E+J0ezNv2UFQ4af0FtBoEuFtj9fzQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FMkAy2aUabuy3kDy/pC5Vqhot5EboWKx03fHVw54KfHHMfTznFHyBxaL2uNktec+5
         Olk99JGrxah1ZOGqnqV2ucu91zdbH/wQx6ChgNh8shBPyFP9INzBczalTtyFQ9ivAB
         JgnJlFvccU08VfKaG/UA+dwYe0wfQX2lZ4/Do1zuG7ZLKlWHPnu5n/RO/8422rmzMR
         0bhqMZz9dTYQwNKTm81GnCe0mxZLJpFZxRoZIubU5fOa+hPryFK1132QqjBuSyKsjM
         qgG+xL7hJ/avl6pQj9ENz3gkuOGFOp5mWVmhpJ8WPTHQ0ykZFRJFDEXn/LgkCvnan2
         aYgRKnsato/Iw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE490F03927;
        Sun,  8 May 2022 10:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: switch drivers to netif_napi_add_weight()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165200701497.399.16357279983705677828.git-patchwork-notify@kernel.org>
Date:   Sun, 08 May 2022 10:50:14 +0000
References: <20220506170751.822862-1-kuba@kernel.org>
In-Reply-To: <20220506170751.822862-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  6 May 2022 10:07:45 -0700 you wrote:
> The minority of drivers pass a custom weight to netif_napi_add().
> Switch those away to the new netif_napi_add_weight(). All drivers
> (which can go thru net-next) calling netif_napi_add() will now
> be calling it with NAPI_POLL_WEIGHT or 64.
> 
> Jakub Kicinski (6):
>   um: vector: switch to netif_napi_add_weight()
>   caif_virtio: switch to netif_napi_add_weight()
>   eth: switch to netif_napi_add_weight()
>   r8152: switch to netif_napi_add_weight()
>   net: virtio: switch to netif_napi_add_weight()
>   net: wan: switch to netif_napi_add_weight()
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] um: vector: switch to netif_napi_add_weight()
    https://git.kernel.org/netdev/net-next/c/4d92c6275575
  - [net-next,2/6] caif_virtio: switch to netif_napi_add_weight()
    https://git.kernel.org/netdev/net-next/c/be8af67fabcb
  - [net-next,3/6] eth: switch to netif_napi_add_weight()
    https://git.kernel.org/netdev/net-next/c/b707b89f7be3
  - [net-next,4/6] r8152: switch to netif_napi_add_weight()
    https://git.kernel.org/netdev/net-next/c/8ded532cd1cb
  - [net-next,5/6] net: virtio: switch to netif_napi_add_weight()
    https://git.kernel.org/netdev/net-next/c/d484735dcf92
  - [net-next,6/6] net: wan: switch to netif_napi_add_weight()
    https://git.kernel.org/netdev/net-next/c/6f83cb8cbfbf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


