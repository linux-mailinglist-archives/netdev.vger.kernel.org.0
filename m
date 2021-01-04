Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905882E9FA4
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 22:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbhADVuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 16:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:42236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbhADVut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 16:50:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CF7082225E;
        Mon,  4 Jan 2021 21:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609797008;
        bh=ktLasPF5LL+xB2S/z9EYKk/ANhzEOT2Nf8DBtMLtWA0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X9rjNaXl/h3uKSt29dhMvZkMqdzS3nv51t1zei1JuoJmQXCBewd7lSZy7WpT7x1Qa
         x9A8V6MzNS9Cn2jMKVUeEgqot/ei1XrAFbC8tjOewsRb1ui+1f5t60pSFLl1ZIVAJi
         pvu3L2M2+WDUpuN6UdUcEVbCBpFJ3SN2FTGchD/o9x1y+Ud83kq8Zy8o6pHDgW2aEL
         5jjtQvRHIYPsGAfN+ZRwBKo12CIsvYcJW/D/K8lJOFMHf02B04GEHELd+9di6J0AYV
         /XPkAlM6sq4fffMvKT8O+E7Tvmnaaezh3AjbdOcECc26FVpl0TXJ1KgvNMPRFTPBHr
         jggjMLEOO7EXQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id BCD7C600F6;
        Mon,  4 Jan 2021 21:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lapb: Decrease the refcount of "struct lapb_cb" in
 lapb_device_event
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160979700876.8172.3140864000017286214.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jan 2021 21:50:08 +0000
References: <20201231174331.64539-1-xie.he.0141@gmail.com>
In-Reply-To: <20201231174331.64539-1-xie.he.0141@gmail.com>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ms@dev.tdt.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 31 Dec 2020 09:43:31 -0800 you wrote:
> In lapb_device_event, lapb_devtostruct is called to get a reference to
> an object of "struct lapb_cb". lapb_devtostruct increases the refcount
> of the object and returns a pointer to it. However, we didn't decrease
> the refcount after we finished using the pointer. This patch fixes this
> problem.
> 
> Fixes: a4989fa91110 ("net/lapb: support netdev events")
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: lapb: Decrease the refcount of "struct lapb_cb" in lapb_device_event
    https://git.kernel.org/netdev/net/c/b40f97b91a3b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


