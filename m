Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F192F42DE
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbhAMEKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:10:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbhAMEKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:10:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9C6A423138;
        Wed, 13 Jan 2021 04:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610511010;
        bh=PyJeB3zDUEKvjrbDMFZg3PMeRMdsRea8AlrUJLnaKe4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rE4nAl4I3sjYN3o/pP6HCCMIXxeZSPpq2tfMe8bnEsPAa5y/Ub4IWNIKhvpuhF9+r
         MeV0L1HsYAXd/SxaqR68q7SPZWGiXZ6pjcfJfdp2orKhzbyeO8Czj/u4+BBZO0Jcn4
         mY/gF1FGWlCN/z/jsx8k5+rxrCIAl/TnV8GbGJYqJZalbECTyfvSwj3Suxa8kR6cFY
         1ogCaKkH1f4a4az0+eCC6BYhs2D09/CedNSIlzk2WIcghUmzZA61ePYQvOLEGAz6JS
         2SO2bssUHno0QNqI+mHcTY5r4so6oVgu44FNlhpS8L27CghbUPrlWFKyv+TiMwWhao
         KtYCFyrEMheiQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 9874360154;
        Wed, 13 Jan 2021 04:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] fsl/fman: Add MII mode support.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161051101062.28597.3713105927801627388.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jan 2021 04:10:10 +0000
References: <20210111043903.8044-1-fido_max@inbox.ru>
In-Reply-To: <20210111043903.8044-1-fido_max@inbox.ru>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 11 Jan 2021 07:39:03 +0300 you wrote:
> Set proper value to IF_MODE register for MII mode.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> ---
>  drivers/net/ethernet/freescale/fman/fman_memac.c | 4 ++++
>  1 file changed, 4 insertions(+)

Here is the summary with links:
  - [net-next] fsl/fman: Add MII mode support.
    https://git.kernel.org/netdev/net-next/c/5bc8f5ab3b75

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


