Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF0A3721B7
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 22:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhECUlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 16:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229927AbhECUlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 16:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 63B48613BC;
        Mon,  3 May 2021 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620074410;
        bh=2PdybJZD6tQhgXWqQhOfDDNd3+7GQHtgPVcORjN+IZg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PEywc7Glofd/UuGIq1YPN7suUB5aukK3yCZ4YcQnZ5F+d3JyVR3re2qPW8QE/k/6e
         TiP2KnRMG81agyz2bj4bYfkH48/dXHhBlq6MC6goezZNfqs8OiIeO+CC/w7JqnLuhU
         QeemHLlZgLVCbhr1C3Vs4Qn9o6lTHHqw6hQwzvJlPjQeec72AfeGlg4VU1Yp/hjKn6
         QF5XC6pReMyTFwfYJt+b/Hqk68sZ1g3q1uOVPfY2+YD9VNhxrfCd8+wyjQXXaAyBqs
         fk/rqCQHPmUlSa63l2I0V8qlt5YvjX5IwuLHgJ6z0BtWipjA2nksnBUnZ+3b7CJnOZ
         kuZJmb4qPxslA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 55D0B60A49;
        Mon,  3 May 2021 20:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "drivers/net/wan/hdlc_fr: Fix a double free in
 pvc_xmit"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162007441034.32677.14180687358659770413.git-patchwork-notify@kernel.org>
Date:   Mon, 03 May 2021 20:40:10 +0000
References: <20210503035136.22063-1-xie.he.0141@gmail.com>
In-Reply-To: <20210503035136.22063-1-xie.he.0141@gmail.com>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     khc@pm.waw.pl, davem@davemloft.net, kuba@kernel.org,
        lyl2019@mail.ustc.edu.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  2 May 2021 20:51:36 -0700 you wrote:
> This reverts commit 1b479fb80160
> ("drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit").
> 
> 1. This commit is incorrect. "__skb_pad" will NOT free the skb on
> failure when its "free_on_error" parameter is "false".
> 
> 2. This commit claims to fix my commit. But it didn't CC me??
> 
> [...]

Here is the summary with links:
  - [net] Revert "drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit"
    https://git.kernel.org/netdev/net/c/d362fd0be456

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


