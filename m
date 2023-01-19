Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77112673FF8
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjASRaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjASRaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC6044A0
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 09:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5733A61D0A
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 17:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA8BFC433F1;
        Thu, 19 Jan 2023 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674149416;
        bh=JyTq2P/gSRmXkEuv6lgXPfG3G/ykO4SJgQNsQBRGp4E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cQ6zILtyhu8eMZqptQKZ0Yi7/JR2mElOd1vEslkM9FONrzTjYIvWvyroE3JYaf82z
         7Pda/ouBEyIx07W3j/0VtSxH3hRcpOl39UFuD7j+4lcjzBhjdYojMjq1WsEeKq72IN
         K2wrvbNS6ixsbNhCy6bjlID0RTSDyAu6EAi7Yy/QPe+bO4j4JAUZsRy5t+nIsOByFm
         xO0W1gE/IjE7uXewAVCy8Ip9bGA56tg1BDkK0eD/Un1MS8B1D19RBnZE1gITaPCHee
         ZLF3xbI5R6dYkD5OuzrkpJu77OWlPSiPY8Mn5jACJo6ziZ6YEk4UnS9fpUi64cNtLf
         /scDPDT1Xu9VQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 90B0EC5C7C4;
        Thu, 19 Jan 2023 17:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/ulp: use consistent error code when blocking ULP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167414941658.32440.277672529666701282.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Jan 2023 17:30:16 +0000
References: <7bb199e7a93317fb6f8bf8b9b2dc71c18f337cde.1674042685.git.pabeni@redhat.com>
In-Reply-To: <7bb199e7a93317fb6f8bf8b9b2dc71c18f337cde.1674042685.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        kuba@kernel.org, sd@queasysnail.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 Jan 2023 13:24:12 +0100 you wrote:
> The referenced commit changed the error code returned by the kernel
> when preventing a non-established socket from attaching the ktls
> ULP. Before to such a commit, the user-space got ENOTCONN instead
> of EINVAL.
> 
> The existing self-tests depend on such error code, and the change
> caused a failure:
> 
> [...]

Here is the summary with links:
  - [net] net/ulp: use consistent error code when blocking ULP
    https://git.kernel.org/netdev/net/c/8ccc99362b60

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


