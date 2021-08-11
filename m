Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930143E9ABA
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhHKWKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232319AbhHKWK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 18:10:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8496560E52;
        Wed, 11 Aug 2021 22:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628719805;
        bh=TLINOSCN5eOvgkRepd8WX8dUB95//YPGoGehHo10eso=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P3Jw7ZBwEBmd7Qo7KV11wdkgsz0lOzGS0wVQh9PcbR90Auxqq2GyN8H31cjJGgZvz
         2VCE0JdCSKfcZ5zgyRSOdyMMFKUf+6ibKoVqGWSZ4QCPojFt0KkYjisPY+e7hN1SqG
         Y+030et0ex7nWF564/w2liMqidjvZzwHroTtTAR1JeCTrTpzemWapXuwFMK2X6bsY+
         OZr8cQ9IFVeDpr2qirNNsuZgKqdVurclNdLqT4LKmTGgUZMpt0s+gKIgrsGHUyDvi4
         Q++GQ3FTpjxEl0fV//Sy847721BlMxgJ6InSMOOSV4IBzav/j6CPfus2cQt/ROc2Rd
         aBKd7fKLF2dAw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7442060A69;
        Wed, 11 Aug 2021 22:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp_bbr: fix u32 wrap bug in round logic if bbr_init()
 called after 2B packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162871980547.25380.14625453522084904073.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Aug 2021 22:10:05 +0000
References: <20210811024056.235161-1-ncardwell@google.com>
In-Reply-To: <20210811024056.235161-1-ncardwell@google.com>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ycheng@google.com,
        yyd@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 10 Aug 2021 22:40:56 -0400 you wrote:
> Currently if BBR congestion control is initialized after more than 2B
> packets have been delivered, depending on the phase of the
> tp->delivered counter the tracking of BBR round trips can get stuck.
> 
> The bug arises because if tp->delivered is between 2^31 and 2^32 at
> the time the BBR congestion control module is initialized, then the
> initialization of bbr->next_rtt_delivered to 0 will cause the logic to
> believe that the end of the round trip is still billions of packets in
> the future. More specifically, the following check will fail
> repeatedly:
> 
> [...]

Here is the summary with links:
  - [net] tcp_bbr: fix u32 wrap bug in round logic if bbr_init() called after 2B packets
    https://git.kernel.org/netdev/net/c/6de035fec045

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


