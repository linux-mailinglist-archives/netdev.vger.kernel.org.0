Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0A741C1BA
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245104AbhI2Jlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232200AbhI2Jlt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 05:41:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 84E67613D0;
        Wed, 29 Sep 2021 09:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632908408;
        bh=kyJlWL5X1fH3MaHvtfUsNXu+naVKTDOwDKgpXhw1PU8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xdar4UtPau5uKUEprhrBO0e1fmWWiQdRg6r4nLxN3MwRs6wvoczpEnIh5V3FIcaqV
         fPu7z7aB6bolk1lhyLQD4xd/WMOic7VevDsYZxKGeVOP/thS9znAODqMyeWYy0NpTE
         w5i3FC5OR8/lYce19mtJmkkrbK060FhPoVizVNfrLEZMitOzebhluS+2NxcnJnZKCy
         btpQBoOGU1T0/sx5gFmeZsGUYGM1sr0hnsV6+AweL+FGVDvPgv56hgmuKuywK2aQQj
         dzix+agUUH4ModWYY+Y98JopjsxHHGQF9ebQidZ0YM96hyhmojuIcbnFnU0P4hLHgW
         YA8wyq+4ru6xA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7460260A59;
        Wed, 29 Sep 2021 09:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH 0/2] Add PTP support for VFs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163290840847.357.9087499209887090868.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Sep 2021 09:40:08 +0000
References: <1632851026-5415-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1632851026-5415-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com, hkelam@marvell.com, gakula@marvell.com,
        naveenm@marvell.com, rsaladi2@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 28 Sep 2021 23:13:44 +0530 you wrote:
> PTP is a shared hardware block which can prepend
> RX timestamps to packets before directing packets to
> PFs or VFs and can notify the TX timestamps to PFs or VFs
> via TX completion queue descriptors. Hence adding PTP
> support for VFs is exactly similar to PFs with minimal changes.
> This patchset adds that PTP support for VFs.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] octeontx2-pf: Enable promisc/allmulti match MCAM entries.
    https://git.kernel.org/netdev/net-next/c/ffd2f89ad05c
  - [net-next,2/2] octeontx2-nicvf: Add PTP hardware clock support to NIX VF
    https://git.kernel.org/netdev/net-next/c/43510ef4ddad

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


