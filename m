Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB24436CEAF
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 00:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbhD0Wk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 18:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238548AbhD0Wky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 18:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 845AE61404;
        Tue, 27 Apr 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619563210;
        bh=6uvEgWmSuI3CiTQgqx2XsEl8TVLiLcygDlDXC0plN6Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PZAVerXYjeUe4GYtFKYrqTushQZzvbwbf19uumPcw5QlmAkpWuqAzN/q0f2/qNxpG
         +DnJzB6QwAiuuA+KaRw+yQ5O4fFb8XEWCdlY/9d7WstpaBNnxxYXuoJtc/NSBgvgE+
         3/jB+MyRdOboPzx6glJ6Ip3Qb/UHSisuZ4OUwfcORLLq++wTMMiXU/aL3N6AmPjo0g
         mOBwkWAiLSxWPuh9Fsbvoj9iaC5TeVjMxBoPOHFhnev/7jJyBgbEuV6E1FMfyEfE3Q
         P8Zvgm99miL7QeBLdCAamZbG/Bp0mWD5PC2wp0v2nfd0ombel/YcI5Of7VME+0cpXH
         81TtKqdsx3MOA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7967F60A24;
        Tue, 27 Apr 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net:nfc:digital: Fix a double free in digital_tg_recv_dep_req
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161956321049.28898.4886085211372158981.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Apr 2021 22:40:10 +0000
References: <20210427162258.7238-1-lyl2019@mail.ustc.edu.cn>
In-Reply-To: <20210427162258.7238-1-lyl2019@mail.ustc.edu.cn>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Apr 2021 09:22:58 -0700 you wrote:
> In digital_tg_recv_dep_req, it calls nfc_tm_data_received(..,resp).
> If nfc_tm_data_received() failed, the callee will free the resp via
> kfree_skb() and return error. But in the exit branch, the resp
> will be freed again.
> 
> My patch sets resp to NULL if nfc_tm_data_received() failed, to
> avoid the double free.
> 
> [...]

Here is the summary with links:
  - net:nfc:digital: Fix a double free in digital_tg_recv_dep_req
    https://git.kernel.org/netdev/net-next/c/75258586793e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


