Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C197B429976
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 00:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbhJKWcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 18:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235504AbhJKWcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 18:32:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 960F860F43;
        Mon, 11 Oct 2021 22:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633991409;
        bh=IHPG+pxUpbVhRDMQ6p5W9rWhc7jThqt9nTguBEUuiCw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hhCwzSGwquQy1AQXdu2eB1fmprSdqX7u+SaNhIyAdUQZw2m4Dpd84S+yq2w3hEkaX
         MoPBuX6yqIfKDw0Jmy7go56vNPM7vVSEtdCRoJiRivwq5FQMWy+Piyy2i5Dqenh7yf
         a8EXKuZYaeNouXsZlLVfeQs5Mocwlemco/sS55+yA38ISOontYQKqHu9raSyyMm/qb
         GmkcmACBzVUHToFkvaOOjsYTK3RB9hk6emwh3vGdwJLML6GlKf/xKsCD5gBz+BhBWE
         pyuonDT8Pbatx+T2BagyDe5Ax9Ehlecx4d1/54aWNf3yRLn4o5psyv3Z31wBpqnU1q
         4KE5wtWaGThRg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8543A609CC;
        Mon, 11 Oct 2021 22:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/7] gve: minor code and performance improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163399140954.20385.1512954710604382105.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Oct 2021 22:30:09 +0000
References: <20211011153650.1982904-1-jeroendb@google.com>
In-Reply-To: <20211011153650.1982904-1-jeroendb@google.com>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 11 Oct 2021 08:36:43 -0700 you wrote:
> This patchset contains a number of independent minor code and performance
> improvements.
> 
> Catherine Sullivan (3):
>   gve: Add rx buffer pagecnt bias
>   gve: Add netif_set_xps_queue call
>   gve: Track RX buffer allocation failures
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/7] gve: Switch to use napi_complete_done
    https://git.kernel.org/netdev/net-next/c/2cb67ab153d5
  - [net-next,v2,2/7] gve: Add rx buffer pagecnt bias
    https://git.kernel.org/netdev/net-next/c/58401b2a46e7
  - [net-next,v2,3/7] gve: Do lazy cleanup in TX path
    https://git.kernel.org/netdev/net-next/c/61d72c7e486b
  - [net-next,v2,4/7] gve: Recover from queue stall due to missed IRQ
    https://git.kernel.org/netdev/net-next/c/87a7f321bb6a
  - [net-next,v2,5/7] gve: Add netif_set_xps_queue call
    https://git.kernel.org/netdev/net-next/c/4edf8249bcd1
  - [net-next,v2,6/7] gve: Allow pageflips on larger pages
    https://git.kernel.org/netdev/net-next/c/ea5d3455adf1
  - [net-next,v2,7/7] gve: Track RX buffer allocation failures
    https://git.kernel.org/netdev/net-next/c/1b4d1c9bab09

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


