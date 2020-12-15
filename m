Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EBD2DA593
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 02:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgLOBbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 20:31:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729725AbgLOBat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 20:30:49 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607995807;
        bh=HJZ3qh6bDNXnSNxv3dg+5D+KwzR1ZfqLDxkWaXYeT6Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YjIxzIsfBY6d6nScTPoKmwJJxP169PLKUPl4TYwh1nPlQR0r/6I0jZz4ac3XCz2Dm
         At4o/i5D2c/riDb0cKfzLfn3grAE5wxSDgvy6sp2L94ihxiGCWSKq6tKcfzz9ATA97
         IxSrZdln8wE5udUf6WZnmVra87RmdQomt9heqNqlj8DrWSzzVtFJCD/FookCNzdL5u
         aKlT9Ns+LcjChXO6WoGa/fU54+SLyIMWKAnFFE5xpSizMs6jVBq8T+xKMK1HX2bAuF
         cvOXsw2qeidoVI0sDTDtYapOTpeQ2XwoUlL6YIBhtsWTl2RK45NSbfi7ky9uya+0BN
         46150orOyTVTQ==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mhi: Fix unexpected queue wake
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160799580707.752.1146500860056869280.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 01:30:07 +0000
References: <1607599507-5879-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1607599507-5879-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Dec 2020 12:25:07 +0100 you wrote:
> This patch checks that MHI queue is not full before waking up the net
> queue. This fix sporadic MHI queueing issues in xmit. Indeed xmit and
> its symmetric complete callback (ul_callback) can run concurently, it
> is then not safe to unconditionnaly waking the queue in the callback
> without checking queue fullness.
> 
> Fixes: 3ffec6a14f24 ("net: Add mhi-net driver")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> 
> [...]

Here is the summary with links:
  - net: mhi: Fix unexpected queue wake
    https://git.kernel.org/netdev/net-next/c/efc36d3c344a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


