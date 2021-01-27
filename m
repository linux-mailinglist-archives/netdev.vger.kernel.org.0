Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6A930682E
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhA0Xm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 18:42:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234736AbhA0Xku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 18:40:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6CFD060C40;
        Wed, 27 Jan 2021 23:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611790810;
        bh=I16cUpBAaYEa6DS/qK/B522UAMTuzAUcdR9IdGGmuNQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CgBCm3sBxAJMREhnrKWTx+voaMTsMBo7TpjYMG2tC9e/Ui0T7PmOSugdgjbSd/oSP
         ryjDwbUYuxmcIQdZ1if+SZkZzO6NF8S0tPpHyOxXwja8y2jTuuflW1/PxdszeFSVv5
         JflGa/H3nl0vSO9V+SOL/GJ6ESs0p3T4lP7At0nNVy5kRp7hc2B9kG2L2s5F3HTIfg
         wNNW4kQ8WTb2U+f2TqQe7+VmCa4zJ5pkdvxpboBGnoe32ZoPSD50kh1we/eI6+KJDX
         HXuYLvQL+Mkvv0ZMiwMeiKA0eCq+FGndcA3ROVujd5orVDWTefwKMPQ+Qlag5Pme7q
         lRd8crLAP3GoQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5EF5D613AA;
        Wed, 27 Jan 2021 23:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch bpf-next] skmsg: make sk_psock_destroy() static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179081038.20439.3619802402559299458.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jan 2021 23:40:10 +0000
References: <20210127221501.46866-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210127221501.46866-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        cong.wang@bytedance.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 27 Jan 2021 14:15:01 -0800 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> sk_psock_destroy() is a RCU callback, I can't see any reason why
> it could be used outside.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] skmsg: make sk_psock_destroy() static
    https://git.kernel.org/bpf/bpf-next/c/8063e184e490

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


