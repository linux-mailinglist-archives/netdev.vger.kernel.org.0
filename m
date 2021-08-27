Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5D33F9675
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 10:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244692AbhH0Iuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 04:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244510AbhH0Iuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 04:50:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 75C9760FDC;
        Fri, 27 Aug 2021 08:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630054206;
        bh=MctHQHKg5CFqgeHLwksJi8o4x2bSXwRfx6chly7psck=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jHutDI+FmzmH3ScPyvq3BGMkjXthJt1o9QBcDJ3tjrV785ckNivWqED0gTl/QI5ic
         DZkeXx3VMyOo2fld1bkGSMxiV2cBqCOQV5T0zUY0FWMijC2/coIUNFhq8tOtVyXHO7
         wJoZICl/BzGjOnP7/kkEjQjID/wvRoO9AEMjqZ95sNe2SbEh765pTl6r5wOQup/a6D
         cHxZMtjHgnTzWQTjR4pE4vobFE91L2FFaVNmRT9Ot2/pDvNFjGxVpgIm1lflhWFZq3
         INOAVe1dIqPwZtA283JBVmAnrZTHfh5fz7BDmXoVLE2byTmm/XbURgpqAjUkSHsjFq
         Ntd3HSflBDRsA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6538860A27;
        Fri, 27 Aug 2021 08:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: don't unconditionally copy_from_user a struct ifreq
 for socket ioctls
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163005420640.11012.15053925482191718453.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Aug 2021 08:50:06 +0000
References: <20210826194601.3509717-1-pcc@google.com>
In-Reply-To: <20210826194601.3509717-1-pcc@google.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, colin.king@canonical.com,
        cong.wang@bytedance.com, viro@zeniv.linux.org.uk,
        gregkh@linuxfoundation.org, David.Laight@aculab.com,
        arnd@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 26 Aug 2021 12:46:01 -0700 you wrote:
> A common implementation of isatty(3) involves calling a ioctl passing
> a dummy struct argument and checking whether the syscall failed --
> bionic and glibc use TCGETS (passing a struct termios), and musl uses
> TIOCGWINSZ (passing a struct winsize). If the FD is a socket, we will
> copy sizeof(struct ifreq) bytes of data from the argument and return
> -EFAULT if that fails. The result is that the isatty implementations
> may return a non-POSIX-compliant value in errno in the case where part
> of the dummy struct argument is inaccessible, as both struct termios
> and struct winsize are smaller than struct ifreq (at least on arm64).
> 
> [...]

Here is the summary with links:
  - [v2] net: don't unconditionally copy_from_user a struct ifreq for socket ioctls
    https://git.kernel.org/netdev/net/c/d0efb16294d1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


