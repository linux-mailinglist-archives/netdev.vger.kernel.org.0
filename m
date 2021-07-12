Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F103C62A0
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 20:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbhGLScx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 14:32:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230477AbhGLScw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 14:32:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9FA5F61186;
        Mon, 12 Jul 2021 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626114603;
        bh=53oJ2AU+FZK9jxaEkJqYWcoLJ24v7HhvSVfykiOy/WU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HgAIqQK5HpNgUX+zGdangvHWamccRH9KMGJnNwuQ8EEeTjnaqzyypXNOJ07xGm+As
         m1s8cyoWCsXn1yALlZN+eDo15rgeQstzpyeMR0NT/Gis/Pc8GSE7s515YMMaZSbHDf
         IQC75x7O9bMF3V6Bj5JbypOASJGurerrMt8wlCFDi+XDzvWL/FIxj/pprEJ3X7tacB
         N0s9JgDnCu0ZkQKBnfj7k5Yj+RDsNHauqEorPn5dFM9XXWEiCbdz8xQhN6haKvFG6P
         Rut7dgysuRsHQzV8LcQv6KsNiS7QF7qKeadmMJb0tjOJVLD2RUSue20Rzto/4DaePc
         1zKs0obc4IBWA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 932A060A54;
        Mon, 12 Jul 2021 18:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-pf: Fix uninitialized boolean variable pps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162611460359.21721.179484108889864194.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Jul 2021 18:30:03 +0000
References: <20210712143750.100890-1-colin.king@canonical.com>
In-Reply-To: <20210712143750.100890-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 12 Jul 2021 15:37:50 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> In the case where act->id is FLOW_ACTION_POLICE and also
> act->police.rate_bytes_ps > 0 or act->police.rate_pkt_ps is not > 0
> the boolean variable pps contains an uninitialized value when
> function otx2_tc_act_set_police is called. Fix this by initializing
> pps to false.
> 
> [...]

Here is the summary with links:
  - octeontx2-pf: Fix uninitialized boolean variable pps
    https://git.kernel.org/netdev/net/c/71ce9d92fc70

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


