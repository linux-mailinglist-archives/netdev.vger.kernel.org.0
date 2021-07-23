Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08983D3DDB
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhGWQJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230455AbhGWQJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 12:09:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4547360ED7;
        Fri, 23 Jul 2021 16:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627059006;
        bh=kiWGOkhc3zgy7L4+RPW7dnvOcviuFynB6jHjAfzYQew=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WhKA+/db33Ds4tqI9Zg308hSbpSkhStW/Lmx3sSxO1EZFHCkdUWbbKaq24fmFkhYi
         eYsP4+OZLe9XXT3ZHbQvMyxxJxuCG428ypWPhmHodYvJyH5IFNMVOVliOSU2jVMUaW
         solhQQRYFXaOdmJ0Uixlx9iX/J9Q1t2i5Vdc6kZyVE7YEnFlHBCR585Ey1SKQv+9J8
         +l98K55nBX4NgFXtH2absKAwDu0/Uar5RQQbI3nh1X5kuZqgdy/BYhwIIaUkaS/V0w
         lgGtonf73ZA73PhPu0CFnRc1X/hQVxRx0HCDeLSeCHwXc9IgLxxFguseZwxnvUP9MP
         mQe33iFUdzO5A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3A2CC6097B;
        Fri, 23 Jul 2021 16:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] NIU: fix incorrect error return, missed in previous revert
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705900623.21133.2170386714685422391.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 16:50:06 +0000
References: <20210723151304.1258531-1-paul@jakma.org>
In-Reply-To: <20210723151304.1258531-1-paul@jakma.org>
To:     Paul Jakma <paul@jakma.org>
Cc:     netdev@vger.kernel.org, kjlu@umn.edu, shannon.lee.nelson@gmail.com,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Jul 2021 16:13:04 +0100 you wrote:
> Commit 7930742d6, reverting 26fd962, missed out on reverting an incorrect
> change to a return value.  The niu_pci_vpd_scan_props(..) == 1 case appears
> to be a normal path - treating it as an error and return -EINVAL was
> breaking VPD_SCAN and causing the driver to fail to load.
> 
> Fix, so my Neptune card works again.
> 
> [...]

Here is the summary with links:
  - NIU: fix incorrect error return, missed in previous revert
    https://git.kernel.org/netdev/net/c/15bbf8bb4d4a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


