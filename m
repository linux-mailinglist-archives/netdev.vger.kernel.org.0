Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971143721B4
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 22:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhECUlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 16:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229773AbhECUlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 16:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4723361208;
        Mon,  3 May 2021 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620074410;
        bh=2U5ByCSN/QJbDn6BbSQe/eCwcabxI7EWCIWmEPCWY80=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FeUoPIKZKIMBrZZ5xZv45tUFJOpnmCOVdJKRzTy30eJylwMO1v5lGgfScCs0frU53
         x91jHYBEshrFRboNksLFKueiwvItoahdQ9QAvp6B/reHd31KlDs4VbIsZXeb254ECX
         uUwvJJpNGI8cMg+7xBBhRgj1SQHpBCPrM1vhYuZ/sRKlS6pPdoZrKcTQGB+STFK5aq
         N2Sl6vRPAuU69XT9NrNeMkVNnipGbGHZmRbKyuDtawh8GblX7rt/7xkHOacpvqcJJu
         pe7WeAKoe2CSL07MgwykhS+52GZw5WB4XW/d6njjPz/G/+jDmj34IedlezMKzbzQwN
         nP3N4R7ugYaNw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3914560A22;
        Mon,  3 May 2021 20:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] sctp: fix the incorrect revert
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162007441022.32677.15333763026236456281.git-patchwork-notify@kernel.org>
Date:   Mon, 03 May 2021 20:40:10 +0000
References: <cover.1619987699.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1619987699.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com,
        jere.leppanen@nokia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon,  3 May 2021 04:36:57 +0800 you wrote:
> commit 35b4f24415c8 ("sctp: do asoc update earlier in
> sctp_sf_do_dupcook_a") only keeps the SHUTDOWN and
> COOKIE-ACK with the same asoc, not transport.
> 
> So instead of revert commit 145cb2f7177d ("sctp: Fix bundling
> of SHUTDOWN with COOKIE-ACK"), we should revert 12dfd78e3a74
> ("sctp: Fix SHUTDOWN CTSN Ack in the peer restart case").
> 
> [...]

Here is the summary with links:
  - [net,1/2] Revert "Revert "sctp: Fix bundling of SHUTDOWN with COOKIE-ACK""
    https://git.kernel.org/netdev/net/c/22008f560bd3
  - [net,2/2] Revert "sctp: Fix SHUTDOWN CTSN Ack in the peer restart case"
    https://git.kernel.org/netdev/net/c/7aa4e54739be

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


