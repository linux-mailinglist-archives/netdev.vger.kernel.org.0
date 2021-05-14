Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8C6381388
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhENWLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233435AbhENWLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7231E61182;
        Fri, 14 May 2021 22:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621030210;
        bh=jWBX/acuhaeVj4kkF31faeLjsTNbku1YNA2ws2xJ4Jc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MlUhu0CUUtTqCrL4tkKDGWCkeURC+hR75HjBYYiHVUnPJzfyFx7aQMhZLlUUluKwz
         7QgJxR0rwDxiRc6P2uPV/1glnrPLQs8DKmgnH7GHAQKMsrPU79WTBxr3diRK/PkNWt
         F7CttXMGoOkGFDljCTLcAK1KDDjPzwBBsRQ0bz6mzivhHu+X0Mo0NyWWv8Hit1ILuP
         +TDoavjC4nFjdskTR/owp6OWVIDcNAQyc6nz9bCsH586aCFEFkZtx7LqNdjYA3ySET
         QkOEw7ZECftOa5Zlwy7E12ewx9Yg7dNRtHpT2hlO8MS25joNd1ahCyn3mh/elHw3dM
         4VZdGx+cdS8wg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 688DF60A0A;
        Fri, 14 May 2021 22:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tls splice: check SPLICE_F_NONBLOCK instead of MSG_DONTWAIT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162103021042.1424.11162684679127652413.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 22:10:10 +0000
References: <96f2e74095e655a401bb921062a6f09e94f8a57a.1620961779.git.majinjing3@gmail.com>
In-Reply-To: <96f2e74095e655a401bb921062a6f09e94f8a57a.1620961779.git.majinjing3@gmail.com>
To:     Jim Ma <majinjing3@gmail.com>
Cc:     kuba@kernel.org, borisp@nvidia.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 14 May 2021 11:11:02 +0800 you wrote:
> In tls_sw_splice_read, checkout MSG_* is inappropriate, should use
> SPLICE_*, update tls_wait_data to accept nonblock arguments instead
> of flags for recvmsg and splice.
> 
> Signed-off-by: Jim Ma <majinjing3@gmail.com>
> ---
>  net/tls/tls_sw.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)

Here is the summary with links:
  - tls splice: check SPLICE_F_NONBLOCK instead of MSG_DONTWAIT
    https://git.kernel.org/netdev/net/c/974271e5ed45

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


