Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724523F01A4
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 12:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhHRKaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 06:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233733AbhHRKal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 06:30:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6496C61075;
        Wed, 18 Aug 2021 10:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629282606;
        bh=lxftvSiHarDvGFgrurFXOGCqUJKVvjKa0EG9LU0ZPk4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NZOLoCH+8Ydz9UBDqxWVZJd0kDdEDWM0DGzQg1+7gWFZjSlgyQCVRmVczNGTU6cJo
         2dwcRvwXthY6M5cZBC0OdxyWONrCydTkDAsAVwu2bAraEBwwditgjA/Z/oQ7zQjS0d
         sSBjDe99plcVcQpHfAY6ndhWsBviLpxLdfkWwP+Sw4CHqLeHWICSIOI5wl+UxctY0I
         XrPSOXGyRjvAti3eHxdYuqGuwXs8qSAT9KCZSKZ883/cwgdgr3KcuTgim75ea4fBjq
         iUIVC0SaVLODygqQRVsN2/ZsGKJ4TK3CG7IEEpVFIhDa8jwDiJDYV6tgqW/GR32cxz
         r83kd+TmCGp1Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 58CBA60A48;
        Wed, 18 Aug 2021 10:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: vrf: Add test for SNAT over VRF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162928260635.10083.15769834881216686431.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 10:30:06 +0000
References: <20210818085212.2810249-1-lschlesinger@drivenets.com>
In-Reply-To: <20210818085212.2810249-1-lschlesinger@drivenets.com>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, kuba@kernel.org,
        shuah@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 18 Aug 2021 08:52:12 +0000 you wrote:
> Commit 09e856d54bda ("vrf: Reset skb conntrack connection on VRF rcv")
> fixes the "reverse-DNAT" of an SNAT-ed packet over a VRF.
> 
> This patch adds a test for this scenario.
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> 
> [...]

Here is the summary with links:
  - selftests: vrf: Add test for SNAT over VRF
    https://git.kernel.org/netdev/net-next/c/d3cec5ca2996

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


