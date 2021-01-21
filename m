Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9648E2FE2A0
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbhAUGVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:21:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbhAUGUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 01:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B630C23998;
        Thu, 21 Jan 2021 06:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611210008;
        bh=bIlqy5I46Kk7Jvlc4bzIIYuuTzyrc6UOw6bqX9kHEiQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VKzu6UAVNMXhj9g9v4A5XjUnFfTNm58rynbNrZ1gFUIYaVP62r/FIU8lInCpVa73W
         /kVz3m7/kfZPikntJo4GEfXj3wXBE83gWmS2YUFY92Lso7VV7C+O6VwnwTS/Ktl8SL
         wyjnsJDCiJfuJgiVPpj/tjuVbW2mN+sk099NadNbAfROBl78o6Wc6es25rzoYVDNrs
         xBOlmn6KE8PyjIKSQHqz0BTfE+eQdWLl3I1RG9OYz1P7ocdU9v8Eix6+lV5BAHnHky
         pE14o4c6Vh4w+NR47tAq+hy5cPiMxeLOyDu55CUjzFR1outmaPhsysgMCKMd9AskMk
         8VTgf8EWHOxDQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id AAA3F60671;
        Thu, 21 Jan 2021 06:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next ] net/sched: cls_flower add CT_FLAGS_INVALID flag
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161121000869.22302.3585867980546229985.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jan 2021 06:20:08 +0000
References: <1611045110-682-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1611045110-682-1-git-send-email-wenxu@ucloud.cn>
To:     wenxu <wenxu@ucloud.cn>
Cc:     marcelo.leitner@gmail.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 19 Jan 2021 16:31:50 +0800 you wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This patch add the TCA_FLOWER_KEY_CT_FLAGS_INVALID flag to
> match the ct_state with invalid for conntrack.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net/sched: cls_flower add CT_FLAGS_INVALID flag support
    https://git.kernel.org/netdev/net-next/c/7baf2429a1a9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


