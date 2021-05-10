Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2145D379911
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 23:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhEJVVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 17:21:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229810AbhEJVVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 17:21:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AE0B96143C;
        Mon, 10 May 2021 21:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620681630;
        bh=W7x4+uZ7VVa2q7Y6dgs5UJff+CkCbukbrQgvkVm/xQs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NpPsiEz/FAGAGuK2qXGfzYxwMXhwxrFqeqAroZT9TpKYdJU5Fk7rLOgBNB/KXUc+M
         N6xFuyt62IV5JvxFvbUIMXCVrNIvBIxUz1fP0C3HrMVVe0zD5lgG/ljTRrytoZksFV
         APVz1toXkTFoW0ry00X3t/UNkM1HT8BfPRDyDkF9FzykOHAu6P5uatlVDJAV9TcD0v
         uN7Xn2dFCaKEeze9QsJ13p/gnZ+vGvec3TlQl03FRy33icTrueOTHkDty62SHwFCJ5
         jXT1kNWB78D8WZTXfk4lCjrjP9NaAJzpU9bm+jOFmMV26d87Oesvd3BAV7WqWsNDim
         lIng47K4UwGMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9E8C760A27;
        Mon, 10 May 2021 21:20:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: openvswitch: Remove unnecessary skb_nfct()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068163064.24072.9360030914450540310.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 21:20:30 +0000
References: <1620440827-17900-1-git-send-email-yejunedeng@gmail.com>
In-Reply-To: <1620440827-17900-1-git-send-email-yejunedeng@gmail.com>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yejunedeng@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat,  8 May 2021 10:27:07 +0800 you wrote:
> There is no need add 'if (skb_nfct(skb))' assignment, the
> nf_conntrack_put() would check it.
> 
> Signed-off-by: Yejune Deng <yejunedeng@gmail.com>
> ---
>  net/openvswitch/conntrack.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)

Here is the summary with links:
  - net: openvswitch: Remove unnecessary skb_nfct()
    https://git.kernel.org/netdev/net-next/c/d2792e91de2b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


