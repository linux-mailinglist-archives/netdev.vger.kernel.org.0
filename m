Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824FC69C610
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 08:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjBTHkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 02:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjBTHkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 02:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565F1FF3C;
        Sun, 19 Feb 2023 23:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2AF8B80B0D;
        Mon, 20 Feb 2023 07:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FB7DC4339B;
        Mon, 20 Feb 2023 07:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676878816;
        bh=wmJlsM5LElEfmavsk+aw+RTOhzgJ38h6dAnUIWkRxd0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gqux8zoEE+VQW03pqzb2Hi6/bQHs3KdxJeuJgU+e1bAxq/J+SR3Q7uwbOBiMD0s2d
         +UFiOsBgFDyOuhDMiPDBWg9vwvhe2I020tzIxsQ4sz6JEbfJCG3CJZhXGP7pK7CrvI
         Ai1xoiHfvXWG2wn5/lX3eXtVw8ZTjwt9J2FGPKHuSSkOUrAbK4R3qZH3xoMfEES/mw
         IM2JR7vesaJgspP4D7xNy8YahpQpN+Jo+J0YXTIiX0HJjKUzQikPGSpN+GZTahie9x
         EwODo1uW/7BNykp0HrDIc9BylLmQJOYKCk/aZNYZ6gX8IOfxFYuEsR3XmWOrL3rhgt
         UW3c5OTZ4sBEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54E79E68D22;
        Mon, 20 Feb 2023 07:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] rxrpc: Fix overproduction of wakeups to recvmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167687881634.32608.15336157883247803964.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 07:40:16 +0000
References: <3386149.1676497685@warthog.procyon.org.uk>
In-Reply-To: <3386149.1676497685@warthog.procyon.org.uk>
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 15 Feb 2023 21:48:05 +0000 you wrote:
> Fix three cases of overproduction of wakeups:
> 
>  (1) rxrpc_input_split_jumbo() conditionally notifies the app that there's
>      data for recvmsg() to collect if it queues some data - and then its
>      only caller, rxrpc_input_data(), goes and wakes up recvmsg() anyway.
> 
>      Fix the rxrpc_input_data() to only do the wakeup in failure cases.
> 
> [...]

Here is the summary with links:
  - [net-next] rxrpc: Fix overproduction of wakeups to recvmsg()
    https://git.kernel.org/netdev/net-next/c/c07838185623

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


