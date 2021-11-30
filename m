Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C7446341B
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241506AbhK3MXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:23:33 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39028 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241496AbhK3MXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:23:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BF612CE1988
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB2EBC5831C;
        Tue, 30 Nov 2021 12:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638274810;
        bh=ciwZageOY5+JkhmaAYXjehLpVj7vvyuARGe7EjhvlGE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ltg3K+gJ3dyafhJIVJnF3hJlkB16QaxeTjW9CUWpDs1JyXREBSNQNh17IinmpqJG8
         90igkCNsm3kU+wewoDCp9sRO0pxmpCsaBXeIBQMMbEILQ7Pj5PBNXYjYRG4luD0D5j
         SuvwLBLeWBRa9B3layalwVLnmjL4Mq/fBO6ZOsj2YW/idd6GnY6FqF0i+m1ejDq12t
         hxt62IEFpgbPkV6r9zTd02J5z8EJ/pNyrT3iAw88Q1MvTje7RYyDH0Fbw5Hxot6nZ5
         UzXl1F8rC1TpxEzsQq4+ZWD+FqxcNY93lm37J3Cs7kDM9FRt/oiVJgWxM81NbUzk8j
         Owwag5gJQ979A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D7B1660A7E;
        Tue, 30 Nov 2021 12:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: cxgb3: fix typos in kernel doc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827480987.28928.981589964221650347.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:20:09 +0000
References: <20211130070312.5494-1-sakiwit@gmail.com>
In-Reply-To: <20211130070312.5494-1-sakiwit@gmail.com>
To:     =?utf-8?q?J=CE=B5an_Sacren_=3Csakiwit=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 00:03:10 -0700 you wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> Fix two trivial typos of 'pakcet' in cxgb3 kernel doc.
> 
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb3/sge.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: cxgb3: fix typos in kernel doc
    https://git.kernel.org/netdev/net-next/c/067bb3c307cc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


