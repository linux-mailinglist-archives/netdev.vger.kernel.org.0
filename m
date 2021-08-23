Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BC53F4A30
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 14:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235953AbhHWMA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 08:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233489AbhHWMAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 08:00:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 17AD56054E;
        Mon, 23 Aug 2021 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629720006;
        bh=xzyNS611BHZ/fQVGuhTfONHp7Jz8WSfBcviw1QY7gCs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U9Q4gVjx03MgsuH7rfVsQGhlI/dzIxGDR3UVVZZ69BBs+wxE2HaV7/Pjiky3k42wn
         AdlMdnvDOeaFdkNDBmee9w1n3YmRRQTLmCk2yGhXgF4xSNDQMQ1nm7Tet5QvAGVHeF
         //z/avSU6pPscJ6E4fcjACWtSZknSJjlULA8S1/8pIE08jBrcGVevU/jCUnx4c+MBw
         yrfJkeskD+sigaswGxOauQjEYJif4CC7cAPeLX4uy/gPPzvTBuDsZreB4W6VRq50yx
         7W1XwVjgH48ACyTvF61aor5X7MTKpBSdNVX79fOdpQutzQxM3mJjwXEHwd4VHwnl93
         gNT9NyetaT/Og==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 043DE609E6;
        Mon, 23 Aug 2021 12:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: marvell: fix MVNETA_TX_IN_PRGRS bit number
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162972000601.531.12302229457725752969.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 12:00:06 +0000
References: <20210820153951.220125-1-bigunclemax@gmail.com>
In-Reply-To: <20210820153951.220125-1-bigunclemax@gmail.com>
To:     Maxim Kiselev <bigunclemax@gmail.com>
Cc:     thomas.petazzoni@bootlin.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 20 Aug 2021 18:39:51 +0300 you wrote:
> According to Armada XP datasheet bit at 0 position is corresponding for
> TxInProg indication.
> 
> Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: marvell: fix MVNETA_TX_IN_PRGRS bit number
    https://git.kernel.org/netdev/net/c/359f4cdd7d78

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


