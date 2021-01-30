Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2696E3093F3
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 11:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhA3KEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 05:04:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233240AbhA3Crl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 21:47:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5FB1B64E17;
        Sat, 30 Jan 2021 02:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973808;
        bh=Xbb7K2Whr/O6pjP/NOiETYUVAbM8QLWnNs8zvXZX7cM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HFXZ7N8BfZawNHRKgv6ihthx5Y7acTONT53xjw5uF3onxHOvaaCB4NADZog4I+NtP
         93pn3DOykFkuS167YSMGL0ZPXJsHqXnCbRqTK3I4k4XVQSCSJid1/ZJ9JG4KKUiovm
         V8pQlKTwuIY/gvKELk4SwHZQr+xPiE5uoI8b/2a5rnWFMlAvVIyE2fJuUFe0wlH+ga
         leFHtiDitO5Jnemxosxrq7oSKAabQgCVrTzBfn2GxUOdHMYp5R8oUNW6V8fituNVtD
         /KK1ZHcXQ/71Fu5xbNQQHrHjA+fiFJhgM5lp93K7857nnjsIss4VQLWHaAF9AQ81g8
         WZKpVUC8Ld50A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 547AF6095B;
        Sat, 30 Jan 2021 02:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/2] Add nci suit and virtual nci device driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161197380834.28728.3903121798375057144.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jan 2021 02:30:08 +0000
References: <20210127130829.4026-1-bongsu.jeon@samsung.com>
In-Reply-To: <20210127130829.4026-1-bongsu.jeon@samsung.com>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     kuba@kernel.org, shuah@kernel.org, krzk@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-nfc@lists.01.org, linux-kselftest@vger.kernel.org,
        bongsu.jeon@samsung.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 27 Jan 2021 22:08:27 +0900 you wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> 1/2 is the Virtual NCI device driver.
> 2/2 is the NCI selftest suite
> 
> v4:
>  1/2
>  - flip the condition for the ioctl.
>  - refactor some code.
>  - remove the unused function after refactoring.
> v3:
>  1/2
>  - change the Kconfig help comment.
>  - remove the mutex init code.
>  - remove the unnecessary mutex(nci_send_mutex).
>  - remove the full_txbuff.
>  - add the code to release skb at error case.
>  - refactor some code.
> v2:
>  1/2
>  - change the permission of the Virtual NCI device.
>  - add the ioctl to find the nci device index.
>  2/2
>  - add the NCI selftest suite.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/2] nfc: Add a virtual nci device driver
    https://git.kernel.org/netdev/net-next/c/e624e6c3e777
  - [net-next,v4,2/2] selftests: Add nci suite
    https://git.kernel.org/netdev/net-next/c/f595cf1242f3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


