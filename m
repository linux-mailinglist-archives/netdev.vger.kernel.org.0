Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB6A44F129
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 05:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbhKMEXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 23:23:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235645AbhKMEXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 23:23:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CD13A61156;
        Sat, 13 Nov 2021 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636777209;
        bh=Vn/y4HuxFNGZs8+Sz1Od1OysTfu2eC5W5z1AsF3vlkk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QK86idkK8cF231GyLc7hmXZLTabCLJDRJdXZh9t0HK7AKra5vNAQzzpzQ3SjQBIBQ
         wa3H5cBkH6SNhFvQ3Ygqb0rK+prvexLwaGRvxn657Jh1ojb3XmT7WsI765Kt1ZdvPZ
         MQwfpkiZ/BM1vdCvxZJ4EhRSX6NGVZ6Vudji9qcUUgNuY2+xCxSCNRwRuTwMbICsnK
         UeSouU5ENpmzKuwCwLFCqUlRRWYRUyBRlrsRL2B9Tb9+SkeMcAcnlBqZS3hMVn7nGH
         eXCarhJNG4WLia4Ugj72jTuAhfkv6gwy297+jYUvTUrYpKo0l3CrWDmPKj80ml3wYs
         quFyLpkXjwhLw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B837660987;
        Sat, 13 Nov 2021 04:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/ipa: ipa_resource: Fix wrong for loop range
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163677720974.27008.15285644696445470681.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Nov 2021 04:20:09 +0000
References: <20211111183724.593478-1-konrad.dybcio@somainline.org>
In-Reply-To: <20211111183724.593478-1-konrad.dybcio@somainline.org>
To:     Konrad Dybcio <konrad.dybcio@somainline.org>
Cc:     ~postmarketos/upstreaming@lists.sr.ht, martin.botka@somainline.org,
        angelogioacchino.delregno@somainline.org,
        marijn.suijten@somainline.org, jamipkettunen@somainline.org,
        elder@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 11 Nov 2021 19:37:24 +0100 you wrote:
> The source group count was mistakenly assigned to both dst and src loops.
> Fix it to make IPA probe and work again.
> 
> Fixes: 4fd704b3608a ("net: ipa: record number of groups in data")
> Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
> Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
> Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
> 
> [...]

Here is the summary with links:
  - [v2] net/ipa: ipa_resource: Fix wrong for loop range
    https://git.kernel.org/netdev/net/c/27df68d579c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


