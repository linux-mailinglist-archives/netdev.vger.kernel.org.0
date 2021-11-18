Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2364553D0
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242977AbhKREdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:33:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233419AbhKREdI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:33:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0B0D061AA3;
        Thu, 18 Nov 2021 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637209809;
        bh=RBxitIJuzJN2RBGODwVt+BGs/9m5eqdHo0LhlVPtu8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Igc3JzN3BHNuqg+KSD7Nxbw6RNBtJWWoEL89UHsUsqYWK6thnoTTkg5YOpvunANH3
         vcQ3sONzR3iPaodZ5IhnYc1rLSP5ak1Gn+ekVQBLvzlAeqUQO9v1XKoCjR47HKIJlP
         4YqBG/WyEX909nRZFgwmngNPKgX/lzxIMCHHMCy4fwFR7enPDtPfub5rNH9G9ndMRV
         JmkYpCDoiETSlXDMZYUuKK7u5+EHjcKMVuXF4WZO5TfpcaVp8kP52fvlnoOc/gz/Zr
         KsCYJoLBZsAgDFJ/+0Lmv0Ku33rFVuPHFkbf0MXr7fhmlGV9TLixy9iyF9fYk5ODLr
         1R0HPNVYMw5lA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F370C60A0A;
        Thu, 18 Nov 2021 04:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] NFC: reorganize the functions in nci_request
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163720980899.29413.15836654503767277273.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 04:30:08 +0000
References: <20211115145600.8320-1-linma@zju.edu.cn>
In-Reply-To: <20211115145600.8320-1-linma@zju.edu.cn>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     netdev@vger.kernel.org, krzysztof.kozlowski@canonical.com,
        davem@davemloft.net, kuba@kernel.org, jirislaby@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 Nov 2021 22:56:00 +0800 you wrote:
> There is a possible data race as shown below:
> 
> thread-A in nci_request()       | thread-B in nci_close_device()
>                                 | mutex_lock(&ndev->req_lock);
> test_bit(NCI_UP, &ndev->flags); |
> ...                             | test_and_clear_bit(NCI_UP, &ndev->flags)
> mutex_lock(&ndev->req_lock);    |
>                                 |
> 
> [...]

Here is the summary with links:
  - [v1] NFC: reorganize the functions in nci_request
    https://git.kernel.org/netdev/net/c/86cdf8e38792

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


