Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76407396D06
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhFAFvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232997AbhFAFvr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:51:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7436E613CB;
        Tue,  1 Jun 2021 05:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622526606;
        bh=KrsNrVI8sz27XMORzupr1sqA+AwjYUBF76fdOaHfzGs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CJzaVZXZLn1yZc+/mu3iFIp/yQ9b2sPrXnz5o/KBnvfH7ySVC4bcGO/naL5QRPpBe
         M3fV0M0macpmLHbGSnEwFdE4h/56HRmxXhkC5V4QZ7lkFHbaqWMti/M7fZmO0XNDXf
         HwBiCx+Y0vcqGtgA2FJq7BvDI+npEGYzPftILnUIok045WlLj5vr5V5B2GuFcZh/sI
         Sjgsm9ybHQqBwtCbRyweHWptQkYuniurltScmf/Sjm8rmgpvzadBaOklHkg1h/ddVQ
         rpkCYRh0oxvfKzBhlyJET1FDkZ4zmBcrEshQ0zbg1frUiiUvZoJRgCmXjREjUvFzys
         ya/m4IBwTbh/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6C2E760CD6;
        Tue,  1 Jun 2021 05:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: Fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162252660643.4642.2036046472388049283.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 05:50:06 +0000
References: <20210531020048.2920054-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210531020048.2920054-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 31 May 2021 10:00:48 +0800 you wrote:
> Fix some spelling mistakes in comments:
> sevaral  ==> several
> sugestion  ==> suggestion
> unregster  ==> unregister
> suplied  ==> supplied
> cirsumstances  ==> circumstances
> 
> [...]

Here is the summary with links:
  - [net-next] net: sched: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/37f2ad2b9018

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


