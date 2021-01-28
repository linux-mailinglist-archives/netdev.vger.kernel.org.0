Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EAD306ADD
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhA1CBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231172AbhA1CAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 21:00:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A1D1364DD1;
        Thu, 28 Jan 2021 02:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611799211;
        bh=IL7/nKWTzD56pV6j+IR/D5ZARdQy3bG50GaMnP7gh10=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IWh4F8XzEuVlUtHslGj8kMXa7YnNS4hqbBMh32n/VHUZMFqNnQ6+i1ka8gu7cNi1n
         3kOnuuYTs4LEhDxPKlADNUdUBDcHGjX8gB4UfqEoBPnbNNANnzlkc0URJlAGh2gSsL
         aSa89V7w4RIGR3B0CI0/CIhA+JrR4JdHRtbG8qYo+1CI+K4xVu70ZAJNtr/XZ98Qzw
         DHidV9mq8GKrDNEkwPb3RlJ11CwQQ1XaYhdXc1mi2T39b3STKcmVbptpvVdIG2H/CL
         zAzFIi8d4TteUaPGrjspVAFV4aQNeCV/cEaFVRNOl0/yyF/1B44scTP9zSvfGMvFV0
         3T1MFhV25h9xA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 949A765321;
        Thu, 28 Jan 2021 02:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] can: dev: prevent potential information leak in can_fill_info()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179921160.8807.12504812177408096586.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 02:00:11 +0000
References: <20210127094028.2778793-2-mkl@pengutronix.de>
In-Reply-To: <20210127094028.2778793-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        dan.carpenter@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 27 Jan 2021 10:40:28 +0100 you wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> The "bec" struct isn't necessarily always initialized. For example, the
> mcp251xfd_get_berr_counter() function doesn't initialize anything if the
> interface is down.
> 
> Fixes: 52c793f24054 ("can: netlink support for bus-error reporting and counters")
> Link: https://lore.kernel.org/r/YAkaRdRJncsJO8Ve@mwanda
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net] can: dev: prevent potential information leak in can_fill_info()
    https://git.kernel.org/netdev/net/c/b552766c872f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


