Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5F83092D5
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhA3JEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:04:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229763AbhA3FAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 00:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 88C4964E19;
        Sat, 30 Jan 2021 05:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611982807;
        bh=vTsWs07z7NR0Q31Kwlupd5QohA2HU5+KPN1Kh7kWUpM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gR2/XnnYLEa5yCHWaOAF9Dh7AtiQQ1l1nOnfqNDxPIxU37wVdAdVZFXr5rGx/+UEi
         sJMFxRj1EXUpLCPl84bxkryQ+ioptRnwl7BU/ZaNsTdxIF/Neyc9S7zL3/hEYNIzJe
         9mzFTbeuEq14MZCDVo+xBjr1HWTOY+tI4zEiiGzYzTaEdWf5FrZgRBWsfpWjTrhbK6
         JJqQQGACjViCw8mNsQWDYlqUu//PMAzZ4oueY4buBWdeYnSg1fpSZmb/dVXCbOtm+k
         3pABCT+Juv5syF+QR4PbVe+9i4KpF90h4bZbBW1tai8fOyNlFoAqxSMrJXpED7lSla
         +INTrzdOQDE6Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8054660984;
        Sat, 30 Jan 2021 05:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/2] net: hns3: updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161198280752.18955.6534854856349471820.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jan 2021 05:00:07 +0000
References: <1611834696-56207-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1611834696-56207-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com, kuba@kernel.org,
        huangdaode@huawei.com, linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 28 Jan 2021 19:51:34 +0800 you wrote:
> This patchset adds dump tm info of nodes, priority and qset in debugfs.
> Three debugfs files tm_nodes, tm_priority and tm_qset are created in
> new tm directory, and use cat command to dump their info, for examples:
> 
> $ cat tm_nodes
>        BASE_ID  MAX_NUM
> PG         0         8
> PRI        0         8
> QSET       0         8
> QUEUE      0      1024
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/2] net: hns3: add interfaces to query information of tm priority/qset
    https://git.kernel.org/netdev/net-next/c/2bbad0aa40e1
  - [V2,net-next,2/2] net: hns3: add debugfs support for tm nodes, priority and qset info
    https://git.kernel.org/netdev/net-next/c/04987ca1b9b6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


