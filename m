Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8136F3102CC
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 03:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhBECau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 21:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhBECas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 21:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0FB5564FB3;
        Fri,  5 Feb 2021 02:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612492208;
        bh=+tE2aZIOt0fBJ8VEUJuPe0P1WmuP1WELpwrpQMaKxgc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jm92b1IT9CKzMbGCnVOgGwtLZSt6OvVtbBw10HAOhDYhrrDikrPwKWt9RG72wZWql
         aYlwmK+YLORleHBXUVgxsvykFZJiWHTFR+RG+uLm0GZK05G6fJhL0njPo4UfAa5xQz
         AK0Y4Jeix0yINsXQDdGZ0vIaxHs1V5432SlmCDPrduUy+ArWP4fTZBU2dCrkzpkCQE
         QgidQlgrc7nJEkTOGM8wVWGFNVVktGKJ4xOlsJYg/ZpgKJVmitSlIEelai/E5mcIDz
         5dS3OC73/BpDIcayzYLzqrvIoMtoWQSN2yf3IGiyno5/aLxJUUY0MMJIqGKh22FTXw
         xfyYTjKmJOIbQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DDAE1609F3;
        Fri,  5 Feb 2021 02:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] netlink: add tracepoint at NL_SET_ERR_MSG
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249220790.5682.15524436793401125572.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 02:30:07 +0000
References: <4546b63e67b2989789d146498b13cc09e1fdc543.1612403190.git.marcelo.leitner@gmail.com>
In-Reply-To: <4546b63e67b2989789d146498b13cc09e1fdc543.1612403190.git.marcelo.leitner@gmail.com>
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, kuba@kernel.org,
        marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  3 Feb 2021 22:48:16 -0300 you wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> Often userspace won't request the extack information, or they don't log it
> because of log level or so, and even when they do, sometimes it's not
> enough to know exactly what caused the error.
> 
> Netlink extack is the standard way of reporting erros with descriptive
> error messages. With a trace point on it, we then can know exactly where
> the error happened, regardless of userspace app. Also, we can even see if
> the err msg was overwritten.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] netlink: add tracepoint at NL_SET_ERR_MSG
    https://git.kernel.org/netdev/net-next/c/7e3ce05e7f65

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


