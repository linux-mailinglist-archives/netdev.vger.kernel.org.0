Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08510404899
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 12:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbhIIKlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 06:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233654AbhIIKlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 06:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1815361051;
        Thu,  9 Sep 2021 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631184006;
        bh=HtLo+QZon2GmCMDp/1+xD0TFN+fnYB2CvGWRaYOJG2A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bshU4qwJNO6RRdGU05GqxqvtKaNnUyT4m7xyxkk30j/b5mGKSDSj4pnGJkJQpuXf2
         o/LJsfF3JZLFnlPDwenhbb3XQ/D33IeSQSXid6cl2a1tbBEEnW3mmETbRhOtsk0lsK
         x1x++w33zyqX/cE8u0o7qySpob9DWlHWG8CiBpV2GAKfV1KUr7dArV+MZJuta1nXjs
         g2g5QniIVtH7qTWl6t9Kt1OHRBgef5g6QLNaGO9I8x2NFGixanX/IUGs2/iqrBDPgs
         N4JKNx8KMiGnKJ2jJxfpd2qpsi21CcmDKS92WS4RTUKzlNG3NX0hJYddOYOhz2zVor
         qRuOUjguss09g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 093496098C;
        Thu,  9 Sep 2021 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] sfc: fallback for lack of xdp tx queues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163118400603.20005.10629847709385572006.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Sep 2021 10:40:06 +0000
References: <20210909092846.18217-1-ihuguet@redhat.com>
In-Reply-To: <20210909092846.18217-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  9 Sep 2021 11:28:44 +0200 you wrote:
> If there are not enough hardware resources to allocate one tx queue per
> CPU for XDP, XDP_TX and XDP_REDIRECT actions were unavailable, and using
> them resulted each time with the packet being drop and this message in
> the logs: XDP TX failed (-22)
> 
> These patches implement 2 fallback solutions for 2 different situations
> that might happen:
> 1. There are not enough free resources for all the tx queues, but there
>    are some free resources available
> 2. There are not enough free resources at all for tx queues.
> 
> [...]

Here is the summary with links:
  - [net,1/2] sfc: fallback for lack of xdp tx queues
    https://git.kernel.org/netdev/net/c/415446185b93
  - [net,2/2] sfc: last resort fallback for lack of xdp tx queues
    https://git.kernel.org/netdev/net/c/6215b608a8c4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


