Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52F961203F
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 06:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiJ2Eu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 00:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiJ2EuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 00:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1E85C372;
        Fri, 28 Oct 2022 21:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE58860AE3;
        Sat, 29 Oct 2022 04:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 497FBC433D6;
        Sat, 29 Oct 2022 04:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667019018;
        bh=1OUZ9GQqAYE2CM6NYJAVm09J1cU/wBieSiYN2PgzGMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V3h18iBrNSRB52oGTRki6FXlXq20sic+UNurIaS5su5dIAaYAFd6jUJynYSClcVd7
         5vGDdiK6IJhmBfy/CZmK7uOdu9STUQtMymevIy9ECZ7cHnZxdm8FZaEf/3zUFfT8v+
         YfLAXxg8EtYjPa8et42WnD/RROdGbxQCM74fbTq3BrLd5KTjObAG+yXWhS4VkKU7SL
         QZTQxCdDuPthwStT1i64Ok8KcRdTlOnf07SnOCoz+XK83RNMzKjJ/aM3rZB1Ayjj4m
         Z/9Norpq4/29hGOUWhESNMLW4R9FyObhgrAMUzuJ+FXLEbbixHUDo9SVxwLXXupdhN
         uXKVFPCe5a2oQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2DC0EC41672;
        Sat, 29 Oct 2022 04:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] a few corrections for SOCK_SUPPORT_ZC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166701901817.13014.7707035824604308004.git-patchwork-notify@kernel.org>
Date:   Sat, 29 Oct 2022 04:50:18 +0000
References: <cover.1666825799.git.asml.silence@gmail.com>
In-Reply-To: <cover.1666825799.git.asml.silence@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        io-uring@vger.kernel.org, john.fastabend@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Oct 2022 00:25:55 +0100 you wrote:
> There are several places/cases that got overlooked in regards to
> SOCK_SUPPORT_ZC. We're lacking the flag for IPv6 UDP sockets and
> accepted TCP sockets. We also should clear the flag when someone
> tries to hijack a socket by replacing the ->sk_prot callbacks.
> 
> Pavel Begunkov (3):
>   udp: advertise ipv6 udp support for msghdr::ubuf_info
>   net: remove SOCK_SUPPORT_ZC from sockmap
>   net/ulp: remove SOCK_SUPPORT_ZC from tls sockets
> 
> [...]

Here is the summary with links:
  - [net,1/4] udp: advertise ipv6 udp support for msghdr::ubuf_info
    https://git.kernel.org/netdev/net/c/8f279fb00bb2
  - [net,2/4] net: remove SOCK_SUPPORT_ZC from sockmap
    https://git.kernel.org/netdev/net/c/fee9ac06647e
  - [net,3/4] net/ulp: remove SOCK_SUPPORT_ZC from tls sockets
    https://git.kernel.org/netdev/net/c/e276d62dcfde
  - [net,4/4] net: also flag accepted sockets supporting msghdr originated zerocopy
    https://git.kernel.org/netdev/net/c/71b7786ea478

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


