Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19E73231FD
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbhBWUUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233449AbhBWUUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 15:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0985D64E6B;
        Tue, 23 Feb 2021 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614111608;
        bh=9Sz4ygIdOUTxZndCrlcDf5x+IbqGfiJ8lHhejoerSfg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sZ3lu30XLG7JeGqcHLqgNlbBL1AJoBel4ehp92JoP5eoUCMRUHqlnpGOw1Xpl0QSm
         JCt5EVRfKGd6++Y5Uisp1PgytV1myaVDzxzpqTCXerHqKdAD+cviWM/zcc6vQif1uX
         oVcLDHk5Myg4tb5Cj0kJ0Tto1EsobKk/pM1EM5LTEkiqoubOxBS1D6Mb84BL4O9GnD
         iEeBAlfmS9JhY9Sizxt4cgo0k8iErPzWSvxve9jjA6DsBnSpgjCwiEOE39UDISIFpe
         qMhvxGwA5TVa5x9FRNzpnTrsyZSorGXcqOeqqNfsd83K/43KF8NPZwQnmkgnOMCmq8
         0VwLy6e0CWQvw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F00676096F;
        Tue, 23 Feb 2021 20:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Marvell Sky2 Ethernet adapter: fix warning messages.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161411160797.22647.8491268209828443024.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Feb 2021 20:20:07 +0000
References: <m3a6s1r1ul.fsf@t19.piap.pl>
In-Reply-To: <m3a6s1r1ul.fsf@t19.piap.pl>
To:     Krzysztof Halasa <khalasa@piap.pl>
Cc:     mlindner@marvell.com, stephen@networkplumber.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 18 Feb 2021 13:34:42 +0100 you wrote:
> sky2.c driver uses netdev_warn() before the net device is initialized.
> Fix it by using dev_warn() instead.
> 
> Signed-off-by: Krzysztof Halasa <khalasa@piap.pl>

Here is the summary with links:
  - Marvell Sky2 Ethernet adapter: fix warning messages.
    https://git.kernel.org/netdev/net/c/18755e270666

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


