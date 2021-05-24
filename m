Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF7238F43C
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbhEXUVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233080AbhEXUVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 16:21:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 573C6613CC;
        Mon, 24 May 2021 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621887610;
        bh=aFNvwVCl18388W4vyCHy3OM3ttixeJflSKLh8hLBoEI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G5lBL8CVtvEa6lggt7H74yq0fP4BW/0M1KRin3APz6Fqhm2M/BsdewRBt+11EbqOb
         tOEm5tbsWo4xccwOKQQhkx0El/CbnJxD2iQNFu1qDTcJMwpHHIUs90WF1kqED5kREX
         bZdttC1zzf+iqyLERtMm+QhddgwUHwXlAmxmFeojAF+X13dgDR5CBw2+GdTn8kmqMw
         qSmCNv8xqHH+Uiw6VdU82/vtbKHByerJG8erJDY7Pi6zYGG8/kaPAmJU3feaHSCaGj
         PzKTO3cBBL+fYyZpnEhSkCtWwgeHCH6JcQkHZ+q7exs5N1CnJg3a78kp0IIMoGAMaB
         pAR9HV116Zc2A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5204860BCF;
        Mon, 24 May 2021 20:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: st-nci: remove unnecessary assignment and label
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162188761033.19394.13688972604989504846.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 20:20:10 +0000
References: <20210524021123.8860-1-samirweng1979@163.com>
In-Reply-To: <20210524021123.8860-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        alex.dewar90@gmail.com, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 24 May 2021 10:11:23 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> In function st_nci_hci_network_init, the variable r is assigned then
> goto exit label, which just return r, so we use return to replace it.
> and exit label only used once at here, so we remove exit label.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> 
> [...]

Here is the summary with links:
  - nfc: st-nci: remove unnecessary assignment and label
    https://git.kernel.org/netdev/net-next/c/62f148d8dde6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


