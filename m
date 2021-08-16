Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760333ED1D5
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbhHPKVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230250AbhHPKUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5DD6661B4B;
        Mon, 16 Aug 2021 10:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629109206;
        bh=9l+us33+1+qdtF7G5WB8T/lsoUV9b3mndx3BGPA03VQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kCyZrd8welF+y4LC+ZRYwQAtV96lXuhKnHjyQBZQBOarptwk58s/wz5oBsooNzKf2
         C5f/n+wv7/voj/CCO+vj3bYUpqo/4T/bzmBxIhDaFR2ugnoWRLW5UjMdga4Db8DJVd
         PAnDoQMg1kjwWkaCl5jDVJrttbg9v+QCFSbzfrCeQFPU4kE+kCeJ3u9geKvNzdG1W6
         EhSiIhzJscwTehTpTZXQJNHg5IweIlGNlAp/IbDpEngbg1uD1kNV/MvA1nDWl7XH9X
         VSYhzv9P8TqKH8kCLH7XAaHGfcIsKD5UYYmUKvbYuiESWf3lnAmPDturdnrmXbeOX1
         SnGoGZttche+w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 53BFD600AB;
        Mon, 16 Aug 2021 10:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] s390/net: replace in_irq() with in_hardirq()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910920633.28018.8898975479771598200.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:20:06 +0000
References: <20210814010334.4075-1-changbin.du@gmail.com>
In-Reply-To: <20210814010334.4075-1-changbin.du@gmail.com>
To:     Changbin Du <changbin.du@gmail.com>
Cc:     jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 14 Aug 2021 09:03:34 +0800 you wrote:
> Replace the obsolete and ambiguos macro in_irq() with new
> macro in_hardirq().
> 
> Signed-off-by: Changbin Du <changbin.du@gmail.com>
> ---
>  drivers/s390/net/ctcm_fsms.c | 2 +-
>  drivers/s390/net/ctcm_mpc.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - s390/net: replace in_irq() with in_hardirq()
    https://git.kernel.org/netdev/net-next/c/e871ee694184

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


