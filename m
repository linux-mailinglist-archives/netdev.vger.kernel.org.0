Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2FA3DEB3D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 12:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbhHCKvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 06:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234821AbhHCKuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 06:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 39F7961053;
        Tue,  3 Aug 2021 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627987807;
        bh=2Kd6xtJidOZ+3jUF5CJInqsmH1vhPwhEe6Ee0krDxMU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NTnHXXA471B4F/UBh8YmqAUPrU1ndx7mDH22My5IrOu78W6M7CO9tsMMrhh1OYSFH
         Mkv0HQm1Na1CttdPdHTRwWZMaKeNjsx2SGkYek9SajnOzGwk85I8q5BHRd5yJIfMXf
         iHzkd+bqRuXdz2eavqmYVfOkkqjOA0xK+ZIWY9d1ntRAgtl1s9bFu5n7s6p9g/8EHk
         pFSZFT84RaVYNBAEhAEPOuM7QufKM0AZy7verIcHvLAa56GpVLSVh4t2LkqEWi/JYg
         pzz5to5NsoXrpldoR2C/9goxAphqrBeUBVeK+9QO7TmAoRe0ETCxRp0pejRgWJNJzu
         PybetrBmSNuiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 30BA560075;
        Tue,  3 Aug 2021 10:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: Skip DORQ attention handling during recovery
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162798780719.3453.7886686507840717608.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 10:50:07 +0000
References: <20210801102638.20926-1-smalin@marvell.com>
In-Reply-To: <20210801102638.20926-1-smalin@marvell.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        aelior@marvell.com, malin1024@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 1 Aug 2021 13:26:38 +0300 you wrote:
> The device recovery flow will reset the entire HW device, in that case
> the DORQ HW block attention is redundant.
> 
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_int.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)

Here is the summary with links:
  - qed: Skip DORQ attention handling during recovery
    https://git.kernel.org/netdev/net-next/c/cdc1d8686658

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


