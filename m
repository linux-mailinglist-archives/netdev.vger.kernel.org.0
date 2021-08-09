Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9063E4F67
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 00:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbhHIWk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 18:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234547AbhHIWk0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 18:40:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DEA846101D;
        Mon,  9 Aug 2021 22:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628548805;
        bh=hL8j4vK1bZxYvVe6VYFe7EpcAgmXWDL8lTZ16Vnr0fQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RGqnXgt7uy5R3AHmyCsKnR6ktWdYl/PuGfZWzOvTaH9AnTkD6m9zp46y6dNoJdrFC
         zDTJcpLTC3IWKHD9AccQJskpj3Z6ujTjAdPXjFFtnR4UTNDc+GP0orzX0n7BqlIlKB
         S+N1x9PYBDperuty9UDOhrKFxZNatvyVF/rfqfl6qNNk8fjfodLGsSj8+WpnvVE08n
         FxrBEkLmJmOIGvYx6aFYWTeg9WbGoB3jz2lJIVFMEQ5XHQuV25RfErEnMAD/XtCmqk
         RWRnw19JkpPL777ePZQ9oqDaqPodzm74jjBxTXlOS+d2yxVfNDVfvsfO+gwltwlGXu
         Ys6q+9OaerYiw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CDA5060A47;
        Mon,  9 Aug 2021 22:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] psample: Add a fwd declaration for skbuff
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162854880583.3525.5525072902649869659.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Aug 2021 22:40:05 +0000
References: <20210808065242.1522535-1-roid@nvidia.com>
In-Reply-To: <20210808065242.1522535-1-roid@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 8 Aug 2021 09:52:42 +0300 you wrote:
> Without this there is a warning if source files include psample.h
> before skbuff.h or doesn't include it at all.
> 
> Fixes: 6ae0a6286171 ("net: Introduce psample, a new genetlink channel for packet sampling")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> ---
>  include/net/psample.h | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net,1/1] psample: Add a fwd declaration for skbuff
    https://git.kernel.org/netdev/net/c/beb7f2de5728

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


