Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627BD3F59DB
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 10:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbhHXIa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 04:30:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235291AbhHXIat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 04:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AD4A761357;
        Tue, 24 Aug 2021 08:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629793805;
        bh=TbW3QSnNi2sp0jQXid4PLEQhDVLuhgdOwqmQtWh6cIw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HdeFvVYVf5HVJYaFI/00J+nQH+O6UnFaIIWvxPY5lH4Sxtth25V3X6Bly2XkH9LuH
         MFcF/ETM9+TRAynDER/xD0eSjF1xoddsyysnrcIOQBuExn9Uz7Rmnh/aLuVyPOfK6A
         IHFeeMdBqThLbuRzwlWniOw2CVBoQqvklWkGrnOHbmd+JWsXrXUF2p3FBg3R4/IAWR
         k7xS9ZHXxwlQ0l7lw9eRP7Ou9vHJTZ56BmlLzaxXQoFPeMbMv1GZw/rs1vOEshYUvQ
         CmtgrWR/QrTe3/2IFCHth1oHdDF/3oAQ25KqfhY3nrgn7pb/v1vPUgjFN31rnl5ADA
         tprZexviWMUbQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A61AF60978;
        Tue, 24 Aug 2021 08:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipv4: Move ip_options_fragment() out of loop
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162979380567.25178.619199845135518553.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Aug 2021 08:30:05 +0000
References: <20210823031759.25395-1-yajun.deng@linux.dev>
In-Reply-To: <20210823031759.25395-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 23 Aug 2021 11:17:59 +0800 you wrote:
> The ip_options_fragment() only called when iter->offset is equal to zero,
> so move it out of loop, and inline 'Copy the flags to each fragment.'
> As also, remove the unused parameter in ip_frag_ipcb().
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/ipv4/ip_output.c | 19 ++++---------------
>  1 file changed, 4 insertions(+), 15 deletions(-)

Here is the summary with links:
  - [net-next] net: ipv4: Move ip_options_fragment() out of loop
    https://git.kernel.org/netdev/net-next/c/faf482ca196a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


