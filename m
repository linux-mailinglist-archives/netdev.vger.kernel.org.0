Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F3F55C8A0
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244571AbiF1FAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237478AbiF1FAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132F025C4B
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 22:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74338B81C21
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 05:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E3E6C341CB;
        Tue, 28 Jun 2022 05:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656392415;
        bh=zQPGrZrHPEkjEN12cRbKmb3tqtl6D56cHrEv+v+OTkg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s94UAL/g0mW0QLsvC9iDvAhefx9/qEd8WqVobhOLdCTiTxLIMq8k2Yp903iRm5r57
         7nmL15OzDNqYb8a6AX8lXF7M/H1w9rF2/7wtk7zn/fsO4ha8gnNqoGFwuB/QEV9A/v
         8gR+8bubgZ5jgQoVwh2L179QLqlHTsvnyMxWbMtNlNdS94cFISPzPbmSGCnZrin8Nd
         rw0lRNhxGf7aeOIoy/PAaZhvbWBjkjOzUqyRGBez+eDd5GQ46e4ZalTUgEKr4PA+OJ
         H/U+CqB+1UWQU5e+Hv4F6xbos8n7sPEkuVE0o/TOMvkniw4aSNducYih1VIDqo6FYY
         h1XLepapUK68A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EF2FDE49FA2;
        Tue, 28 Jun 2022 05:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: tun: stop NAPI when detaching queues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165639241497.25506.358640089919578584.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 05:00:14 +0000
References: <20220623042105.2274812-1-kuba@kernel.org>
In-Reply-To: <20220623042105.2274812-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        pabeni@redhat.com, maheshb@google.com, peterpenkov96@gmail.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jun 2022 21:21:05 -0700 you wrote:
> While looking at a syzbot report I noticed the NAPI only gets
> disabled before it's deleted. I think that user can detach
> the queue before destroying the device and the NAPI will never
> be stopped.
> 
> Compile tested only.
> 
> [...]

Here is the summary with links:
  - [net] net: tun: stop NAPI when detaching queues
    https://git.kernel.org/netdev/net/c/a8fc8cb5692a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


