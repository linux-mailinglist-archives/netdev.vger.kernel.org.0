Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775215305E0
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 22:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347857AbiEVUkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 16:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiEVUkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 16:40:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F3E39162;
        Sun, 22 May 2022 13:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32572B80DA0;
        Sun, 22 May 2022 20:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF47DC385B8;
        Sun, 22 May 2022 20:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653252012;
        bh=qwu6QFgpf3uhezmjUBR6YG3VYrsaOduEdD+7InCCvRs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GLmjltubq7+k1v35+aJhF04SP6as24f7IDfsjJuGWQswkNdlkl24AflfDXedrMn/k
         umlZ6AVxlVNuAZccFIJdFLReE5U7tbYTbjnAB+MfhBDN7R8D0FSHdy7QPIoNaj2n8i
         769QSTEYZw/lnfOGXnnUhvPydpRfLMczxs1/BAfHl85m8mFTtFzCopFfSBxPI49j+S
         twpwuycHcnCn+XE6NBzfF3b5/Px7//UZzERb/5Kx9k5w6UalpvRA+A0OhkwO5SA8TH
         OfrVuJlPM6Ky5NUunWVA/11Ez6Blpl7xJ52ATHhrkqy6GboTg4PsbULfoUXH4/0DSp
         R+yMrJhA+6sWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B29BAF03943;
        Sun, 22 May 2022 20:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5] rxrpc: Miscellaneous fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165325201272.15566.8643789679841919228.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 20:40:12 +0000
References: <165312017819.246773.14440495192028707532.stgit@warthog.procyon.org.uk>
In-Reply-To: <165312017819.246773.14440495192028707532.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        jaltman@auristor.com, marc.dionne@auristor.com,
        linux-kernel@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 21 May 2022 09:02:58 +0100 you wrote:
> Here are some fixes for AF_RXRPC:
> 
>  (1) Fix listen() allowing preallocation to overrun the prealloc buffer.
> 
>  (2) Prevent resending the request if we've seen the reply starting to
>      arrive.
> 
> [...]

Here is the summary with links:
  - [net,1/5] rxrpc: Fix listen() setting the bar too high for the prealloc rings
    https://git.kernel.org/netdev/net/c/88e22159750b
  - [net,2/5] rxrpc: Don't try to resend the request if we're receiving the reply
    https://git.kernel.org/netdev/net/c/114af61f88fb
  - [net,3/5] rxrpc: Fix overlapping ACK accounting
    https://git.kernel.org/netdev/net/c/8940ba3cfe48
  - [net,4/5] rxrpc: Don't let ack.previousPacket regress
    https://git.kernel.org/netdev/net/c/81524b631253
  - [net,5/5] rxrpc: Fix decision on when to generate an IDLE ACK
    https://git.kernel.org/netdev/net/c/9a3dedcf1809

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


