Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F3B2DD8FB
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 20:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbgLQTAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 14:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729976AbgLQTAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 14:00:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608231607;
        bh=tkbRZI4MahMfFZzBoVWuTbgeL+mUCSMZVYmPay2x5cI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fPnNWevK9yN4+8S4PKfP9zF4cfVfY5PVjBdYNyfmU723uAuaM/5uYDIZCBDrbkEpq
         6/uAzkLLqKk82kMWxAr+DfncAR0th27Y0+E+2yeEPMQVyqCjhlB1OzcoQsJM1IZrId
         Ud3H/n2q/BSyz/FBshJNd4GYij8dGPrfKblxOxrgcZflOMWv1a5NoJXewACWl0ft9n
         4kWMOnZE7deErD/V68pWAsC/64c2pVqMYa7FvWiPSGeE8iNLpgQTJZHl+6QuorC/px
         UhC/7/IXaw2+gkdbmCAGNadswBvMgPs+FIJecKQ218AWWSVxruU3syp6SWzDtAYmlo
         c/izGYz4mZ0Ag==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: nixge: fix spelling mistake in Kconfig: "Instuments" ->
 "Instruments"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160823160785.4885.7822597887930335390.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Dec 2020 19:00:07 +0000
References: <20201216120020.13149-1-colin.king@canonical.com>
In-Reply-To: <20201216120020.13149-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Dec 2020 12:00:20 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in the Kconfig. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/ni/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: nixge: fix spelling mistake in Kconfig: "Instuments" -> "Instruments"
    https://git.kernel.org/netdev/net/c/38ba95a4ed24

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


