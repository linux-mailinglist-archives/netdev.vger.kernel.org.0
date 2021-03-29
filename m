Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BB634C0FA
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhC2BUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230167AbhC2BUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 21:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 093826193A;
        Mon, 29 Mar 2021 01:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616980809;
        bh=qvYR7opdpTGLuhs1HJte3U3S48jvQ6EKA/vAti7FddE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dDCAA7iyYB628yRHXKrMszGyIioN/FaJLEjvZmbvyCD9Lkdk0V7wf16DmL1OG5jQE
         q2N8DJOMIRMj/yB0AAg34il3IYD4qqQZQjH+B6APtHpph01+7MR4/fB35BTfw4245G
         fzJvKHHBxegKbTFDn/RthHjfO5IQKU/SSbW7XaqfN6YWjBGBvxMs9VUc9p+FPNO4PF
         jBW9JWjNyGEU3uItP8YZI3eTI1vZTRPUALdos/lZ5qlokfGau6eozr+cqGsmRQFqte
         EIGrgUQzmaBEGS9tQeCniayFzE++EtfktpYXbsjvnkm7/A+5E6zXu188vS2BY+l/ss
         XglRBdcmm92GQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ED31E609E8;
        Mon, 29 Mar 2021 01:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161698080896.6233.18333796384471288831.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 01:20:08 +0000
References: <20210328075008.4770-1-lyl2019@mail.ustc.edu.cn>
In-Reply-To: <20210328075008.4770-1-lyl2019@mail.ustc.edu.cn>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     khc@pm.waw.pl, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 28 Mar 2021 00:50:08 -0700 you wrote:
> In pvc_xmit, if __skb_pad(skb, pad, false) failed, it will free
> the skb in the first time and goto drop. But the same skb is freed
> by kfree_skb(skb) in the second time in drop.
> 
> Maintaining the original function unchanged, my patch adds a new
> label out to avoid the double free if __skb_pad() failed.
> 
> [...]

Here is the summary with links:
  - drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit
    https://git.kernel.org/netdev/net/c/1b479fb80160

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


