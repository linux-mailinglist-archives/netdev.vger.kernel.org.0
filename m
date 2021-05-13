Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29BE380098
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 01:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhEMXBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 19:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230446AbhEMXBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 19:01:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EF288613F2;
        Thu, 13 May 2021 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620946810;
        bh=8bVvgJkPROsLz0NLkmA22UBIYnSaYHJ2vlD7BVDJ6BU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pbuQ8Ij2po/kb5pbKVJnHeDvTKAY8wAxHfaZNUPlykwUtZcIJdcRPsP3v4xuhcc1g
         NcvfwxpQAR5JQvrrZSbKWMe1npdYiqHSj9dCwV9ho4/F6wMC5JrmXuDZ+vpX57bmZS
         UHeFdMZda/olL454QaUTT93xYhNA95rMamNcqTKUJw7zBqU2H68z6KD2VYDVHxa7L5
         z6538WtOHKFUHLWT7eCsOky8ZHu0PMl4hs2YpeolDwlwZnq96BqgnR26iufye2WntG
         sP+CASK/2Uy4waho35F6s4a0hGe5vrxTu/TvWYwMEbvUTfwycpP1Dn0h3/DmHiNalh
         fBZl+ARtgE9rQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E3DB2609D8;
        Thu, 13 May 2021 23:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cxgb4/ch_ktls: Clear resources when pf4 device is removed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162094680992.5074.4538268271653879718.git-patchwork-notify@kernel.org>
Date:   Thu, 13 May 2021 23:00:09 +0000
References: <20210513094151.32520-1-ayush.sawal@chelsio.com>
In-Reply-To: <20210513094151.32520-1-ayush.sawal@chelsio.com>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        secdev@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 13 May 2021 15:11:51 +0530 you wrote:
> This patch maintain the list of active tids and clear all the active
> connection resources when DETACH notification comes.
> 
> Fixes: a8c16e8ed624f ("crypto/chcr: move nic TLS functionality to drivers/net")
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
> ---
>  .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 +-
>  .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 80 ++++++++++++++++++-
>  .../chelsio/inline_crypto/ch_ktls/chcr_ktls.h |  2 +
>  3 files changed, 82 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net] cxgb4/ch_ktls: Clear resources when pf4 device is removed
    https://git.kernel.org/netdev/net/c/65e302a9bd57

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


