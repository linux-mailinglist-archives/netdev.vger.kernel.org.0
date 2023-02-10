Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337756919CD
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjBJILp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjBJILo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:11:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3720B80750;
        Fri, 10 Feb 2023 00:11:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CB05B823FD;
        Fri, 10 Feb 2023 08:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 323A8C4339C;
        Fri, 10 Feb 2023 08:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676016618;
        bh=TkK1d0F2Jd7iBMn6kS+nEHwJOYnzkMhrZkysSC79Rx4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jefNzz7QYMfnRDFRbeWPrPrmpV0eqU6WL0Y6AMTZYlWonyu+kyeR5m8JLvdwfIzQj
         S+l+vPnrcu0HKOaPVqQvC7+GSlvAmtAqsTYaxvbHTuOs85344L6OCygZ7TsXTGvZUj
         NJR0AF8aJVU1CMCvkmi+5nDyVSYjGEhCxsx70VzLQKjNb4Bx+Tn1iagQt9xiLhymgb
         zpHwtmuqXzPY3ARrpnu64P+r1OSbKxETfn8b57xHbHEofjW7YDlJ7IjuDxV2FXtx56
         vdHNmFugS+Uj/bqbsN+I7RXAOFxe08ydFegV8gzTR1JurYwlC3jmx1oW5HqE2/kpMA
         HNaPAAEnk5iKw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1CF1DC41677;
        Fri, 10 Feb 2023 08:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] rxrpc: Miscellaneous changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167601661811.12999.10073267572686998349.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Feb 2023 08:10:18 +0000
References: <20230208102750.18107-1-dhowells@redhat.com>
In-Reply-To: <20230208102750.18107-1-dhowells@redhat.com>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, marc.dionne@auristor.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David Howells <dhowells@redhat.com>:

On Wed,  8 Feb 2023 10:27:46 +0000 you wrote:
> Here are some miscellaneous changes for rxrpc:
> 
>  (1) Use consume_skb() rather than kfree_skb_reason().
> 
>  (2) Fix unnecessary waking when poking and already-poked call.
> 
>  (3) Add ack.rwind to the rxrpc_tx_ack tracepoint as this indicates how
>      many incoming DATA packets we're telling the peer that we are
>      currently willing to accept on this call.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] rxrpc: Use consume_skb() rather than kfree_skb_reason()
    https://git.kernel.org/netdev/net-next/c/16d5677ef104
  - [net-next,2/4] rxrpc: Fix overwaking on call poking
    https://git.kernel.org/netdev/net-next/c/a33395ab85b9
  - [net-next,3/4] rxrpc: Trace ack.rwind
    https://git.kernel.org/netdev/net-next/c/f789bff2deb3
  - [net-next,4/4] rxrpc: Reduce unnecessary ack transmission
    https://git.kernel.org/netdev/net-next/c/5a2c5a5b0829

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


