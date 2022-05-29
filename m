Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B065370BC
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 13:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiE2LUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 07:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiE2LUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 07:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8EF99695
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 04:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 860DD60EEE
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 11:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9E06C3411A;
        Sun, 29 May 2022 11:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653823212;
        bh=dvfIC9OnbvCjhgERbPtgWo7DB7RKnM5DGn+EM8N6MKE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OqSuMhaiMPGCz0r5C1HkofbaRqbEwxlZp/dX5bp3C4LPAQ+K4Y2aDGVpktSE54Vzu
         WPmsc882W5U26VSUlxPW/gseHRxfzRIiN/A/ETaCW0a/9ApM2zBF9Lbms9seKQkPmH
         sIJThOmM4gljkXlb3nkqlLck8rrS0QYu4Mi+OITCNFCSoRV/rsoy4Ff+cziN6mfzvD
         JrFWUJGTndDtq0YtHFyDtc8Y33ZwLz2jwVLmJrMv0wW80/uClPQK7DsJAbzfunisjJ
         GX8cvmcmMsRP1JNyYvGmGLKjsPd0OuSdLDtKbYTf8gwW+KmWHP5kuwBoaIXKJ3L+d9
         YpbohUtcDrT6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9175F03942;
        Sun, 29 May 2022 11:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] sfc: fix some efx_separate_tx_channels errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165382321275.13055.6073002084792987579.git-patchwork-notify@kernel.org>
Date:   Sun, 29 May 2022 11:20:12 +0000
References: <20220527080529.24225-1-ihuguet@redhat.com>
In-Reply-To: <20220527080529.24225-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, cmclachlan@solarflare.com, brouer@redhat.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 27 May 2022 10:05:27 +0200 you wrote:
> Trying to load sfc driver with modparam efx_separate_tx_channels=1
> resulted in errors during initialization and not being able to use the
> NIC. This patches fix a few bugs and make it work again.
> 
> v2:
> * added Martin's patch instead of a previous mine. Mine one solved some
> of the initialization errors, but Martin's solves them also in all
> possible cases.
> * removed whitespaces cleanup, as requested by Jakub
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] sfc: fix considering that all channels have TX queues
    https://git.kernel.org/netdev/net/c/2e102b53f8a7
  - [net,v2,2/2] sfc: fix wrong tx channel offset with efx_separate_tx_channels
    https://git.kernel.org/netdev/net/c/c308dfd1b43e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


