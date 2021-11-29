Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7085E4619DE
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378621AbhK2OmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379003AbhK2OkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:40:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A762C08ED73;
        Mon, 29 Nov 2021 05:10:13 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14ADEB81134;
        Mon, 29 Nov 2021 13:10:12 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id CD94C60E53;
        Mon, 29 Nov 2021 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638191410;
        bh=s41b6GiY1ZU+Ca9khnTQavt7z2c/AiOPUYC9uapD8DI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VUcyHcr2GSfOkcNP6RYeTfC6yniIa3Dx+QQ7n3XA7iSEXm1AD79nWNfwDkOR9ai8v
         R+AXqiMNAWufoVVeazpqfIs7JYbFrfw4YmDQKl3NP9rJiYrXi5G/A8dbJylo/iEbrS
         mGHbHbAPVhIeI6ttkdoncGc2M0p+qPu3gBtGwejwj4vKCeeFJB+lEKMk3Wtm9dibrH
         dRlvMJFTbIPk+IYJdOcISiRjE1HizXa8obry+s6VJVUq4pFltnMXlyKeDLyp+6ccQJ
         HcZysrRbNlc+yD9ofnc42WRuHpXFnuBm5ZKuGxZp3JJoock0o9eLL1q5ImyQOuXKIv
         1Gfdvgi0Z25JQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C73B9609D5;
        Mon, 29 Nov 2021 13:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: snmp: add statistics for tcp small queue
 check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819141081.10588.17086173547137310725.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 13:10:10 +0000
References: <20211128060102.6504-1-imagedong@tencent.com>
In-Reply-To: <20211128060102.6504-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, edumazet@google.com, imagedong@tencent.com,
        ycheng@google.com, kuniyu@amazon.co.jp,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 28 Nov 2021 14:01:02 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Once tcp small queue check failed in tcp_small_queue_check(), the
> throughput of tcp will be limited, and it's hard to distinguish
> whether it is out of tcp congestion control.
> 
> Add statistics of LINUX_MIB_TCPSMALLQUEUEFAILURE for this scene.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: snmp: add statistics for tcp small queue check
    https://git.kernel.org/netdev/net-next/c/aeeecb889165

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


