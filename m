Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEA23FAA86
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 11:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbhH2JvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 05:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234986AbhH2Ju6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Aug 2021 05:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 126FF60F44;
        Sun, 29 Aug 2021 09:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630230607;
        bh=L5jlBM/eAfo398lgXJKdxfNmF8KMoJi0D1EZ5q4A1EY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RsUlDvUzqJc0L2XimbqkKM53GKyFSObXxOpHrwn3MKbWqlDkAQceDwNNqObsaNwl3
         qhSp1QsD9VEOv8knkfbAywTM3Yf6JkGRfTGuME+BAOnr5zPZtrVww4u20ACTEC6F/x
         BN0oHmVK/O2mZH4D96qpxdWa04zUlvbf3eKlQQboTJkRNH31PM7DDMo9EF+E5ptnkk
         NTh8xRH8Y5ylAfWlV2uhVaME23qNpN5fasWdDNQEsuj9QSCSVFzyu8mBiAQEFE1K5I
         AnvC1EewgOWhcY8aQfwI7pxEaykE30IF7A7+2KsKDKkluA3XNmM3E6miyz5rbwKEGQ
         QslKg6drS7now==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 08B7D60A5B;
        Sun, 29 Aug 2021 09:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-pf: Fix inconsistent license text
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163023060703.19070.3147390575098284218.git-patchwork-notify@kernel.org>
Date:   Sun, 29 Aug 2021 09:50:07 +0000
References: <1630064707-24192-1-git-send-email-sgoutham@marvell.com>
In-Reply-To: <1630064707-24192-1-git-send-email-sgoutham@marvell.com>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 27 Aug 2021 17:15:07 +0530 you wrote:
> Fixed inconsistent license text across the netdev
> drivers.
> 
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/Kconfig             | 2 +-
>  drivers/net/ethernet/marvell/octeontx2/nic/Makefile        | 2 +-
>  drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c         | 5 +++--
>  drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h         | 7 ++++---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c   | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h   | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c | 3 ++-
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c    | 3 ++-
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c       | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c      | 5 +++--
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h      | 6 +++++-
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h      | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h   | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c       | 4 +++-
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c     | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h     | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c       | 6 +++++-
>  18 files changed, 45 insertions(+), 54 deletions(-)

Here is the summary with links:
  - octeontx2-pf: Fix inconsistent license text
    https://git.kernel.org/netdev/net-next/c/cb0e3ec4e679

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


