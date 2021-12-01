Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA52464517
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241465AbhLACxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 21:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbhLACxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 21:53:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8021EC061574;
        Tue, 30 Nov 2021 18:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47468B81DD6;
        Wed,  1 Dec 2021 02:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9F7FC53FCC;
        Wed,  1 Dec 2021 02:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638327009;
        bh=WjQfaBteavQVGvjcBxD6/WxaXi44xVjBawSieCO2qU0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OuT/sJiLgdcTk95OzydOMOtZACkLY8QdH/rbYEbCK0Eqrt5ea62r4VtXt8g910sls
         XL0suaruFnz8n1fwqjZQIx3hgmaeTm69/CRz1RFs+NccMpknjwxmauS7pHfPmNVOQ3
         kTexfUrZPihLgs/mjfFqTWp3FzOcZ3WtB/JakZtQuxorI6l1uyOTpqdiAUSYK4qI0d
         zZx66nxF0jtgnSht2l48CKnSu5e5+1JsQgWtYKhnzIee4o5V1csr04/c2D2At9dGh2
         BnxchpFpnLKvh8+fpSDWB5Wd2ZDIETJucp5e28Zf8NmddxDoXLorBDLhwUCmnENhEx
         XMrneo9iLV88g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CC25C60A4D;
        Wed,  1 Dec 2021 02:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: natsemi: fix hw address initialization for jazz and
 xtensa
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163832700883.18410.4563471558753780897.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Dec 2021 02:50:08 +0000
References: <20211130143600.31970-1-jcmvbkbc@gmail.com>
In-Reply-To: <20211130143600.31970-1-jcmvbkbc@gmail.com>
To:     Max Filippov <jcmvbkbc@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Nov 2021 06:36:00 -0800 you wrote:
> Use eth_hw_addr_set function instead of writing the address directly to
> net_device::dev_addr.
> 
> Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - net: natsemi: fix hw address initialization for jazz and xtensa
    https://git.kernel.org/netdev/net-next/c/23ea630f86c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


