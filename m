Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC5141AF12
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240789AbhI1Mb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240710AbhI1Mbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:31:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 99D0A61215;
        Tue, 28 Sep 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632832208;
        bh=i4wgzOUu7apIAnF5yKSN8IPgeFVwu12j32BHaG+rktU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nEDLNg1sO++I6pW78sVFA6Iyhk54vFwBVM59DP2rvfKMktBrdqblvNvXWRAhjoLCw
         +XUmbpvdhJRw+kIHJp/kv0DR9WQHN/PPQRRbzJvm4nufgO56o+VTZLhjotPps+uPkc
         BTKlh4o864M+un5WV2i/7DgGURoKRiF8GzjsCMcRJWfSRXW2kZnVQQOIbPA0xsgWzF
         7Py7RnkpEvdoDAEShRSt3TLWX1NbPR+veGA3OQbbdsMDY+jUad7j5cMtEGHwcFv/SR
         hZw+4uZ0k5a+7V6jJ+u4WzWa9IEyjcXXeocknDue2I85fTdcrxAvQNf7A1dP6E2ZeS
         nU6EXlxHDHHEw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 92E5960A69;
        Tue, 28 Sep 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/tls: support SM4 CCM algorithm
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283220859.6805.14594158516937512105.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 12:30:08 +0000
References: <20210928062843.75283-1-tianjia.zhang@linux.alibaba.com>
In-Reply-To: <20210928062843.75283-1-tianjia.zhang@linux.alibaba.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 28 Sep 2021 14:28:43 +0800 you wrote:
> The IV of CCM mode has special requirements, this patch supports CCM
> mode of SM4 algorithm.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  include/net/tls.h |  3 ++-
>  net/tls/tls_sw.c  | 20 ++++++++++++++++----
>  2 files changed, 18 insertions(+), 5 deletions(-)

Here is the summary with links:
  - net/tls: support SM4 CCM algorithm
    https://git.kernel.org/netdev/net-next/c/128cfb882e23

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


