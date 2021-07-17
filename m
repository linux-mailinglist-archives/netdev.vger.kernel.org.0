Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D0D3CC01A
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 02:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhGQAdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 20:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhGQAdA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 20:33:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A32A1613D3;
        Sat, 17 Jul 2021 00:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626481804;
        bh=iEl1F49DkJamZWF2l2lBRCrT87c4u8/I4sAKzn1uYLs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HbjikwL/FlekWo98zgTsS4S5LhojLEWQFFh3Vr/+JvGfFQGw+5a/k+y4X5BSi1PMa
         4sLvORRUhSImweMNgz03vfeOvKBYLfTrB/JZJvJ9LqJUYjZe/8ITAjNFomLPpi4aYm
         6/C5J8tk+27po854+TWjpk5xX8Ggy5YxNQcrP/vmBm5sY/6CQceUlUQbb5Ts4uVuiD
         DBwy6026yura7nnt6WP+hmVpWuaeeBXWdgbr+DfgmSIsSwLA49P/vhyBolU8FVjFwg
         BQQZhOwTc/kfCkW961X1aesNvaoSt8n5Zw3HujVOVG8DTge/7Xr/K2xGFPNmbdgzxr
         I9p7P0Z8mPOAQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 94F466097A;
        Sat, 17 Jul 2021 00:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH next] bonding: fix build issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162648180460.17758.2471470773813764931.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Jul 2021 00:30:04 +0000
References: <20210716230941.2502248-1-maheshb@google.com>
In-Reply-To: <20210716230941.2502248-1-maheshb@google.com>
To:     Mahesh Bandewar <maheshb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mahesh@bandewar.net, ap420073@gmail.com, jay.vosburgh@canonical.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 16 Jul 2021 16:09:41 -0700 you wrote:
> The commit 9a5605505d9c (" bonding: Add struct bond_ipesc to manage SA") is causing
> following build error when XFRM is not selected in kernel config.
> 
> lld: error: undefined symbol: xfrm_dev_state_flush
> >>> referenced by bond_main.c:3453 (drivers/net/bonding/bond_main.c:3453)
> >>>               net/bonding/bond_main.o:(bond_netdev_event) in archive drivers/built-in.a
> 
> [...]

Here is the summary with links:
  - [next] bonding: fix build issue
    https://git.kernel.org/netdev/net/c/5b69874f74cc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


