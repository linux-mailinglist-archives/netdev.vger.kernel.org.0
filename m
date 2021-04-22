Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA96368899
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 23:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239657AbhDVVaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 17:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236763AbhDVVap (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 17:30:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0A95560FDC;
        Thu, 22 Apr 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619127010;
        bh=YSJLX1h7487v3apmi9GeRWhr4B1D+RbexRwkvYvlVEk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CqeYayhOa0CRf9EdqIRpFFOwayS7OeoZouqY21AXBMK6UeFVUroIUwaHJmMO/XkS4
         wIVx/AIyYH/jo8kNcIGsFlpGLouf1TU3IsEhRICp8rYKompV3jev0mbjyNXxxERZPh
         sgxmx7WbtLFGG9w1vDxN9XKa1R6AW5Sl6EBFlXaBJCFBz9VNm4BhDK6lsnAjIHRxLv
         F9/WS/UzfZSbqsNc+oCLCPxImoPhiBJPgfG/mliZk6mPronodpTj7UmORaPebVawqu
         O7Dlfe9Zl/q6zpmzT76rbSG8EG0azWqINYppF3kYF1K4+JgcEwzJpbt843UhBm2a39
         dnMPyDqD1bjbw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 04EEC60A53;
        Thu, 22 Apr 2021 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: xdp: Update pkt_type if generic XDP changes
 unicast MAC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161912701001.19496.14636181962804630969.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Apr 2021 21:30:10 +0000
References: <20210419141559.8611-1-martin@strongswan.org>
In-Reply-To: <20210419141559.8611-1-martin@strongswan.org>
To:     Martin Willi <martin@strongswan.org>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 19 Apr 2021 16:15:59 +0200 you wrote:
> If a generic XDP program changes the destination MAC address from/to
> multicast/broadcast, the skb->pkt_type is updated to properly handle
> the packet when passed up the stack. When changing the MAC from/to
> the NICs MAC, PACKET_HOST/OTHERHOST is not updated, though, making
> the behavior different from that of native XDP.
> 
> Remember the PACKET_HOST/OTHERHOST state before calling the program
> in generic XDP, and update pkt_type accordingly if the destination
> MAC address has changed. As eth_type_trans() assumes a default
> pkt_type of PACKET_HOST, restore that before calling it.
> 
> [...]

Here is the summary with links:
  - [net-next] net: xdp: Update pkt_type if generic XDP changes unicast MAC
    https://git.kernel.org/bpf/bpf-next/c/22b6034323fd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


