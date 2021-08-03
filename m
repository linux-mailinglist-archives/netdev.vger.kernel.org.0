Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E673DEB7A
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbhHCLAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235562AbhHCLAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1587461104;
        Tue,  3 Aug 2021 11:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627988406;
        bh=kRXJ3Y+HRgp5wRxsEeqTmhF2aDWFtY3XyCRq+UUqmDo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t68Ns+NtxgDC33T8XneJMstwmTG3cpawWgkA3XYAnvrtYok83Zch0E4iI/zvnAWxl
         SVGgoZgXkczVJATWVI0M7JuwyRICJR2Ap34eAzoajtyYthvo1GzlX68BUF31Mp5OOd
         jf1K7M7TrhlBPSq9x/VqHXJFgX18weSs4ktq+pZk3dkilSGTML7Pbb+kkdUsBxjQwF
         2hhCmwBGiZl8VH0KpTlx/O3ZGk4oWG0shGrTjKXKh8R3MrtMRHIPC7fTvd1brm2v6u
         6Z344xKeR/Pko9dMrpMHsrBpFxFubrFLWyTxHrbJgDNeyvvlVyBYCFpaa5+G1D/nTX
         w6nCt7uSE8uLg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0FC6B60A49;
        Tue,  3 Aug 2021 11:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sparx5: fix bitmask on 32-bit targets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162798840606.8237.17724316386643673744.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 11:00:06 +0000
References: <20210802152201.1158412-1-arnd@kernel.org>
In-Reply-To: <20210802152201.1158412-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        bjarni.jonasson@microchip.com, arnd@arndb.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  2 Aug 2021 17:21:53 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> I saw the build failure that was fixed in commit 6387f65e2acb ("net:
> sparx5: fix compiletime_assert for GCC 4.9") and noticed another
> issue that was introduced in the same patch: Using GENMASK() to
> create a 64-bit mask does not work on 32-bit architectures.
> 
> [...]

Here is the summary with links:
  - net: sparx5: fix bitmask on 32-bit targets
    https://git.kernel.org/netdev/net/c/f41e57af926a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


