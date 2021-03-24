Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A38E348551
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 00:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbhCXXaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 19:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234203AbhCXXaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 19:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A6F5561A1E;
        Wed, 24 Mar 2021 23:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616628608;
        bh=rFpcQUI78c3rwpREV/SOF2xCqwd6NFv1+ACBB+zz4J8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=usD/bk0s0AIuWyJsp0ZU0WgakUGCpoyQ9X4d2EWEQRRLn2QKdM7rTapUXMCO77I7A
         DLbFgjFD2ieCKLdOyw6gGhtD5skGD6LWD759FitNajj4sfyb83OvRenVc4AqAZvJ3a
         AWpc31A2AA2+5W57DN0XzIIIGI5RTu4Bj4WLk1TfLjWkA2ljzm2iWECEZth7iEF9j1
         or23KlqQ1RbLOV3dOSQ7+SqqSKeSf0EQvnbLZY8a1NOxveHvJH7rHD9dRRIaC27407
         UlNL0nJO29oxcKh+zqpysuR34yAKPVHq3yDpFBZDDjDfdYHhs+C/T3WM27Wzjf6SPu
         RXLzxXTcmykRQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9A07D60A6A;
        Wed, 24 Mar 2021 23:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: decnet: Fixed multiple Coding Style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161662860862.17876.10012869659747642020.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 23:30:08 +0000
References: <20210323174419.f53s5x26pvjqt57k@ubuntu>
In-Reply-To: <20210323174419.f53s5x26pvjqt57k@ubuntu>
To:     Sai Kalyaan Palla <saikalyaan63@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gaurav1086@gmail.com,
        vfedorenko@novek.ru, andrew@lunn.ch, David.Laight@ACULAB.COM,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bkkarthik@pesu.pes.edu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 23 Mar 2021 23:14:19 +0530 you wrote:
> Made changes to coding style as suggested by checkpatch.pl
>     changes are of the type:
>             space required before the open parenthesis '('
>             space required after that ','
> 
> Signed-off-by: Sai Kalyaan Palla <saikalyaan63@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: decnet: Fixed multiple Coding Style issues
    https://git.kernel.org/netdev/net-next/c/c3dde0ee7163

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


