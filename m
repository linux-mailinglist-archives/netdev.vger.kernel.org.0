Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05240306A11
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhA1BNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:13:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231992AbhA1BLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 20:11:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DC5AD64DDB;
        Thu, 28 Jan 2021 01:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611796211;
        bh=/3xaSwGpm1FAL76TxLu6be7YbqcUAh3ACgI4LcTBWus=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R0YKMkZ6MvYr8K77xkAfWL+bCD09tv5E/ZxS4nzEr8ycwnRyZXICkeT7CfBbacBGM
         Fyo+OzkfVqEMQur9VyAhpJhgZHvfZWx7EnGUNfH8BulzZBOaSoIl/DqYX2hsf0Rnbg
         L7SJWBJCg91Ktlaf2FRP/9M3xzS0F8qurbbR5I97zHT2SrR2w+0Huu38bIBIqfYKIF
         8/KpEw1ihUhzMaGNUEiqBKTsu+bpQUh2mSFHT8NsaXzdlytu14NaxL4mCi7sa+FDEy
         BYSL9pUxMXxoh7uZ+BDO9drmwHZzCTp9Xx4a83nKtdarh24XBsGZriZBH+V0Iey46Y
         GCBhrpFvpLT3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C4A08613AE;
        Thu, 28 Jan 2021 01:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/4] net: move CONFIG_NET guard to top Makefile
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179621179.21299.723410725498445981.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 01:10:11 +0000
References: <20210125231659.106201-1-masahiroy@kernel.org>
In-Reply-To: <20210125231659.106201-1-masahiroy@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, kafai@fb.com,
        michal.lkml@markovi.net, songliubraving@fb.com, yhs@fb.com,
        bpf@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 26 Jan 2021 08:16:55 +0900 you wrote:
> When CONFIG_NET is disabled, nothing under the net/ directory is
> compiled. Move the CONFIG_NET guard to the top Makefile so the net/
> directory is entirely skipped.
> 
> When Kbuild visits net/Makefile, CONFIG_NET is obvioulsy 'y' because
> CONFIG_NET is a bool option. Clean up net/Makefile.
> 
> [...]

Here is the summary with links:
  - [1/4] net: move CONFIG_NET guard to top Makefile
    https://git.kernel.org/netdev/net-next/c/8b5f4eb3ab70
  - [2/4] net: dcb: use obj-$(CONFIG_DCB) form in net/Makefile
    https://git.kernel.org/netdev/net-next/c/1e328ed55920
  - [3/4] net: switchdev: use obj-$(CONFIG_NET_SWITCHDEV) form in net/Makefile
    https://git.kernel.org/netdev/net-next/c/0cfd99b487f1
  - [4/4] net: l3mdev: use obj-$(CONFIG_NET_L3_MASTER_DEV) form in net/Makefile
    https://git.kernel.org/netdev/net-next/c/d32f834cd687

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


