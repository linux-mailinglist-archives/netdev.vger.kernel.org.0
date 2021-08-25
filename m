Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C48D3F724C
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239735AbhHYJuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237077AbhHYJuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 05:50:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D0DCA6115A;
        Wed, 25 Aug 2021 09:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629885005;
        bh=ho/Dxy0q/xcUsG9WR8NCpSe+tQ0c+57vDQtFo708owc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LikeluCuoyH96UG6TXo79K9ssTN4F6HkWpZvbeNLsRafprr3086Z4F281jAXxKwgs
         8F2UUSxeoMrAcEtsFgZQgy38/75u+rWukqbxfAbsxA3frgPjcCaXe00aQUcqZuvkkI
         ze2pxkiRrgVY5m0DQH39U225AT1WvsWjmn/Nwe3pLJk4BWY8dTtXaKG6iWAgnwMWoM
         /XyH/y4Byu9dbkW5YMVvjDB7eMKx3lM0f4NeRSij9onkq7jhB82QGIB/ftqumB0c9F
         SjVwht7UlhPnC1GcZsgiyQOUJvtVroL2uesvHbJ9Q3lni7XdZ94CeABlqCXWd2+Fmr
         r/CQHOGrCMiAA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C3A4E60A02;
        Wed, 25 Aug 2021 09:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macb: Add a NULL check on desc_ptp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988500579.26256.8039031793551400610.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 09:50:05 +0000
References: <20210824100209.20418-1-harini.katakam@xilinx.com>
In-Reply-To: <20210824100209.20418-1-harini.katakam@xilinx.com>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 24 Aug 2021 15:32:09 +0530 you wrote:
> macb_ptp_desc will not return NULL under most circumstances with correct
> Kconfig and IP design config register. But for the sake of the extreme
> corner case, check for NULL when using the helper. In case of rx_tstamp,
> no action is necessary except to return (similar to timestamp disabled)
> and warn. In case of TX, return -EINVAL to let the skb be free. Perform
> this check before marking skb in progress.
> Fixes coverity warning:
> (4) Event dereference:
> Dereferencing a null pointer "desc_ptp"
> 
> [...]

Here is the summary with links:
  - net: macb: Add a NULL check on desc_ptp
    https://git.kernel.org/netdev/net/c/85520079afce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


