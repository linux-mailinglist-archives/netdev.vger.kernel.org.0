Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2AD3A7104
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 23:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhFNVMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 17:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229771AbhFNVMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 17:12:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 35ADB61378;
        Mon, 14 Jun 2021 21:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623705003;
        bh=Mpbxx++TkhiINmd3NAD9NYSXRgXHCONL+qDxcxqnFQI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dha7yIWdcFZe0N9HbGS/j/uRP3br5ekiGAjuOrpNrmWS6q34bixVFWe4K9SE3d2QP
         UEH47Qb6hs7rOVYBbRKj3vI2c+u00vhUPtlaLyYRZH0R02WCd4mqDmChCl25PN+33r
         14N7Z+Wy1qKMTJTb85WSmXZ85aLf4vaRLVTReDIN2FUMw2OOJnAtIrRuX7VzTXGWpx
         GLlsQwU8rCUpezNAUqffdCAiS1nCyBSy2E9mzpE7uilcShyJwRBgZGYwu0GReJVd6L
         72RZKvHJ81wk1gGVrw1B8bMThwsXSwxc6bqInLNUYPin3E5HkvSsC2a9Xc9nkmuhaX
         6oCbARJ4dyudg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2972C609E7;
        Mon, 14 Jun 2021 21:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2021-06-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370500316.16866.4127985181873331369.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 21:10:03 +0000
References: <20210614204311.1284512-1-luiz.dentz@gmail.com>
In-Reply-To: <20210614204311.1284512-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Mon, 14 Jun 2021 13:43:11 -0700 you wrote:
> The following changes since commit ad9d24c9429e2159d1e279dc3a83191ccb4daf1d:
> 
>   net: qrtr: fix OOB Read in qrtr_endpoint_post (2021-06-14 13:01:26 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2021-06-14
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2021-06-14
    https://git.kernel.org/netdev/net/c/45deacc731d7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


