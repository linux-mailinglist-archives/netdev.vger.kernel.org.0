Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566DD3FA57A
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhH1La6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233917AbhH1La5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 07:30:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9FB9360EB5;
        Sat, 28 Aug 2021 11:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630150207;
        bh=wmCydiTt0vZ8cbsJDl6IW9QIpk2wUuBKqrV52yRlU7w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ajEWHm+LSTon1mrKBmAWMx93TB7u4J5ZUqv5nNv4AcEQfOHdHa5W5y78XGjRn+A+M
         6/hQxmn/iSl6ldKkYcHJvtXNOvGXjSkERID92ZrQt5Ne+5PosxlM+rhLrXHQi3OZsG
         djVwKuVGBwHzwk898Yxy7TnJI7RAQXQI8AhW6INsRHHVbd0yT2krH/05hLjA4D/N8l
         TFDF9115BEXhhkJlMY/rxdXYBLMnz+8KZJnL+Gh3fNHZzjPFeOVMgqRq/OaKnFWcl3
         LrLzEMvS+ed8GAYSuXO/vKK8JZZOIlBN0skPh+rByFICO1/ODc2bnmtf8uPwsc1Ere
         vX2HaNOQIPyNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9206160A44;
        Sat, 28 Aug 2021 11:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] ionic: queue mgmt updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163015020759.6002.148977781720312776.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Aug 2021 11:30:07 +0000
References: <20210827185512.50206-1-snelson@pensando.io>
In-Reply-To: <20210827185512.50206-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, jtoppins@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 27 Aug 2021 11:55:06 -0700 you wrote:
> The first pair of patches help smooth the driver's response when
> the firmware has gone through a recovery/reboot cycle.
> 
> The next four patches take care of a couple things seen when
> changing the interface status.
> 
> Shannon Nelson (6):
>   ionic: fire watchdog again after fw_down
>   ionic: squelch unnecessary fw halted message
>   ionic: fill mac addr earlier in add_addr
>   ionic: add queue lock around open and stop
>   ionic: pull hwstamp queue_lock up a level
>   ionic: recreate hwstamp queues on ifup
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] ionic: fire watchdog again after fw_down
    https://git.kernel.org/netdev/net-next/c/d3e2dcdb6853
  - [net-next,2/6] ionic: squelch unnecessary fw halted message
    https://git.kernel.org/netdev/net-next/c/970dfbf428c4
  - [net-next,3/6] ionic: fill mac addr earlier in add_addr
    https://git.kernel.org/netdev/net-next/c/92c90dff687f
  - [net-next,4/6] ionic: add queue lock around open and stop
    https://git.kernel.org/netdev/net-next/c/af3d2ae11443
  - [net-next,5/6] ionic: pull hwstamp queue_lock up a level
    https://git.kernel.org/netdev/net-next/c/7ee99fc5ed2e
  - [net-next,6/6] ionic: recreate hwstamp queues on ifup
    https://git.kernel.org/netdev/net-next/c/ccbbd002a419

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


