Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DD6610E45
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJ1KUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiJ1KUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941ED50FBA
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 312236275C
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 10:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95439C433C1;
        Fri, 28 Oct 2022 10:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666952417;
        bh=GWrM15YBBpbJaCo4Xe9SmePCw5gtfwuH8qtI8/V3mb4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pwJi6gs8meh3Fm7xAmNPZZJuQvJJEf5mwACCoPhY5YaO7VoCf15zl9NQ8cfI7zKiJ
         +B+WXEpY6AdyL7ySIhJOHUHzJNFfurtDQrTVouKwtsv3pKJDw2echQ+EC0nfNVbnTl
         xccwealY1qK4cXhfukjqfRhcjoI2eajinuXlA3x8Ox6f0w1lXNDyLR85x/0rGVx90n
         c++g3Xl/TW+VVRRCy56bN1g/e2FgbLplQfrOJ+Enmh7xIZCgkc+q/LywHceU/+H57Q
         +Wl/ppR8jVHHqD2GpYhPPv2MZ5RPp894PJF3ABHtQ2Xt677deQq6H6kJBjGpTuNreu
         KO5OCejyDkrKw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C721C41677;
        Fri, 28 Oct 2022 10:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] Add PLB functionality to TCP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166695241750.31704.12576031901939432506.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Oct 2022 10:20:17 +0000
References: <20221026135115.3539398-1-mubashirmaq@gmail.com>
In-Reply-To: <20221026135115.3539398-1-mubashirmaq@gmail.com>
To:     Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mubashirq@google.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Oct 2022 13:51:10 +0000 you wrote:
> From: Mubashir Adnan Qureshi <mubashirq@google.com>
> 
> This patch series adds PLB (Protective Load Balancing) to TCP and hooks
> it up to DCTCP. PLB is disabled by default and can be enabled using
> relevant sysctls and support from underlying CC.
> 
> PLB (Protective Load Balancing) is a host based mechanism for load
> balancing across switch links. It leverages congestion signals(e.g. ECN)
> from transport layer to randomly change the path of the connection
> experiencing congestion. PLB changes the path of the connection by
> changing the outgoing IPv6 flow label for IPv6 connections (implemented
> in Linux by calling sk_rethink_txhash()). Because of this implementation
> mechanism, PLB can currently only work for IPv6 traffic. For more
> information, see the SIGCOMM 2022 paper:
>   https://doi.org/10.1145/3544216.3544226
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] tcp: add sysctls for TCP PLB parameters
    https://git.kernel.org/netdev/net-next/c/bd456f283b66
  - [net-next,2/5] tcp: add PLB functionality for TCP
    https://git.kernel.org/netdev/net-next/c/1a91bb7c3ebf
  - [net-next,3/5] tcp: add support for PLB in DCTCP
    https://git.kernel.org/netdev/net-next/c/c30f8e0b0480
  - [net-next,4/5] tcp: add u32 counter in tcp_sock and an SNMP counter for PLB
    https://git.kernel.org/netdev/net-next/c/29c1c44646ae
  - [net-next,5/5] tcp: add rcv_wnd and plb_rehash to TCP_INFO
    https://git.kernel.org/netdev/net-next/c/71fc704768f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


