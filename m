Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF5541AF10
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240773AbhI1Mb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240578AbhI1Mbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:31:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4D7C161206;
        Tue, 28 Sep 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632832208;
        bh=vdXv1ySw6oUT3jzzeZJH7qKce1YeXHTmAfv5vV4L5hk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BSg+0Ty2K5PYxCk5b7xD/f4Yp3NrXmZ4+R3fQ/fHsj40FAh3/zDCH/OJyMtkbS1a0
         7lpp6yncMwZEBAa1Kze+B6AHk5kNb6xbCcp+pqPtvkKOu/Szv4sh7dm6Qd7O2JaK/q
         +tiSU1NI+v+K6UB6NWY3oTry0PCjslPtrAZkqQrgQ+lMDUXE1tvKux/oUJywtBCo1D
         qFwPKFoyWr/Mtx16W4dSUL5FEpCwVWVerXsACB+TxlWfZOvwvDoH23KtzdeLp3Rq9d
         qHpEmkRXGua5p5M5glhJm0K38vH9H3naamX3WJpgaYvXvrn4/WlWx++bNQdP+HHowj
         JT/QboSo8XUIg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 429A760A69;
        Tue, 28 Sep 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ionic: fix gathering of debug stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283220826.6805.17022450640380082180.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 12:30:08 +0000
References: <20210927210718.56769-1-snelson@pensando.io>
In-Reply-To: <20210927210718.56769-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, jtoppins@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 27 Sep 2021 14:07:18 -0700 you wrote:
> Don't print stats for which we haven't reserved space as it can
> cause nasty memory bashing and related bad behaviors.
> 
> Fixes: aa620993b1e5 ("ionic: pull per-q stats work out of queue loops")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_stats.c | 9 ---------
>  1 file changed, 9 deletions(-)

Here is the summary with links:
  - [net] ionic: fix gathering of debug stats
    https://git.kernel.org/netdev/net/c/c23bb54f28d6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


