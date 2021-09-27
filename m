Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67C841931D
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 13:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbhI0Lb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 07:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234005AbhI0Lbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 07:31:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B7B2A60F58;
        Mon, 27 Sep 2021 11:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632742217;
        bh=X0n8CBcfi66vibosjws1hCAPmZXMRakibr4Go16rotM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NEM8O/zxfpqrv031ihsEnQyyfaRcM6oJJlPTWEA2GSS+vYAqKq9p/VikALxVNJtFw
         U0ivEMuzfm9RX8+8B8148Daq9UemctcETnsZ6lf5eymVofvYAafWxxhy/B2lOmEamq
         GH8TKUO2Cn/WV5HT11NZc9g4N20fQBpcNUepHHIGHwCSM5ahe7XmgEbFgnsRNCDyI3
         7jK5ER/mxXn510wgmJoSHJn/xkPpt40c4sKRqZ4t4f7tPRuG5Zosi9eCt/WbmS5bho
         l17wJK3MSHJ7CS1aUexkXk+gs40sdIcKR2D1cuFfqq4oE33ec6u/M9abc+QMMlnn3P
         HHrGuRRHcBvQg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ABFE960A3E;
        Mon, 27 Sep 2021 11:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] ptp: clockmatrix: use rsmu driver to access
 i2c/spi bus
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274221769.5839.1741172881356321714.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 11:30:17 +0000
References: <1632510092-25158-1-git-send-email-min.li.xe@renesas.com>
In-Reply-To: <1632510092-25158-1-git-send-email-min.li.xe@renesas.com>
To:     Min Li <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 24 Sep 2021 15:01:32 -0400 you wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> rsmu (Renesas Synchronization Management Unit ) driver is located in
> drivers/mfd and responsible for creating multiple devices including
> clockmatrix phc, which will then use the exposed regmap and mutex
> handle to access i2c/spi bus.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] ptp: clockmatrix: use rsmu driver to access i2c/spi bus
    https://git.kernel.org/netdev/net-next/c/930dfa563155

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


