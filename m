Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F5C333243
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhCJAU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 19:20:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:53462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230488AbhCJAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 19:20:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AE08E6510B;
        Wed, 10 Mar 2021 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615335609;
        bh=FHkBi/Z1ApOPtXjt1QScWU6krkKz/xizDbaxwKPWf80=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DAg+gWkQgP5jdhGVFW5Tadec0iWND9YL5H1t+b9smQbObGSRCtgdaVlvdZtMZZXyx
         FMVx6KcRrz6LqYNMK4uPvRxKxILVbvQORVAnxc87/G7PRpBMu75qvr/lwN7S6cvXd+
         DDa9IkUz5DzW7ot6VL6mVg3+4N8f7bv8VmCo9Qspztj67qyGFykQnEOtB7Q53o48y3
         DAHEvz102gBdCvaQvm631VcP1UabTWXZxT2TwnxAz6m2+shAJziTGyvXjMEUm8SGTr
         +wnNwUgY/Om2L2LE26zLvasQRQ/s5kb/xvO0pjFenUJ4yBf4Pt9QWsCmi+SsDyg4+h
         kHCBEfRLRNnzQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9FE8B60A57;
        Wed, 10 Mar 2021 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] s390/qeth: fixes 2021-03-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161533560965.32666.13038202888156607895.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 00:20:09 +0000
References: <20210309165221.1735641-1-jwi@linux.ibm.com>
In-Reply-To: <20210309165221.1735641-1-jwi@linux.ibm.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, kgraul@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue,  9 Mar 2021 17:52:17 +0100 you wrote:
> Hi Dave & Jakub,
> 
> please apply the following patch series to netdev's net tree.
> 
> This brings one fix for a memleak in an error path of the setup code.
> Also several fixes for dealing with pending TX buffers - two for old
> bugs in their completion handling, and one recent regression in a
> teardown path.
> 
> [...]

Here is the summary with links:
  - [net,1/4] s390/qeth: fix memory leak after failed TX Buffer allocation
    https://git.kernel.org/netdev/net/c/e7a36d27f6b9
  - [net,2/4] s390/qeth: improve completion of pending TX buffers
    https://git.kernel.org/netdev/net/c/c20383ad1656
  - [net,3/4] s390/qeth: schedule TX NAPI on QAOB completion
    https://git.kernel.org/netdev/net/c/3e83d467a08e
  - [net,4/4] s390/qeth: fix notification for pending buffers during teardown
    https://git.kernel.org/netdev/net/c/7eefda7f353e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


