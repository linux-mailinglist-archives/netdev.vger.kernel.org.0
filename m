Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0243D3C34
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbhGWO3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 10:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235440AbhGWO3a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 10:29:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 44B7360EE6;
        Fri, 23 Jul 2021 15:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627053004;
        bh=+BuVkm4Mb0xqYgKKqyxB64Tn49Ag0daABq8sXs8yp+U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m7x2elUhLdoFKdGjD9E1xIQT8Ttkedwsevsw3mnQ5KNUwnifM5cW9yrFVgU3PgaTt
         jixIlxT9TPwo3HXYiJgIIylMHIJm0EL6GnHFHAP0Cz++Sl6wucPQFnKcubCX1uHyEg
         d3I4if311Ype7fjWx//rRemOHBe27DzlRTfotEkF2WxukcgEdc9U5RvS4dMBWggRJU
         f1hImGjWSLTPAZr5QWKdFfX0c7GLxbvl7UzJsK731FtsNqQqijpiEY+2C9ag03+jX5
         9LyocDCT2GIviXgNHQfrh8TtCkAVSwwwpbk6yk1BGVSLojAzGp3ZtXHmwqGugSLLj1
         eAfqnFAIxKwJg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D15960972;
        Fri, 23 Jul 2021 15:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] octeontx2-af: Remove unnecessary devm_kfree
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705300424.2253.2837054968988067248.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 15:10:04 +0000
References: <1626957951-31153-1-git-send-email-sgoutham@marvell.com>
In-Reply-To: <1626957951-31153-1-git-send-email-sgoutham@marvell.com>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 22 Jul 2021 18:15:51 +0530 you wrote:
> Remove devm_kfree of memory where VLAN entry to RVU PF mapping
> info is saved. This will be freed anyway at driver exit.
> Having this could result in warning from devm_kfree() if
> the memory is not allocated due to errors in rvu_nix_block_init()
> before nix_setup_txvlan().
> 
> Fixes: 9a946def264d ("octeontx2-af: Modify nix_vtag_cfg mailbox to support TX VTAG entries")
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-af: Remove unnecessary devm_kfree
    https://git.kernel.org/netdev/net/c/d72e91efcae1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


