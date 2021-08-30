Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE123FB497
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 13:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236534AbhH3LbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 07:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232579AbhH3LbA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 07:31:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DC03A61102;
        Mon, 30 Aug 2021 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630323006;
        bh=wl+y0gApL/7DsqhiqI+OAnZSafpvnEsEVmkzzu8zcB0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nLsVtOPhBewvRS0d8X1RAVQh8ftqR9orWhe7+s8RLo45aDM02qR5uFH+yHwJRhVKw
         tlok7R8+bBVfH7MVxStgzI4GBDmUAE1hETVysK4vx7pzPfcrgARaeKyFH92ttb9xTt
         K2WsnHRvrQwfIvW//mzVi7Es8VIJtx5+yKLyM2umRUdrN3jJH0YFzfnMafGEGOSQf9
         qtjzZSjsKWLPoxGNwMBpFWgnu5MUBD6cBCZaX/1sWGBsEroSmS//ZD9QmrirHepxFO
         +wYvh4sotgabbA8BkL7wOWCkfyudgWQ4zgn0Qfuz4jfa5mRSy/gfA1/QfKw578cy8u
         3v1ePRfuC1jIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D0DF660A3C;
        Mon, 30 Aug 2021 11:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: fix NULL pointer reference in cipso_v4_doi_free
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163032300685.3135.10239100390398519858.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Aug 2021 11:30:06 +0000
References: <18f0171e-0cc8-6ae6-d04a-a69a2a3c1a39@linux.alibaba.com>
In-Reply-To: <18f0171e-0cc8-6ae6-d04a-a69a2a3c1a39@linux.alibaba.com>
To:     =?utf-8?b?546L6LSHIDx5dW4ud2FuZ0BsaW51eC5hbGliYWJhLmNvbT4=?=@ci.codeaurora.org
Cc:     paul@paul-moore.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 30 Aug 2021 18:28:01 +0800 you wrote:
> In netlbl_cipsov4_add_std() when 'doi_def->map.std' alloc
> failed, we sometime observe panic:
> 
>   BUG: kernel NULL pointer dereference, address:
>   ...
>   RIP: 0010:cipso_v4_doi_free+0x3a/0x80
>   ...
>   Call Trace:
>    netlbl_cipsov4_add_std+0xf4/0x8c0
>    netlbl_cipsov4_add+0x13f/0x1b0
>    genl_family_rcv_msg_doit.isra.15+0x132/0x170
>    genl_rcv_msg+0x125/0x240
> 
> [...]

Here is the summary with links:
  - [v2] net: fix NULL pointer reference in cipso_v4_doi_free
    https://git.kernel.org/netdev/net-next/c/e842cb60e8ac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


