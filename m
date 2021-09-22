Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2EC414A8E
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 15:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhIVNbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 09:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230512AbhIVNbh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 09:31:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 546A56112F;
        Wed, 22 Sep 2021 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632317407;
        bh=SePNwmUkQhgmBizUU3gBFCmc0FIm7Yj9dspdshNbB5g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fap9+x3Ipm5gYcZRvGHC/r7I6ZJogQD5LAPsVc1s5/hMwzURXL6e3feBgW2nB39an
         Lo4ftEdOxovrFfZlIaVylb47bFmvbQzl/jqvpcT21eFpg2N6JlddTp3qiZq3jWErBd
         5BnJo7AGS5m/OjlTdO5G+pk15kTose5ioQTIu8pUGHd1OsxM7F5RrxlvbUXEMbcqvZ
         qGgDzgdJNPtGOzNksY0gX04abDgpEwxdtFmAQAw0GT1/SeBKhvvkVabqBz+mf02xfr
         YG4JaKe8LSlGToqulQM+sKNk6cj5844tREPkbs3V0SFf9mwqbV9LZ+YGjP9z3mshmG
         OqYxPTbWlFBGQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4911760A88;
        Wed, 22 Sep 2021 13:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][net-next] skbuff: pass the result of data ksize to
 __build_skb_around
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163231740729.20371.12961823401964513086.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Sep 2021 13:30:07 +0000
References: <1632291439-823-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1632291439-823-1-git-send-email-lirongqing@baidu.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 22 Sep 2021 14:17:19 +0800 you wrote:
> Avoid to call ksize again in __build_skb_around by passing
> the result of data ksize to __build_skb_around
> 
> nginx stress test shows this change can reduce ksize cpu usage,
> and give a little performance boost
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> 
> [...]

Here is the summary with links:
  - [net-next] skbuff: pass the result of data ksize to __build_skb_around
    https://git.kernel.org/netdev/net-next/c/a5df6333f1a0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


