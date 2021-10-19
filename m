Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4506E4335CB
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbhJSMWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230513AbhJSMWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 08:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 999AE61360;
        Tue, 19 Oct 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634646010;
        bh=VeDrrE7ogjkDjlQCNJOEFQtNOrHmD/UPVHH400oNckI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W9Ac7dYICXkwMJJGMut/l5moJD1+afTPJo5OzApZqcNKxXn4wdQmEb+s4UbQeNekV
         tO3veb5rZy66s4lBvBzyVwt8bYiiKtoqx3zS1PbPSCTqnDtamps3rNpp1itVFI6vhs
         gUZCUmidbcj2qL91ZVne1+7AEo2dUqG+d1PTrz6UJ7OhG92YiGbpEUd8mzOSs9s82R
         5TTvIqkcWkMwp7USL0cm425ocaGAmh5rTzoo3kzxBkdQrWJWiQLvqLUSHL/y/eDhIg
         3ldaEzloYDE1FOLLE5oEiV5f10+7M/UTrHBVvYLIyk6cdSGLPY6eO7qP46Wh7M1svI
         /mJtHqVz2cYzw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 92F3A609E3;
        Tue, 19 Oct 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH linux-next] ethernet: Remove redundant statement
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163464601059.7615.14277737202380451691.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Oct 2021 12:20:10 +0000
References: <20211018085513.854395-1-luo.penghao@zte.com.cn>
In-Reply-To: <20211018085513.854395-1-luo.penghao@zte.com.cn>
To:     Ye Guojin <cgel.zte@gmail.com>
Cc:     siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        luo.penghao@zte.com.cn, zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Oct 2021 08:55:13 +0000 you wrote:
> The variable will be assigned again later in the if condition,
> there is no meaning there.
> 
> drivers/net/ethernet/broadcom/tg3.c:5750:2 warning:
> 
> Value stored to 'current_link_up' is never read.
> 
> [...]

Here is the summary with links:
  - [linux-next] ethernet: Remove redundant statement
    https://git.kernel.org/netdev/net-next/c/3c71e0c9ab4f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


