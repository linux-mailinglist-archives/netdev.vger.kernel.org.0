Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C8F3AD28E
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhFRTMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234004AbhFRTMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:12:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DD5CF611CD;
        Fri, 18 Jun 2021 19:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624043403;
        bh=yHi5hmdCTJXfhPTaItXGrrcfwfFO5yVubE0rGaw8BJc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tfwP7rScC+Afb6endM3o6PAT/p1ugXXwFwM0v+Y0VV0o2nr45XaFVksDlgYQlqjv9
         DVoHlPsmu//pXNAllQ4F+20ucfOoapM7LU6Mq974Pb6dXI4P//bQXUTDv2V4TfkQV1
         z57B8gdPJwNS6yIJ+et18pe/KOqDxHqljegohiaH1pjMZpmVW9FcgqNaSbzeNwabxX
         puJXgqAiTqDqV21JRrofNZ4PEvIFr4nnwnStgpsg5fEWZXXhztaXl/aXqEx4L5A2eV
         TBwpMjSwp4MYaV8PYHe5vcOKsC64BnW5Ol5vm0C+t1gkErPZuzUFMdfPGlkhvc6fxs
         nkEe8LqkDQ3oA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CC2A560A17;
        Fri, 18 Jun 2021 19:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: add Guvenc as SMC maintainer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404340383.6189.12452797951801238164.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:10:03 +0000
References: <20210618070030.2326320-1-kgraul@linux.ibm.com>
In-Reply-To: <20210618070030.2326320-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        guvenc@linux.ibm.com, jwi@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Jun 2021 09:00:30 +0200 you wrote:
> Add Guvenc as maintainer for Shared Memory Communications (SMC)
> Sockets.
> 
> Cc: Julian Wiedmann <jwi@linux.ibm.com>
> Acked-by: Guvenc Gulce <guvenc@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [net] MAINTAINERS: add Guvenc as SMC maintainer
    https://git.kernel.org/netdev/net/c/35036d69b9bd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


