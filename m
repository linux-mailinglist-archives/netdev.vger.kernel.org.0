Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A018F47A92A
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 13:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhLTMAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 07:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhLTMAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 07:00:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA1DC061574;
        Mon, 20 Dec 2021 04:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9BDFCCE100B;
        Mon, 20 Dec 2021 12:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E94FCC36AE7;
        Mon, 20 Dec 2021 12:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640001610;
        bh=ZtcNfJ9QHze5Cs4p6EF32hecNuXUQKei2jvQ8iljUGQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M12ZLqaq2HPEIuv2yEbKeodkXCBx+aozANahhPj+0f741uE/9U7EdZGVvRHKlmbBF
         hMnj/nShNmrMJb5qddZkOFOVau8TXd5e+0Nz7QkDkaULjt60btX5m8ShmC3YXZEj6A
         2rKh97kKd4F3jythowEkasSMOFw1L3RdDS9oDshEqqzjuvlQatbV4YkvUdcyFDJOpJ
         sCK7y3e5DHYbNCbEG9TqjjtngMrJUE/J2mTizRmuldxLiQEir2fH2yHp434I4pZrNI
         Bx6iCn3Pr0B8HrMldNY+bVI7S4+4aQQVdlBWJB6PQHh4eSCJ/7aRRNm9FSaH1618Bx
         /f5N7Yglxj0kw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D234D60A6F;
        Mon, 20 Dec 2021 12:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] phonet/pep: refuse to enable an unbound pipe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164000160985.5339.1641032770799680140.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Dec 2021 12:00:09 +0000
References: <20211219170339.630659-1-remi@remlab.net>
In-Reply-To: <20211219170339.630659-1-remi@remlab.net>
To:     =?utf-8?q?R=C3=A9mi_Denis-Courmont_=3Cremi=40remlab=2Enet=3E?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 19 Dec 2021 19:03:39 +0200 you wrote:
> From: Rémi Denis-Courmont <remi@remlab.net>
> 
> This ioctl() implicitly assumed that the socket was already bound to
> a valid local socket name, i.e. Phonet object. If the socket was not
> bound, two separate problems would occur:
> 
> 1) We'd send an pipe enablement request with an invalid source object.
> 2) Later socket calls could BUG on the socket unexpectedly being
>    connected yet not bound to a valid object.
> 
> [...]

Here is the summary with links:
  - phonet/pep: refuse to enable an unbound pipe
    https://git.kernel.org/netdev/net/c/75a2f3152009

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


