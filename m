Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FA368EAB2
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 10:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjBHJM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 04:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjBHJMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 04:12:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3166846091
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 01:11:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82BB16158C
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 09:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4BA9C4339C;
        Wed,  8 Feb 2023 09:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675847417;
        bh=g+tm+RM3M+07fioGMZoKC5WBi7ImSXmkP7DSJelb3rg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NePULdQsQdlS8mtqaDWz66zshradwLaAWKTyCGds8AVgu29E9UdTnDh3cvRQZm7Xd
         OMs21wdGL1UPBkPwRCll3ngQNbI7iCXj8pFRwepAFKuRp27SGadEt6gEuuuThIGCCx
         MCsgGR6m9T6SE1o7i3RgYbZ/7ohfktfYm2HAYHFRmH3GauY/rLW7MYXumPid0qMLl6
         jRvsa1TDDKZEbinCWBGaDnFtp6qbWPHCDHR5EEacpXnijq3dd5IroJeViMil+Y/P81
         7P/FZr5Y69kdyTCIL7ZpsQCMXAG/oiVEG0EBT63ohqNW7lR/ikReetHubKI4vpRqQn
         C6YsIdUl2V0nw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D0C68E524E8;
        Wed,  8 Feb 2023 09:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] txhash: fix sk->sk_txrehash default
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167584741785.9727.6175593678410014417.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 09:10:17 +0000
References: <20230207020820.2704647-1-yyd@google.com>
In-Reply-To: <20230207020820.2704647-1-yyd@google.com>
To:     Kevin Yang <yyd@google.com>
Cc:     davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  7 Feb 2023 02:08:20 +0000 you wrote:
> This code fix a bug that sk->sk_txrehash gets its default enable
> value from sysctl_txrehash only when the socket is a TCP listener.
> 
> We should have sysctl_txrehash to set the default sk->sk_txrehash,
> no matter TCP, nor listerner/connector.
> 
> Tested by following packetdrill:
>   0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>   +0 socket(..., SOCK_DGRAM, IPPROTO_UDP) = 4
>   // SO_TXREHASH == 74, default to sysctl_txrehash == 1
>   +0 getsockopt(3, SOL_SOCKET, 74, [1], [4]) = 0
>   +0 getsockopt(4, SOL_SOCKET, 74, [1], [4]) = 0
> 
> [...]

Here is the summary with links:
  - [net] txhash: fix sk->sk_txrehash default
    https://git.kernel.org/netdev/net/c/c11204c78d69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


