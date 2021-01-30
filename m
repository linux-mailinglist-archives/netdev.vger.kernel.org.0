Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47660309161
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 02:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbhA3BxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 20:53:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232307AbhA3Bur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 20:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 72CAD64E02;
        Sat, 30 Jan 2021 01:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611971406;
        bh=ib3wygmXvFBym4GXiMuwBb9Jx+T6NTvh6bSdAwwR5Lw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DEAQO4W07QZB40Dz4HcTS99vFx/M0SKejSljXmxRqdx1a670CjvDJO5Asv+wEiK4T
         KHR64cFa5toxpGCAoPcluhlzUYaPoj+EZTUkNncFHzhXghTc7EKNpVJgkLflGZxCC4
         5vfk+Y1Ho2INqG1z5g+zb7LIpN5k2GdeOgLWHAYnqGvYoKoJ0ZrDEqbOlwkCioay2L
         D/JtFjwNXo7ZUjbQAwprAXZHWl0Rm+WtL2VakIdxFom4FpIZBA+37q2WZvfKEBC5SQ
         oDBhjSJID0YO/a5xEelByV4RwfcO4mHVGEdwsovRFF5vZPkM6YqaluEqZ0jI/pxCgT
         Fc+8x5Im/FN1A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D82F6095C;
        Sat, 30 Jan 2021 01:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: packet: make pkt_sk() inline
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161197140650.15399.13818703401509106390.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jan 2021 01:50:06 +0000
References: <20210127123302.29842-1-dong.menglong@zte.com.cn>
In-Reply-To: <20210127123302.29842-1-dong.menglong@zte.com.cn>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, willemb@google.com,
        dong.menglong@zte.com.cn, tannerlove@google.com,
        john.ogness@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 27 Jan 2021 04:33:02 -0800 you wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> It's better make 'pkt_sk()' inline here, as non-inline function
> shouldn't occur in headers. Besides, this function is simple
> enough to be inline.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [net-next] net: packet: make pkt_sk() inline
    https://git.kernel.org/netdev/net-next/c/8c22475148a8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


