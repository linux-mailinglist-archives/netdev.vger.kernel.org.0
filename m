Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CBF354895
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 00:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242700AbhDEWUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 18:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241409AbhDEWUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 18:20:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2A434613DC;
        Mon,  5 Apr 2021 22:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617661209;
        bh=yuAFba5TV3uaje2qLcuVIpi2uQUMF5gRLJQaTXszNs4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ODt2h6yMTEpxxCPKN+CJItkigImQr+CBT0PE7qrYoVoZZ/cU2v4hJxRIM7HiG5JkE
         o1f3UNB6htUl6NkQAkSYL+PDPI3kh1xqG3L7ASQyDQgehZfwCUIJb7Qef2XK82Prbc
         JSZpyse+xMnvZEoaNm9+O1ZtwZ4dTfSi3q2SK5UPgSadS8qpumivZbVVGwyVRk3tAB
         kmwuaTU2UYaaouhV7iXX8GZB7cuAsTPKO3UkbZ3OxaRibfYQWnKjm4dY8to2NuA6l+
         67JtRyTiC4UBYnqkMb5atT3/nDNaVks3z44G3T0vYnW6jjPqJ9OLutgBe8ocbVvRrI
         Z/QYBEVFYvkfg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 19F2060A00;
        Mon,  5 Apr 2021 22:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] batman-adv: initialize "struct
 batadv_tvlv_tt_vlan_data"->reserved field
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161766120910.29259.17290126153206373220.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 22:20:09 +0000
References: <20210405101650.6779-1-penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20210405101650.6779-1-penguin-kernel@I-love.SAKURA.ne.jp>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  5 Apr 2021 19:16:50 +0900 you wrote:
> KMSAN found uninitialized value at batadv_tt_prepare_tvlv_local_data()
> [1], for commit ced72933a5e8ab52 ("batman-adv: use CRC32C instead of CRC16
> in TT code") inserted 'reserved' field into "struct batadv_tvlv_tt_data"
> and commit 7ea7b4a142758dea ("batman-adv: make the TT CRC logic VLAN
> specific") moved that field to "struct batadv_tvlv_tt_vlan_data" but left
> that field uninitialized.
> 
> [...]

Here is the summary with links:
  - [v2] batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field
    https://git.kernel.org/netdev/net/c/08c27f3322fe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


