Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D8F3F5A7D
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 11:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbhHXJKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 05:10:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235396AbhHXJKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 05:10:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E2AC7613A7;
        Tue, 24 Aug 2021 09:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629796205;
        bh=pDeB2+Wn0DYZ8v/kDywyMGyLG102DnAMt7BCSCP4H4o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gn8YYN+SkZlGAzFTJpOmjJsPUQ7eUiBh2fNCVYjIBKhATtUaqjYOdZkX38KJjRh6F
         SZCWGJ9qGQwHhPI3ine9fokUzVtPiOMfqF3fFvW5wHdsoHMEup9XOlkfqIfOBwnJ7S
         oe5oyR6Fk+8dBiguRTiRnBWG14xhlTuVXl2+5xSfmMjJiRq9+AazcyuUZKMo7CWWVv
         x/qHbohop60RcSF6Apf8PNFDdvH/IOUipUVJEF5wgB53sPsLX7hjGlNb+H6UA4NDsy
         nf4nfk13XT/YJUH/CfnKafVt6Srxl1BROEmyDmLGXOQ8o1lyG+UIq3cCGNPBsiVIRc
         ih8GF+U7YCroQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D542960978;
        Tue, 24 Aug 2021 09:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: correct comments about fib6_node sernum
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162979620586.12284.12231009298983193608.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Aug 2021 09:10:05 +0000
References: <20210823034900.22967-1-zhangkaiheb@126.com>
In-Reply-To: <20210823034900.22967-1-zhangkaiheb@126.com>
To:     zhang kai <zhangkaiheb@126.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 23 Aug 2021 11:49:00 +0800 you wrote:
> correct comments in set and get fn_sernum
> 
> Signed-off-by: zhang kai <zhangkaiheb@126.com>
> ---
>  include/net/ip6_fib.h | 4 ++--
>  net/ipv6/ip6_fib.c    | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - ipv6: correct comments about fib6_node sernum
    https://git.kernel.org/netdev/net/c/446e7f218b76

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


