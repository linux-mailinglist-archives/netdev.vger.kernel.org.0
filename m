Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2168E3DD319
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 11:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhHBJkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 05:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232981AbhHBJkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 05:40:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4AB86610CE;
        Mon,  2 Aug 2021 09:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627897205;
        bh=PsH/wOaJKe7A9R9SzPvFvlx9TJnBRv/iA/3KjIc+84Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KetyjRBaexGyLvLtqtmtxgHOfwSVGs2KAt+mBAERiyJadiw7D7GwPBz1T9xaAqQSz
         YHG/3kNIluHG3fo4R8KPuvmWmwIVmE+XZN6WzfdwWvvZ3WAcw2yWvTaG82nfHj03oN
         BLVvYMgpQgL2NgUOQUlYlUGyi7Q8JNJn/rYB/nEHPXoKMooxY0bEzcbP6YLfPhcXMD
         VGR4zr+AnLry8v3bVbd08dTbn577TkmW/Wd/w1+Tw8QWzz5VH7WwZ/dK1FDIz9hsEN
         HwiTe0OSpiyx3MlHjP5GKOv0ps/JPLtMlTyEvFlVh7S4992oFRGs/d6U00LO+dSipO
         fruO7Vt3BozkA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3F2BB60A54;
        Mon,  2 Aug 2021 09:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/net: remove min gso test in packet_snd
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162789720525.9959.3509126633321925106.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 09:40:05 +0000
References: <20210730034155.24560-1-dust.li@linux.alibaba.com>
In-Reply-To: <20210730034155.24560-1-dust.li@linux.alibaba.com>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     willemb@google.com, edumazet@google.com,
        xuanzhuo@linux.alibaba.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 30 Jul 2021 11:41:55 +0800 you wrote:
> This patch removed the 'raw gso min size - 1' test which
> always fails now:
> ./in_netns.sh ./psock_snd -v -c -g -l "${mss}"
>   raw gso min size - 1 (expected to fail)
>   tx: 1524
>   rx: 1472
>   OK
> 
> [...]

Here is the summary with links:
  - selftests/net: remove min gso test in packet_snd
    https://git.kernel.org/netdev/net-next/c/cfba3fb68960

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


