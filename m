Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9263333C6F7
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 20:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhCOTkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 15:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232515AbhCOTkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 15:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9958C64F52;
        Mon, 15 Mar 2021 19:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615837208;
        bh=j4ga2LdEMQ7R9ZIcSlcQT78N1ljOnveXwD920HoPg44=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YfvgoTKTsHh5NZB3RwWA8aGcQoBvy5bpd2IffAdcdR6/HGvzC57c1x+rl6PIhpWXY
         C13vVx63pwXWkAsrsw4isYkt6iaTCMxJ4//o0mm6Ag5I4nsAA7EsGzUdbWqSu4reIa
         yAsamOqsltMJ09Y2R/zv7Vjvqz9800LsaaaR7JKNxxvAg9CozgI7ZSw12SplAwCkbb
         lydO2oEGPOiE1L72wJHJDdUrmLE1vePey3Ok1tkVJJPrQEjhQkwSgrMDhwY6a0mlD3
         Rafi8asRdCyhltRHtTjd6kvh2EO/8ErpDejD0++GoLJKIj1+qgZs1zo4iBz+5JzBjd
         zGOqTgdiNiYbA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8CCC7609C5;
        Mon, 15 Mar 2021 19:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: export dev_set_threaded symbol
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161583720857.23197.15037714790020050109.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Mar 2021 19:40:08 +0000
References: <9ee5ba9ca7506620b1a9695896992bfdfb000469.1615733129.git.lorenzo@kernel.org>
In-Reply-To: <9ee5ba9ca7506620b1a9695896992bfdfb000469.1615733129.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        weiwan@google.com, nbd@nbd.name, pabeni@redhat.com,
        edumazet@google.com, hannes@stressinduktion.org,
        lorenzo.bianconi@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 14 Mar 2021 15:49:19 +0100 you wrote:
> For wireless devices (e.g. mt76 driver) multiple net_devices belongs to
> the same wireless phy and the napi object is registered in a dummy
> netdevice related to the wireless phy.
> Export dev_set_threaded in order to be reused in device drivers enabling
> threaded NAPI.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: export dev_set_threaded symbol
    https://git.kernel.org/netdev/net-next/c/8f64860f8b56

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


