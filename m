Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B04A39E90F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhFGVWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231261AbhFGVV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:21:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7157061260;
        Mon,  7 Jun 2021 21:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100804;
        bh=YBDG9UzYvhAk59L1ni66r01H8TSJdUicAVBySUndE+k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fxkFh+sNQfX8v+v/T40qKFXcMRqnbRezN0YVRWKxPd89apq+gieAAHIG2LblpYdFS
         upvDDTZFMlutVR4r9GAqH0c/T9kkrCsHkG7dSu/oJOk66P+X4yA20AWrLPBH774wZC
         rwPUOVSk/39J8TAJdB9Gqq6ukI9VYGz4lwPalo7FYm7m9JFuZ9tfOovbqVqbVtOFUc
         amHUFGMtUeUrXofqOP6bwOaGMUP8rN83B9MhIxhYfmA6efSMcly014K+DdlhkTE13l
         RQvxvdpWVcy4EVmsMrjguqPx063oqUepa3+LeXiWQnJIMlv8dBpxGoEN9fxbIp3imM
         niAl4Niws7CsQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 688D260A1B;
        Mon,  7 Jun 2021 21:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netlabel: Fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310080442.4243.9926633939865814738.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:20:04 +0000
References: <20210607150100.2856110-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210607150100.2856110-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     paul@paul-moore.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 7 Jun 2021 23:01:00 +0800 you wrote:
> Fix some spelling mistakes in comments:
> Interate  ==> Iterate
> sucess  ==> success
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/netlabel/netlabel_domainhash.c | 2 +-
>  net/netlabel/netlabel_kapi.c       | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] netlabel: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/84a57ae96b29

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


