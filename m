Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EBC2E21D5
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 22:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgLWVAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 16:00:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgLWVAq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 16:00:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 85565224B1;
        Wed, 23 Dec 2020 21:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608757206;
        bh=yhzxiJd4hgztG7awmhk1MMg0dvOXUhAS4fgVddXEHJA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HjLstbdtRZpyZLCTHLD8YzdWT9tZAPVFH98jmAxxNeI93ngSV4a8zmpS8SrlcNrGE
         uy2Is63c9QMC7vtkUsxu6oouFCBQY2Kn0xT1nIzH/MTQwFAPu6l/i/emKZMXs32gkf
         hQyngd94ONNVTHAoZwHg0806jbNKTCCpLJIwRfoCYem8yf621WTJhh6q8Y2ZLRxy2X
         TL6pWMUVfbbNj0NXwO2OpZbw9QJHWUK69KE7DleQe+3wfSkn5scxjCJiW9CwK0iYj/
         wYDXwIoWcsZ2KFdxx95qQKTJH//mQWxIR++JxuVhYAZaJUSAz1ZO4VrgbvvYmcUw79
         2Jtjb6kCgZh3g==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 7C9F6604E9;
        Wed, 23 Dec 2020 21:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ibmvnic: continue fatal error reset after passive init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160875720650.3668.9679522106628985157.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Dec 2020 21:00:06 +0000
References: <20201223204904.12677-1-ljp@linux.ibm.com>
In-Reply-To: <20201223204904.12677-1-ljp@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 23 Dec 2020 14:49:04 -0600 you wrote:
> Commit f9c6cea0b385 ("ibmvnic: Skip fatal error reset after passive init")
> says "If the passive
> CRQ initialization occurs before the FATAL reset task is processed,
> the FATAL error reset task would try to access a CRQ message queue
> that was freed, causing an oops. The problem may be most likely to
> occur during DLPAR add vNIC with a non-default MTU, because the DLPAR
> process will automatically issue a change MTU request.
> Fix this by not processing fatal error reset if CRQ is passively
> initialized after client-driven CRQ initialization fails."
> 
> [...]

Here is the summary with links:
  - [net,v2] ibmvnic: continue fatal error reset after passive init
    https://git.kernel.org/netdev/net/c/1f45dc220667

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


