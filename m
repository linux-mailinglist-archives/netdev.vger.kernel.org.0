Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F94A340D50
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbhCRSkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232635AbhCRSkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 14:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B443C64F2A;
        Thu, 18 Mar 2021 18:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616092808;
        bh=ngizKt9HgJPxu3y8f592bAWS3OrdNI8dbCv0zxTcLA8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vBNRQaPt7bSQ/Cqs1OSjiDqRRTnx+rJ+XmZfcLhxUlYSo25DEy+aUn6nCjF7jQYwg
         9hDDUV14F7Oy8bJ7SiCj43BLryDyATxpNgzC4DWw7iRNVzZcENg37c4izgwTTL7KoA
         RqZxjG44kuQRONLH2cvwsSUZPaMSxpagGhPne4OMhIAjrNtmEfdSlnzsOuPfoLvh1B
         Lnl15ZLSkPZyZYpd3obnNudU0pq1n6WuX0usRfpCdcCVCCVrqkV9nvs1CD7XHijVhN
         3Iy/uxTN8c3K/YP9AoMYvm4LqtaRTfbZrDHoMf4DTYQbMoqkpQKRZeo2fs614Wxqrp
         tqUSLNELPMAUA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ABBF060191;
        Thu, 18 Mar 2021 18:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netsec: restore phy power state after controller reset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161609280869.9904.11285050581115160035.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Mar 2021 18:40:08 +0000
References: <20210318085026.30475-1-ykaukab@suse.de>
In-Reply-To: <20210318085026.30475-1-ykaukab@suse.de>
To:     Mian Yousaf Kaukab <ykaukab@suse.de>
Cc:     jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, kuba@kernel.org, masahisa.kojima@linaro.org,
        osaki.yoshitoyo@socionext.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 18 Mar 2021 09:50:26 +0100 you wrote:
> Since commit 8e850f25b581 ("net: socionext: Stop PHY before resetting
> netsec") netsec_netdev_init() power downs phy before resetting the
> controller. However, the state is not restored once the reset is
> complete. As a result it is not possible to bring up network on a
> platform with Broadcom BCM5482 phy.
> 
> Fix the issue by restoring phy power state after controller reset is
> complete.
> 
> [...]

Here is the summary with links:
  - [net] netsec: restore phy power state after controller reset
    https://git.kernel.org/netdev/net/c/804741ac7b9f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


