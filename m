Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBDE3CBC20
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 20:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbhGPSxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 14:53:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhGPSw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 14:52:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AB843613D4;
        Fri, 16 Jul 2021 18:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626461404;
        bh=yJV5FpmgKuYyCRiBEPqE5UggKP1YUDvraHXINqKQwD0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ePoWPz7AyzZCam/oK+xf5sEQ/DK5HaQqb0yP3kQR/nq611ZP8s24ca7a17AIvh9N6
         IajuGG6u1q3i1OEtHd9djoLF6sH6G5w28CVt4t/ib80AmraFigNbBBw5NB3X2RgdMC
         QU5QbJmTAkR9qBkk+xNTZsLia3+71m1mPDPRmChzYrFlmvDPLonKUdX6x916TepwhP
         VA7g6SPUjMn5HOw6U5B3vV7gjD3fmuMIx38D9SK/56kytb8O2M4t4ggdzNV5XXDAmG
         CilzVDiBcNdwweDFJy8lTor2VjGTl61JfnQ8Xy6et5sZ4jH1Vrkpqf9RSJo4Lz1ae4
         0GKcebe0VRXXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9C74B609DA;
        Fri, 16 Jul 2021 18:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1 v3] skbuff: Fix a potential race while recycling page_pool
 packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162646140463.32424.6557928030854719030.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Jul 2021 18:50:04 +0000
References: <20210716070222.106422-1-ilias.apalodimas@linaro.org>
In-Reply-To: <20210716070222.106422-1-ilias.apalodimas@linaro.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, linyunsheng@huawei.com,
        alexanderduyck@fb.com, brouer@redhat.com, davem@davemloft.net,
        kuba@kernel.org, alobakin@pm.me, jonathan.lemon@gmail.com,
        willemb@google.com, linmiaohe@huawei.com, gnault@redhat.com,
        cong.wang@bytedance.com, mcroce@microsoft.com,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 16 Jul 2021 10:02:18 +0300 you wrote:
> As Alexander points out, when we are trying to recycle a cloned/expanded
> SKB we might trigger a race.  The recycling code relies on the
> pp_recycle bit to trigger,  which we carry over to cloned SKBs.
> If that cloned SKB gets expanded or if we get references to the frags,
> call skb_release_data() and overwrite skb->head, we are creating separate
> instances accessing the same page frags.  Since the skb_release_data()
> will first try to recycle the frags,  there's a potential race between
> the original and cloned SKB, since both will have the pp_recycle bit set.
> 
> [...]

Here is the summary with links:
  - [1/1,v3] skbuff: Fix a potential race while recycling page_pool packets
    https://git.kernel.org/netdev/net/c/2cc3aeb5eccc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


