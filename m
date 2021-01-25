Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300E1302E92
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733089AbhAYWBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 17:01:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733037AbhAYWAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 17:00:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8813622511;
        Mon, 25 Jan 2021 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611612010;
        bh=XJv2zC+g8rYayaw4Zi02Z4RuW5EiUcU5yRG5SfjJEbk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LzNZj/G+T8NrXEiCHu3eTzolvzhWeXPhf+4pggEjKC/QVcm+8moPXIc8PqepatL6H
         grXUqqgWwxXfnNUUCUZ0D+LXMJeJsa16VFSKB4MnaY4glUW9pyynyCrC+6X3jELuhx
         QsF04Lys1sD4LW92TcTE/tCWZvUSv4lG7Kb3Gg10LLGGLEV1sY4ETl1oEbDjAybNpD
         T3iGZY5iML8myiTcr9PVupSvpHk6e1N3bMaeY3+kTG+WGq2VLXI2UYPlH0Ma71d88G
         rxYAmCOlFS75bNLgvHopdfl3QWdRmTKNU49cG+725zxRMhYT4TiXiQ7MRZZkOFmE3H
         OA12BLCzvNgJA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 72C8561E41;
        Mon, 25 Jan 2021 22:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] tcp: fix TLP timer not set when CA_STATE changes from
 DISORDER to OPEN
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161161201046.13127.13513638342264536567.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jan 2021 22:00:10 +0000
References: <1611464834-23030-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1611464834-23030-1-git-send-email-yangpc@wangsu.com>
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     edumazet@google.com, ncardwell@google.com, ycheng@google.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 24 Jan 2021 13:07:14 +0800 you wrote:
> Upon receiving a cumulative ACK that changes the congestion state from
> Disorder to Open, the TLP timer is not set. If the sender is app-limited,
> it can only wait for the RTO timer to expire and retransmit.
> 
> The reason for this is that the TLP timer is set before the congestion
> state changes in tcp_ack(), so we delay the time point of calling
> tcp_set_xmit_timer() until after tcp_fastretrans_alert() returns and
> remove the FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer
> is set.
> 
> [...]

Here is the summary with links:
  - [v2,net] tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN
    https://git.kernel.org/netdev/net/c/62d9f1a6945b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


