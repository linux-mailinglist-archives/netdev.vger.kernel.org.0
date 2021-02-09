Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6633144A9
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 01:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBIAKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 19:10:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhBIAKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 19:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0379064E9A;
        Tue,  9 Feb 2021 00:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612829407;
        bh=MyqLTmTYWdCoa9xOBobCyJZLsqt5Eev24oJHBOwhtPs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jukg9GRMNzkK5bi+R0/fHoG9NWVmKe1o8HIQpoANzZr0LbDgWAKMqM7W+nQ61Wa3n
         bBzv+9Tt94EFXxEuulZ+8ayWfxNLApFUeF3S0IXUF1o9dTi7kZIyrUjo84Fl6ueMKS
         qr5r8nzlJyR0w5sGvtNZmMYSZbx5+oeDNwHrYBCnsFd8FwR+NZDSNLO1ToZH+TSIbU
         ga+ZTeTjhsiQnbnvN2E5K0v0NotEGCE9WSOamgjGke6aiKaLVzZM1G3cWxbpuC+cui
         baUHoonXiaww1584DirBuVvHXuMUe/Mzr8d27DwOuu9CppaELPoxfuFYuuznXAElH2
         tuZSG0KREUllg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EAAF4609D8;
        Tue,  9 Feb 2021 00:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] cxgb4: remove unused vpd_cap_addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161282940695.21160.16687766217971899380.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 00:10:06 +0000
References: <55c53828-1071-1bdb-6a47-c1f41e3f83d1@gmail.com>
In-Reply-To: <55c53828-1071-1bdb-6a47-c1f41e3f83d1@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     rajur@chelsio.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, rahul.lakkireddy@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 8 Feb 2021 21:26:07 +0100 you wrote:
> It is likely that this is a leftover from T3 driver heritage. cxgb4 uses
> the PCI core VPD access code that handles detection of VPD capabilities.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> - resend after dropping patches 2 and 3 from the series
> 
> [...]

Here is the summary with links:
  - [net-next] cxgb4: remove unused vpd_cap_addr
    https://git.kernel.org/netdev/net-next/c/4429c5fc3dbd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


