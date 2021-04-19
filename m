Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6936364EA2
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 01:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbhDSXav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 19:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232023AbhDSXaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 19:30:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 83E0761279;
        Mon, 19 Apr 2021 23:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618875009;
        bh=87iChWTrhjEZRORazh3691x/H+GI3TZs65yu4iLUMNQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=APzvFTUMXtsWdBtpvgfDip4UxUpgOjGCRLBPu/UOVUI57AogiDTHM1G4F5EBXcyZY
         sWog7lsPjHtFaY/Z6O5oGvf1NR+Vh+dcFX/KGdo6/gzBrQd5Yg/HdXk/CSseg0MZNM
         NG5XIo6RBmMZVDhMLor1wMXPcwDOMseTXpfF14zao6i5nPcchALMticKgq+fq/kpkj
         Cw4mvB1yrMkbSub9wr4Gu4MRl6UDFDKCxmdOn0NJT6NeHwME/xxcEY89v1s/xqiM74
         lJsiL3Lh+ham7qCs30agsedpNpVh8uEB2lUSHZwoz45RdQUHNZ3Bl22MNO9sBut2o3
         rrXZqWgQvCQmQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 75C2A60A0B;
        Mon, 19 Apr 2021 23:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethtool: stats: clarify the initialization to
 ETHTOOL_STAT_NOT_SET
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887500947.9960.5933039490034505266.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 23:30:09 +0000
References: <20210419200345.2984715-1-kuba@kernel.org>
In-Reply-To: <20210419200345.2984715-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, idosch@idosch.org,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Apr 2021 13:03:45 -0700 you wrote:
> Ido suggests we add a comment about the init of stats to -1.
> This is unlikely to be clear to first time readers.
> 
> Suggested-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ethtool/stats.c | 3 +++
>  1 file changed, 3 insertions(+)

Here is the summary with links:
  - [net-next] ethtool: stats: clarify the initialization to ETHTOOL_STAT_NOT_SET
    https://git.kernel.org/netdev/net-next/c/d1f0a5e1fb4e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


