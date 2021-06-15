Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEC13A884E
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhFOSMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229557AbhFOSMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 14:12:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 893C4611CE;
        Tue, 15 Jun 2021 18:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623780604;
        bh=c76jD4oA7igidUWroKyTS3zBzhgCDUSuiQLYhEAhm+M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jd+iQ+WrEHj537KdA27t2fqhllHv2IFN4oiUkNNGUuvoHfUbekXPQjNt/n3oLJqCw
         K8LHyHA/5r5q1ljClUyitcFCEU9ZHccJXOIpU7ZRKti21yAj4oFmj7RLwL4Z420TWS
         +IMK/VLCxyrQKqBhDMtgjJ1MNQWoYRPzMGw1OzA/SOs5PUoFiD2Bv02GoduTzCr5+R
         Y1dGYhJRUFcapeEE6PQn0XGCzEeqtn3fxIeLwX6jyCBJp/oyLpc4JrRPcMQyNm9wvi
         hjOcXNjQxA20iKQ5p6w0H9rAW10VwP7Qyn8ARx22iWF/xaOgYoqN5zKDw7Tmwe64TE
         4MZdLI3xMijfQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7BADE60A54;
        Tue, 15 Jun 2021 18:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ptp: improve max_adj check against unreasonable values
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162378060450.20077.9174893174238822320.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Jun 2021 18:10:04 +0000
References: <20210614222405.378030-1-kuba@kernel.org>
In-Reply-To: <20210614222405.378030-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        jacob.e.keller@intel.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 14 Jun 2021 15:24:05 -0700 you wrote:
> Scaled PPM conversion to PPB may (on 64bit systems) result
> in a value larger than s32 can hold (freq/scaled_ppm is a long).
> This means the kernel will not correctly reject unreasonably
> high ->freq values (e.g. > 4294967295ppb, 281474976645 scaled PPM).
> 
> The conversion is equivalent to a division by ~66 (65.536),
> so the value of ppb is always smaller than ppm, but not small
> enough to assume narrowing the type from long -> s32 is okay.
> 
> [...]

Here is the summary with links:
  - [net] ptp: improve max_adj check against unreasonable values
    https://git.kernel.org/netdev/net/c/475b92f93216

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


