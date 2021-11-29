Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2834614F3
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 13:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348454AbhK2MZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 07:25:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54362 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244356AbhK2MX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 07:23:29 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBEC4B81028
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 12:20:10 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 5832860E0B;
        Mon, 29 Nov 2021 12:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638188409;
        bh=keroKKtMdhqUmLkKEHYvn13K1sw9zPbTFOJf7J2JApg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dH47Qywu1cu8/fs1Lrbpb9/1oXm2EMs9GE0/szCG/Am2mh19bxSZnQN08z4S2YYVj
         tsB9aFh3j0khXnczrGTAvyxKxvYQH/2tVzlkC/RgfWzQWDCkpZnL9yR1nbzWuiAF2/
         4WVRJTx9bDxb5zDynTMblZjS2vo52wxizHxRX2sQglLmtnpTnIk3v88AXMXRb840cH
         ULWl8hYwvVn6dwn4SLpxVakKbdWKP1dfOX9NRMcIcsvuk96Im+nKcSupa1N7dtzfah
         +eWa4mmoZtWxxuloO92am/O57LHgCCJtieNOwKivELKNkJTmuGef2/BJQN6rbbxsvp
         iI7tor3LODAVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 43A4A60A4D;
        Mon, 29 Nov 2021 12:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] tcp: fix page frag corruption on page fault
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163818840927.20614.11748818922742306983.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 12:20:09 +0000
References: <0fa74bfdfee95d6bba9fa49a5437f63c014f29ce.1637951641.git.pabeni@redhat.com>
In-Reply-To: <0fa74bfdfee95d6bba9fa49a5437f63c014f29ce.1637951641.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, sfroemer@redhat.com, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 26 Nov 2021 19:34:21 +0100 you wrote:
> Steffen reported a TCP stream corruption for HTTP requests
> served by the apache web-server using a cifs mount-point
> and memory mapping the relevant file.
> 
> The root cause is quite similar to the one addressed by
> commit 20eb4f29b602 ("net: fix sk_page_frag() recursion from
> memory reclaim"). Here the nested access to the task page frag
> is caused by a page fault on the (mmapped) user-space memory
> buffer coming from the cifs file.
> 
> [...]

Here is the summary with links:
  - [net,v2] tcp: fix page frag corruption on page fault
    https://git.kernel.org/netdev/net/c/dacb5d8875cc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


