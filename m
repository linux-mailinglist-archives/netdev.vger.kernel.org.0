Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4734433C6F6
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 20:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhCOTkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 15:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232315AbhCOTkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 15:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2841C64DFD;
        Mon, 15 Mar 2021 19:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615837208;
        bh=R6h91gj5vHVWc+MLmad2vahHrwu1cI9nPg/3KlKm1Ak=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bgB4/GWfciXHLp6OVakDQlza2U7uGPeTnbrtwn4xtUpvwlVz3qFLLULd+obaT+nLr
         vjkhLQNrXzZmC9WVzA3XIcVbObp3zrTJ1mzps2HU7iwQj3uN0MDn1r7cyUQUNQ4bpf
         WUByKsTieYqGlu5TWo7AnFhG9q5fqz8DGM/deWDb3n/qB64uVNfvCozI6isDeGo0ez
         E6AGIBGWY5H1t3efvNE6X1YJR/jDYakSbM/JvhEi1GEWzpX3Ad1jc4I4qfQVWgmsyK
         GnMep7afF8Z5tmaz0SOdB1I7plO2SKUO2nGcXjdnEbQdd+XqK2QSKWJ3PNzLExeFL3
         ADbGprf5CRXvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 16ABA60A1A;
        Mon, 15 Mar 2021 19:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: hdlc_x25: Prevent racing between "x25_close" and
 "x25_xmit"/"x25_rx"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161583720808.23197.12484881848858187227.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Mar 2021 19:40:08 +0000
References: <20210314112103.45242-1-xie.he.0141@gmail.com>
In-Reply-To: <20210314112103.45242-1-xie.he.0141@gmail.com>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     ms@dev.tdt.de, khc@pm.waw.pl, davem@davemloft.net, kuba@kernel.org,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 14 Mar 2021 04:21:01 -0700 you wrote:
> "x25_close" is called by "hdlc_close" in "hdlc.c", which is called by
> hardware drivers' "ndo_stop" function.
> "x25_xmit" is called by "hdlc_start_xmit" in "hdlc.c", which is hardware
> drivers' "ndo_start_xmit" function.
> "x25_rx" is called by "hdlc_rcv" in "hdlc.c", which receives HDLC frames
> from "net/core/dev.c".
> 
> [...]

Here is the summary with links:
  - [net,v2] net: hdlc_x25: Prevent racing between "x25_close" and "x25_xmit"/"x25_rx"
    https://git.kernel.org/netdev/net/c/bf0ffea336b4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


