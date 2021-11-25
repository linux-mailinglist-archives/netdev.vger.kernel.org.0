Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC67C45D271
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245036AbhKYBfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:35:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346211AbhKYBdT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 20:33:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D334B610F7;
        Thu, 25 Nov 2021 01:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637803808;
        bh=39A8wpadPnrKlioEnhKiZx69uVTBlmAKcuOyCdyroLg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FEOMP0vPzd3rggGTfsgb6r3W2AFJiWa0BH7tT0O/L69qQnWnt0ja/ev++mi+nvm68
         jW7ayWIyaLVR4sLV8Io+vQ0cpNgfZqOClGftULo7O4QBnrzMci1JPMjhE6f4DUZiJ6
         QWIlfnlsAycJs3L0eI+t3skRN3YKPJs/4p3q5plleEk8gwJSImW7Ta3i8C4NtgYuED
         octPDGHQTNdfnCbZQIO05xeeqksL6XEdunJqrNv6mkGSyl+qI+FMNY26ISQbYo+BMm
         2YclaLzk46r92V/KbG2o0MZESNOE+3Vqwt/+7qanck28UCGtpAVOLEDjHP50pxCHM4
         jYnaGRR6zaYsA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BE38160A0A;
        Thu, 25 Nov 2021 01:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp_cubic: fix spurious Hystart ACK train detections for
 not-cwnd-limited flows
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780380877.5226.16376864840352024866.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 01:30:08 +0000
References: <20211123202535.1843771-1-eric.dumazet@gmail.com>
In-Reply-To: <20211123202535.1843771-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, ncardwell@google.com,
        stephen@networkplumber.org, ycheng@google.com, soheil@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Nov 2021 12:25:35 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While testing BIG TCP patch series, I was expecting that TCP_RR workloads
> with 80KB requests/answers would send one 80KB TSO packet,
> then being received as a single GRO packet.
> 
> It turns out this was not happening, and the root cause was that
> cubic Hystart ACK train was triggering after a few (2 or 3) rounds of RPC.
> 
> [...]

Here is the summary with links:
  - [net] tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows
    https://git.kernel.org/netdev/net/c/4e1fddc98d25

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


