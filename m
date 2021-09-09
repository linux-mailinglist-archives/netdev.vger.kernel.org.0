Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1002140483B
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 12:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbhIIKLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 06:11:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229995AbhIIKLP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 06:11:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D4EFE611BF;
        Thu,  9 Sep 2021 10:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631182205;
        bh=QxT3fn/2AlcEEnFYGDVZBVWiTKAzLWH/T46UtW2QvlM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jWiUBsgKPjobtgUIOMPkO24j9MOVGT3Mk52uQtVi73Fhi273l5JPd23rF1aVLHhYo
         anyjSwUl6dvg13Ts30a09uCWR/OiwE6nWcPvvo0CPv1Z5oHMu+1uewWHirgRPWEufz
         fsR4gvvTq/fpayAX6YcTTYGxX/0ItDGyBh9NQjqwrjvOQHfZqNJQEr52zEbSshtaD4
         +EUDa88ftQcSSQI8t3H7iJ+pGSYMqK9D2ishlrtvqJ2iiyOZLDIOSHmZE3ZZTbYGQc
         byerB7q6jXteuiGKCslWsFmUyi+BfZs15SGAQaIynmy8RSQv8AhdCkZTgJkFlCQpMR
         EftmTidveO2+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C434D609B3;
        Thu,  9 Sep 2021 10:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/l2tp: Fix reference count leak in l2tp_udp_recv_core
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163118220579.5425.12106062593104107133.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Sep 2021 10:10:05 +0000
References: <1631161930-77772-1-git-send-email-xiyuyang19@fudan.edu.cn>
In-Reply-To: <1631161930-77772-1-git-send-email-xiyuyang19@fudan.edu.cn>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     davem@davemloft.net, kuba@kernel.org, cong.wang@bytedance.com,
        rdunlap@infradead.org, tparkin@katalix.com, xiongx18@fudan.edu.cn,
        sishuai@purdue.edu, mschiffer@universe-factory.net,
        unixbhaskar@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuanxzhang@fudan.edu.cn,
        tanxin.ctf@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  9 Sep 2021 12:32:00 +0800 you wrote:
> The reference count leak issue may take place in an error handling
> path. If both conditions of tunnel->version == L2TP_HDR_VER_3 and the
> return value of l2tp_v3_ensure_opt_in_linear is nonzero, the function
> would directly jump to label invalid, without decrementing the reference
> count of the l2tp_session object session increased earlier by
> l2tp_tunnel_get_session(). This may result in refcount leaks.
> 
> [...]

Here is the summary with links:
  - net/l2tp: Fix reference count leak in l2tp_udp_recv_core
    https://git.kernel.org/netdev/net/c/9b6ff7eb6664

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


