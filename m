Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07142BB4DD
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732172AbgKTTKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 14:10:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730277AbgKTTKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 14:10:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605899407;
        bh=2FSu0dVGRklxbAx0LXFQjzwkvrDhOzRzt4vJxyVI5PQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=z/kRNGBd03Ue3pCANu3s1WSKl4dbBfhtjWTBHDd33i5I0k3mxXD/36LJ4lfnjJgtV
         U+m/QHL9rl6TdrVp1TuOl1dGgT0DO3BX/kkCfKoQMXdv/1SQ7J74k85UZASLT6y+mE
         qTZYkjZCYelXlAbsMXhluz1CActnHFKJitU3GzRk=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] octeontx2-pf: Fix unintentional sign extension issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160589940695.22082.5686784886721691946.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Nov 2020 19:10:06 +0000
References: <20201118130520.460365-1-colin.king@canonical.com>
In-Reply-To: <20201118130520.460365-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, kuba@kernel.org,
        naveenm@marvell.com, tduszynski@marvell.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 18 Nov 2020 13:05:20 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The shifting of the u16 result from ntohs(proto) by 16 bits to the
> left will be promoted to a 32 bit signed int and then sign-extended
> to a u64.  In the event that the top bit of the return from ntohs(proto)
> is set then all then all the upper 32 bits of a 64 bit long end up as
> also being set because of the sign-extension. Fix this by casting to
> a u64 long before the shift.
> 
> [...]

Here is the summary with links:
  - [next] octeontx2-pf: Fix unintentional sign extension issue
    https://git.kernel.org/netdev/net-next/c/583b273dea75

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


