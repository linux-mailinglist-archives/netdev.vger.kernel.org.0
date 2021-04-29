Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A51736F2AF
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 00:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhD2WlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 18:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229832AbhD2Wk6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 18:40:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 610FE61468;
        Thu, 29 Apr 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619736010;
        bh=c+eXr4EiGx0pNDVRYuXh7BbsN9NwutqoMO3Ik0LVDTQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gOYqxZA4AtYXLeHdrW9GpUTWcRUcVNBMksCSXbxQz8VF5GVXWgfwiUnqpSuhspWpL
         m0t+n4pPk+gCDWUTNtU6+CxeXtITCy7sc6dgMNrcbryvFV+Qbyb6iOeuoBYwtTfcyO
         AMordkPsMzzaLH/eZ30nCkw3CY32mqnmvsFNbCcgBBXAE2f0q2WrLEYx21reOmvjZK
         K30mOFmdkMqpREs6xvKYxmH7Swmj6BPM4yW+gpyWSmKzXxWI1F9sdo+QASlfL/kVRi
         XJrFRx+LkWebqFQEsN6OLajNYkna06rnUXwvJcZnE47lqwXaEdtVz7AToYQfcUfK+O
         XjgE7pb+p1JVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 52FA160A3A;
        Thu, 29 Apr 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: Remove redundant assignment to err
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161973601033.15907.10908329531191250352.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Apr 2021 22:40:10 +0000
References: <1619659956-9635-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1619659956-9635-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 29 Apr 2021 09:32:36 +0800 you wrote:
> Variable 'err' is set to -ENOMEM but this value is never read as it is
> overwritten with a new value later on, hence the 'If statements' and
> assignments are redundantand and can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> net/ipv6/seg6.c:126:4: warning: Value stored to 'err' is never read
> [clang-analyzer-deadcode.DeadStores]
> 
> [...]

Here is the summary with links:
  - net: Remove redundant assignment to err
    https://git.kernel.org/netdev/net/c/1a70f6597d5f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


