Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7D74634B0
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241669AbhK3MoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbhK3Mnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:43:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1863C061759;
        Tue, 30 Nov 2021 04:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA583B81920;
        Tue, 30 Nov 2021 12:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D7EEC53FCD;
        Tue, 30 Nov 2021 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638276009;
        bh=LpOXZxtu+1ggM0sCF6B+mum4cTJd1LaYJEOaf4RF2o0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DCWCJcGzPryYgVtIpA2BZlczZS3hyMMuDMzHnHoTmhSUUNqPxnJ2QmomB19r1e8ZB
         gTq31mtcUhKBJw0S8exIjYAcJpYRHV3lw7LHW6rTAE7pRl9P9gn7Mf5TTAqAtfMfjI
         Xji/IzI7jtx8c8T5bWjwHHlOfEKlWvaPrndDv8zxcNiB9O5xcze6sg95c3sM04J+I0
         r8OdnpDzW9slUDNTzEx4S3mqtFvShtr5dAh4C+wjLkCwkE6aAKq3b2RC72bTn2OXdE
         wMZc29JBwYmkPWp4N+2Tyel4rWc9xXeINpADSZW2yxaerZakcFC5IVU5mZvUFDzHEo
         JcYE6DIkRMPWA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 57B8860A17;
        Tue, 30 Nov 2021 12:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mscc: ocelot: fix mutex_lock not released
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827600935.5473.4878942506314198203.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:40:09 +0000
References: <20211130112443.309708-1-lv.ruyi@zte.com.cn>
In-Reply-To: <20211130112443.309708-1-lv.ruyi@zte.com.cn>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lv.ruyi@zte.com.cn, zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 11:24:43 +0000 you wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> If err is true, the function will be returned, but mutex_lock isn't
> released.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - net: mscc: ocelot: fix mutex_lock not released
    https://git.kernel.org/netdev/net-next/c/9c32950f24f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


