Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F8641AF0C
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240723AbhI1Mbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240546AbhI1Mbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:31:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 280EA61159;
        Tue, 28 Sep 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632832208;
        bh=DsrtMerb5hAUgCpUVacvxFpmcBwQwV4JSST8V7osueI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U6sLXrq483tLDVVV5V0dkx52XfvM0xZIze+heRtPAZFc2AI/NqQ7KUUlAanpcVQxw
         POp5Igmsglt3KWPp8wqcnCfwEldBjJxEJhz2FjOkExw+FzGh/biJw5FEjd/+Z70SeU
         jqd/5Pl1/rvDhKgDq+R6UCYWE8bgpKIlYO1XHhWiufp2/XyNPVAKdMa55+0FP3ypmk
         8oxdVfJK4lijnbrTVRkwsmHxwGNxoLVwmgZtnifVqKkBURE02Rz4JZiMSdqP6HcZpE
         JbrylWFqktgbmjmal9NXYX77zfM0hj7VzgIUQcbKcjjO7ooSZ5kMUqR+asoG7wjWqP
         QBYsaCxXtC87g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1B25E60A69;
        Tue, 28 Sep 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] af_unix: Return errno instead of NULL in unix_create1().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283220810.6805.821728319483888771.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 12:30:08 +0000
References: <20210928004227.9440-1-kuniyu@amazon.co.jp>
In-Reply-To: <20210928004227.9440-1-kuniyu@amazon.co.jp>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     davem@davemloft.net, kuba@kernel.org, benh@amazon.com,
        kuni1840@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 28 Sep 2021 09:42:27 +0900 you wrote:
> unix_create1() returns NULL on error, and the callers assume that it never
> fails for reasons other than out of memory.  So, the callers always return
> -ENOMEM when unix_create1() fails.
> 
> However, it also returns NULL when the number of af_unix sockets exceeds
> twice the limit controlled by sysctl: fs.file-max.  In this case, the
> callers should return -ENFILE like alloc_empty_file().
> 
> [...]

Here is the summary with links:
  - [net] af_unix: Return errno instead of NULL in unix_create1().
    https://git.kernel.org/netdev/net/c/f4bd73b5a950

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


