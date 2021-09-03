Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E563C3FFEB8
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 13:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349082AbhICLLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 07:11:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348680AbhICLLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 07:11:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C1635610E8;
        Fri,  3 Sep 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630667406;
        bh=h4H94yW0VSymggzI9FEGPvnbJ659Wl3ttWLZkKY42j0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QMQe27wG8yCS3apy4TcXW4aVJLBWGjFDPA+CanrOPTsROyQp31mnJcodIc3heQIHG
         +gwjMxTe/j3cDcGOmSs7umkACrUe0yy2udzoK2qLONJUf3ZoVArq6NjZ2I7nHBxZpu
         WBDftI0j61MHaVfgvzgpa/Pdw1cyUyk0ipyibpchwA24uZ1JEPDkN9/iyA5asDGmMs
         um9+Im7TiDzVqcjTSA6u2Kcbu8MGV6bAUUxWzirON2X0ZIbAiFCuCAjv4tDNvObaqi
         xLKeUJ2NsYRrqF/03WJ1GK8hIN6jR7lWX+JvT5+9rlSUHbBpO+CDcm+Ddtmc3KcUrT
         8ul3CH2RuRKDA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BA63160A4E;
        Fri,  3 Sep 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tipc: clean up inconsistent indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163066740675.18620.6699167919203164424.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Sep 2021 11:10:06 +0000
References: <20210902230011.58478-1-colin.king@canonical.com>
In-Reply-To: <20210902230011.58478-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  3 Sep 2021 00:00:11 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a statement that is indented one character too deeply,
> clean this up.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - tipc: clean up inconsistent indenting
    https://git.kernel.org/netdev/net/c/743902c54461

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


