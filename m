Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C26472C6C
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 13:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbhLMMkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 07:40:13 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50766 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236836AbhLMMkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 07:40:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3BB42CE0FBC
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F91EC34601;
        Mon, 13 Dec 2021 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639399209;
        bh=7inncrS1ovFB/nWdID+NXALz1+MAADJGmrRdTVID+Ok=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r1ui147RVUETqnEkNtst4eGlg7FI+Q7g9wWyOF3dSoSyo5k2HHcNDjih68vIZvZgt
         1VemQE/3GUL9iROUw8Xn2x4qDanVc2YrECgZMvqNvfqwIoJBEfHfPGKNq1kVcoPO5S
         q8ObGbk/tJaWdp3I/JG1390bCdjHynz8ySBmUPOE+ma0aNqk5mK8m+6OQaobePeB8F
         cSqfv+Q0WwkmZbdvLVIRq5bqHUq8Vi+G17uAXAIRyQDDeDO2O4v/nUAezhngm3hAXN
         q1L6gJTx9o83p66idn2athPz8UcgHZVlWBROvtxwlrGsTDOXZ5ekISjY4+qJzKYllE
         VpdM2duxzAG+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 441BC6098C;
        Mon, 13 Dec 2021 12:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: sch_ets: don't remove idle classes from the
 round-robin list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163939920927.24922.3964935540490898267.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 12:40:09 +0000
References: <e08c7f4a6882f260011909a868311c6e9b54f3e4.1639153474.git.dcaratti@redhat.com>
In-Reply-To: <e08c7f4a6882f260011909a868311c6e9b54f3e4.1639153474.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, shuali@redhat.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Dec 2021 17:42:47 +0100 you wrote:
> Shuang reported that the following script:
> 
>  1) tc qdisc add dev ddd0 handle 10: parent 1: ets bands 8 strict 4 priomap 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
>  2) mausezahn ddd0  -A 10.10.10.1 -B 10.10.10.2 -c 0 -a own -b 00:c1:a0:c1:a0:00 -t udp &
>  3) tc qdisc change dev ddd0 handle 10: ets bands 4 strict 2 quanta 2500 2500 priomap 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3
> 
> crashes systematically when line 2) is commented:
> 
> [...]

Here is the summary with links:
  - [net] net/sched: sch_ets: don't remove idle classes from the round-robin list
    https://git.kernel.org/netdev/net/c/c062f2a0b04d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


