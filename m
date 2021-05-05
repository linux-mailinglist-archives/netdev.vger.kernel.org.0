Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77B03748E3
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 21:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhEETvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 15:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233512AbhEETvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 15:51:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 30E48613C7;
        Wed,  5 May 2021 19:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620244210;
        bh=W+/HruJkTs47y8+Ionclt8owswhldiQL8RqjoAm0cAs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pt80Qf/hG6wnCJHluViOda4wQuTGqTDjRzf67xlWX7hCuu5FmVF8AkFiCO6XE4dnW
         4hKS2jMFZBRM5zy8tp7CFQRB+GCJVmXUi4LpNCl5Olcv91iQHt1vShpp6zUc3axb4O
         Vm/Un0ckO0BJfbfPTudj/aoin3NWgJgJVtdunKZ55coo7QQVQI05Xr5SCIcoWL+pze
         bYhqtZFTNd1VBLUGWDLW27868hHJ7+yfCXfwoVEUGmhNnXFr73AzDD6Jd5eiMQXEBU
         wmtzPE7Pg1FsoAW53RqEnTOD26pk8tF2AZOGouggjI2AiNgTQ1EzqqkNXlFQMeSFBV
         sCZ4OfZJ5ZmCQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 252C8609AC;
        Wed,  5 May 2021 19:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net:CXGB4: fix leak if sk_buff is not used
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162024421014.18947.13737323283517875110.git-patchwork-notify@kernel.org>
Date:   Wed, 05 May 2021 19:50:10 +0000
References: <20210505125450.21737-1-ihuguet@redhat.com>
In-Reply-To: <20210505125450.21737-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, rajur@chelsio.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org, ivecera@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  5 May 2021 14:54:50 +0200 you wrote:
> An sk_buff is allocated to send a flow control message, but it's not
> sent in all cases: in case the state is not appropiate to send it or if
> it can't be enqueued.
> 
> In the first of these 2 cases, the sk_buff was discarded but not freed,
> producing a memory leak.
> 
> [...]

Here is the summary with links:
  - net:CXGB4: fix leak if sk_buff is not used
    https://git.kernel.org/netdev/net/c/52bfcdd87e83

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


