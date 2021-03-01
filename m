Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA8E3293C6
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 22:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbhCAVfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 16:35:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244067AbhCAVat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 16:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EA78E6023C;
        Mon,  1 Mar 2021 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614634208;
        bh=Jf2fL0eOIGshC3Tdb2nzd25RldbSAEtF7kGkDss+Za4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aW+kO478jDf60VWt+r0rSxWRsN/wMvU755F4+1hPpmy6jzLOFJ7IKlumzYYRryA+O
         O35wiAFWIuQwj3ilXepxCNlmbAPBHjRvP+58HuUQ25iWkZNdxkSXUVbeAKXoVwU1S1
         SuLKuIy8tgPtLn8+x2fPTeUIsqISFCETLTwVa4ymimyPnl1AYDq6hfW6FV6h63Jpj/
         Toiut45goiKgCsx4bDRPm4ZRwvg9XZzg9uxbkhzVZXQZdNCehUXU39AcfIdcGgvqeY
         I4W4Q9uNnbna3BnuPTmkxzidG0x31Kh/n6TJP7u/EHxbgrxew/LRpkOsEK8ba7qiBu
         LxCCvheyqkcpQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DACD760C25;
        Mon,  1 Mar 2021 21:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atm: lanai: dont run lanai_dev_close if not open
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161463420789.14233.14258851142782431296.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Mar 2021 21:30:07 +0000
References: <20210228035550.87183-1-ztong0001@gmail.com>
In-Reply-To: <20210228035550.87183-1-ztong0001@gmail.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 27 Feb 2021 22:55:50 -0500 you wrote:
> lanai_dev_open() can fail. When it fail, lanai->base is unmapped and the
> pci device is disabled. The caller, lanai_init_one(), then tries to run
> atm_dev_deregister(). This will subsequently call lanai_dev_close() and
> use the already released MMIO area.
> 
> To fix this issue, set the lanai->base to NULL if open fail,
> and test the flag in lanai_dev_close().
> 
> [...]

Here is the summary with links:
  - atm: lanai: dont run lanai_dev_close if not open
    https://git.kernel.org/netdev/net/c/a2bd45834e83

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


