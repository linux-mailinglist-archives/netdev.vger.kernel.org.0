Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0575C3A07F5
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbhFHXmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235575AbhFHXmA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 19:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2848C613B6;
        Tue,  8 Jun 2021 23:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623195606;
        bh=//JH77kiDMU57tEzPV/jpr6xAw3QTOwBzIc4UkbZWx4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XfAJKnLUlMtthL3lhZQ3ZZ40dORSQOfpyW8D9iUjICXb69Pi+urdfSpXM+tNWxle7
         fOWWNvu235MR9Fm95jaBAJWQzmw6DYaO0dBMbP49MzMjnaFw5w11/xz7EI9hsUZjUw
         SgyNqzN58G1p2ha63rO+SQrxyJ7RXjYY2S5WxxDXLHY0PncqGdEdNJ1ZvGeRmOEzCH
         AqEzix+KJ/TOCvGr4HI8Zj1up5JZ0fR+7FhKtFd9/8fOjqALXrOm2QG04VvVo2O7/t
         x7kvVtOnQeE1AANa8sAl7+CgUih7SPApNs8Tul4aLVuqy6Hol5fex+sBvQeKtcMTC2
         wO4nvTrU+mlEw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1DEF160BE2;
        Tue,  8 Jun 2021 23:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: x25: Use list_for_each_entry() to simplify code
 in x25_link.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162319560611.24693.17594586719275755475.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 23:40:06 +0000
References: <20210608080505.32466-1-wanghai38@huawei.com>
In-Reply-To: <20210608080505.32466-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ms@dev.tdt.de,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 8 Jun 2021 08:05:05 +0000 you wrote:
> Convert list_for_each() to list_for_each_entry() where
> applicable. This simplifies the code.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/x25/x25_link.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] net: x25: Use list_for_each_entry() to simplify code in x25_link.c
    https://git.kernel.org/netdev/net-next/c/3835a6614ae7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


