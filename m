Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6088168A80D
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 05:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbjBDEA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 23:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbjBDEAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 23:00:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14BF8F270
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 20:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C5186205F
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 04:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E02FBC433EF;
        Sat,  4 Feb 2023 04:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675483222;
        bh=k2m9MKJZVGHaAulaejOAzql9+MBWuVuIiFl2aCT11Kw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lmKDprU956jGjK2fTS/IK9Vwq0qXHOhTLEQ6Ne2JnS+OflrVNdzMnKKK6fOIZtsoM
         T4eVZ6vyOjKCcWw64D7lJrOL7hU9LP+gQwhi7gZ+XF9TUw6bBbgwA1amFbzayXH/01
         UoZ7sDnEMu4Xrt2OxdmMWYpIeanQ/hoNAceA+KftBxJTzfh/Ju+qQ0Od4yalzsCxEs
         D7ejaMtPHZKKSzMBEFeMvhcyQWUqxO8O6CEnvWdbOO3FpVZbAf9oa0yRb57jOqFjW1
         cqb8esZEIxV2qg1KRj8nkVVain5KM/vQ1emBQaliQGAkme2ndUu/AlILeBuSEXjmJU
         qjLHLNK3CVy3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA0E1E270CB;
        Sat,  4 Feb 2023 04:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] raw: add drop reasons and use another hash
 function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167548322282.10981.5647794050282076735.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Feb 2023 04:00:22 +0000
References: <20230202094100.3083177-1-edumazet@google.com>
In-Reply-To: <20230202094100.3083177-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  2 Feb 2023 09:40:57 +0000 you wrote:
> Two first patches add drop reasons to raw input processing.
> 
> Last patch spreads RAW sockets in the shared hash tables
> to avoid long hash buckets in some cases.
> 
> Eric Dumazet (3):
>   ipv6: raw: add drop reasons
>   ipv4: raw: add drop reasons
>   raw: use net_hash_mix() in hash function
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] ipv6: raw: add drop reasons
    https://git.kernel.org/netdev/net-next/c/8d8ebd77f5ed
  - [net-next,2/3] ipv4: raw: add drop reasons
    https://git.kernel.org/netdev/net-next/c/42186e6c0035
  - [net-next,3/3] raw: use net_hash_mix() in hash function
    https://git.kernel.org/netdev/net-next/c/6579f5bacc2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


