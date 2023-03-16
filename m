Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEAA46BC531
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjCPEUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCPEUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:20:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2801A954;
        Wed, 15 Mar 2023 21:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC80BB81FBB;
        Thu, 16 Mar 2023 04:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65926C4339B;
        Thu, 16 Mar 2023 04:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678940417;
        bh=2Ue7eCK1RHPG30/1sgFeein0aQgNO7hDTPq9R4C+FME=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y8u/ZxWWpb97QEyx+XiNGHJFAqHm8K4N0zC/amQ78P3C3X+Lcab9DaWTcexkMW8ZN
         w5ojBt9hDuxnsCnZyVwGM7xDNwkXQSyc7RkdaLEPRcBtQCmtguq/5Hn7BHEke5iYC7
         U0x3yWUBAUVU60RxTFEXQzhWXVQtxmGy+464xmiDIaQrU8whvjFLgc1DyJPf+bucBG
         ClpUX87X8cyq1m13gpkJWycNrjzDdq+mKQZtPDJ/jpDg15Zm6xZschzOrr5/INkRs9
         MO6mBrNevLo3nErsFV/IB9c72eLZEjAhDLJoFlsYr0QMpQzwB0IkC8yImLohhSMe9X
         hCEm+FS0moXSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5072BE66CBF;
        Thu, 16 Mar 2023 04:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] veth: Fix use after free in XDP_REDIRECT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167894041732.26311.6593717674885265121.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 04:20:17 +0000
References: <20230314153351.2201328-1-sbohrer@cloudflare.com>
In-Reply-To: <20230314153351.2201328-1-sbohrer@cloudflare.com>
To:     Shawn Bohrer <sbohrer@cloudflare.com>
Cc:     toshiaki.makita1@gmail.com, toke@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@cloudflare.com, lorenzo@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Mar 2023 10:33:51 -0500 you wrote:
> 718a18a0c8a67f97781e40bdef7cdd055c430996 "veth: Rework veth_xdp_rcv_skb
> in order to accept non-linear skb" introduced a bug where it tried to
> use pskb_expand_head() if the headroom was less than
> XDP_PACKET_HEADROOM.  This however uses kmalloc to expand the head,
> which will later allow consume_skb() to free the skb while is it still
> in use by AF_XDP.
> 
> [...]

Here is the summary with links:
  - veth: Fix use after free in XDP_REDIRECT
    https://git.kernel.org/netdev/net/c/7c10131803e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


