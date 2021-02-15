Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03DE31C451
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 00:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhBOXVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 18:21:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhBOXUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 18:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EDD0F64DFF;
        Mon, 15 Feb 2021 23:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613431209;
        bh=oQbb3evrA285L4t9BGd0Ozz2M8h/C+H1HCLVVIAeI1k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cynwLe2QlDDowPswtPiv4Xm5oTlL0UFZiYnKylIWK45VeVGWEkuoAX+gLXriv8ZU0
         KvUhMfsoprZZve31UeGR6KMS2y18xOm3dLMDhWJ0MFZuUnlw2ElQTSDmR6f+CY6C+v
         JeOAboY82tkCbru3VhzXvQBBfDe4LewEbZtQ3QlbPwX0gT6jM820L/Qwu4u4LVcDeu
         JRSOEdS93YaNPb9bHy9q8exQiF0W0UX4cxleDjoQfi80tKIHgguV8Q68vGDOo1Dlbn
         OLEWsKVwFT61bqWVya9Ypi5+eVL58Q+RIhwFkU9/qDvjE5Pqo3StEVB+nf2ycBPhGk
         K6oliGhxhtCXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E8F8E609D9;
        Mon, 15 Feb 2021 23:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ibmvnic: substitute mb() with dma_wmb() for
 send_*crq* functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161343120894.10830.14435353533722569645.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 23:20:08 +0000
References: <20210213023646.55955-1-ljp@linux.ibm.com>
In-Reply-To: <20210213023646.55955-1-ljp@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com,
        tlfalcon@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Feb 2021 20:36:46 -0600 you wrote:
> The CRQ and subCRQ descriptors are DMA mapped, so dma_wmb(),
> though weaker, is good enough to protect the data structures.
> 
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> Acked-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] ibmvnic: substitute mb() with dma_wmb() for send_*crq* functions
    https://git.kernel.org/netdev/net-next/c/1a42156f52bd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


