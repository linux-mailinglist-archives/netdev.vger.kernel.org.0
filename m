Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E655A306B83
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 04:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhA1DUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 22:20:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbhA1DUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 22:20:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D000164DD3;
        Thu, 28 Jan 2021 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611804010;
        bh=Bq8dHQZ/FmicLc8meZgWI6vIT4+UkodvQ744A/kAzLk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S4u3nhv8maaVbagwIOZfJg0/XCE07fgluMsOodl0SObSXhTL/0rxLJUkPsq82redX
         +8Zz+T6pxUDIG+gXAzHu5JDF5OSdlfzmTD9uUJZFNSSYfsuth0JO7gZegy2CWfY+v1
         HVKePs1FtXScdh64i1Qd8YyoZjmVZ3T0qANRjUsCUST0RJ+ZasGJ+Yp8UEBCQ8vHi4
         q89GiaB+meihPFKJ4T9ykPHr2g0MCLukZN9SykFzlyPWS81hzrMzrQkMh1VYS/vEk9
         5z+7fUC6cHlcXZgN9SyJNoRGKK9jORhDfogkMF8gHLB3eHinl2Y6C3oe/C++9FA54Q
         wo42l5N14M39g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C54A5613AE;
        Thu, 28 Jan 2021 03:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] ibmvnic: Ensure that CRQ entry read are correctly
 ordered
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161180401080.7081.10283880301724892546.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 03:20:10 +0000
References: <20210128013442.88319-1-ljp@linux.ibm.com>
In-Reply-To: <20210128013442.88319-1-ljp@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 27 Jan 2021 19:34:42 -0600 you wrote:
> Ensure that received Command-Response Queue (CRQ) entries are
> properly read in order by the driver. dma_rmb barrier has
> been added before accessing the CRQ descriptor to ensure
> the entire descriptor is read before processing.
> 
> Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [net,v3] ibmvnic: Ensure that CRQ entry read are correctly ordered
    https://git.kernel.org/netdev/net/c/e41aec79e62f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


