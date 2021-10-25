Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2515F4396E8
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbhJYNCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233387AbhJYNCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 09:02:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 70AD961039;
        Mon, 25 Oct 2021 13:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635166808;
        bh=v77wx+z38xJQ+aMTUWSVLHBZ9+jgDqJ1AGLDZUIN2I4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XnRcQ88ISKT/uVQITv5MIIquA0TD6kMzrL/HAKrl61zkcxLo8uwIem/drpG2nDMwN
         TF9UPozpQ14x9FAQ5AmjjshfrnmaHTeIaSSIV17Mkz80F/gY5GEk1mBkHyEssokwuJ
         WtDSLU4zm0QVKKmtUN3Ijbarr1nbJhAdqwW/A7eRcq9Yt4w3V9CJ6zZIpHYcPenI5H
         YyHFTm5+fuvnc7C3ECem2vE1t8bMWJQfIeFXLHDeV8qSaKvl0VMh8X7EbKW/4omvUg
         Y2HHA1otTW9AT0W2E9+s335SW3mcEniMKcKkLiZAxduW5N1ZM3QEICzPVtNHL2zBl7
         rTVyHI2lDo0dw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 658F860A21;
        Mon, 25 Oct 2021 13:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] s390/qeth: updates 2021-10-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163516680841.24806.1994768160149085786.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 13:00:08 +0000
References: <20211025095658.3527635-1-jwi@linux.ibm.com>
In-Reply-To: <20211025095658.3527635-1-jwi@linux.ibm.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, kgraul@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Oct 2021 11:56:49 +0200 you wrote:
> Hi Dave & Jakub,
> 
> please apply the following patch series for qeth to netdev's net-next tree.
> 
> This brings some minor maintenance improvements, and a bunch of cleanups
> so that the W=1 build passes without warning.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] s390/qeth: improve trace entries for MAC address (un)registration
    https://git.kernel.org/netdev/net-next/c/0969becb5f76
  - [net-next,2/9] s390/qeth: remove .do_ioctl() callback from driver discipline
    https://git.kernel.org/netdev/net-next/c/2decb0b7ba2d
  - [net-next,3/9] s390/qeth: move qdio's QAOB cache into qeth
    https://git.kernel.org/netdev/net-next/c/a18c28f0aeeb
  - [net-next,4/9] s390/qeth: clarify remaining dev_kfree_skb_any() users
    https://git.kernel.org/netdev/net-next/c/fdd3c5f076b6
  - [net-next,5/9] s390/qeth: don't keep track of Input Queue count
    https://git.kernel.org/netdev/net-next/c/dc15012bb083
  - [net-next,6/9] s390/qeth: fix various format strings
    https://git.kernel.org/netdev/net-next/c/22e2b5cdb0b9
  - [net-next,7/9] s390/qeth: add __printf format attribute to qeth_dbf_longtext
    https://git.kernel.org/netdev/net-next/c/79140e22d245
  - [net-next,8/9] s390/qeth: fix kernel doc comments
    https://git.kernel.org/netdev/net-next/c/7ffaef824c9a
  - [net-next,9/9] s390/qeth: update kerneldoc for qeth_add_hw_header()
    https://git.kernel.org/netdev/net-next/c/56c5af2566a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


