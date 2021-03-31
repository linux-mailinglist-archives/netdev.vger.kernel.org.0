Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743DC3509A9
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 23:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhCaVkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 17:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232856AbhCaVkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 17:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 40E4C60FE8;
        Wed, 31 Mar 2021 21:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617226808;
        bh=P5s1HGLY84mZy67Y959Tw7d9Yz9pEcPDhBsTOSZgKCw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ayqBAkEZfS8dppa4he1YYpr3MjnEB44/78aVmc6JVrZ3TVoKGas9hFjL8crfs55VB
         8DuzUYADLRSbGYv+59pnE9z2yQtGSFgnEGCuS62n5+FU0uz5KS0aOE5loOzMgSrFxf
         p55kuCvGw+9jgMiOyISdaM1Ll0R2+bp3rUeqcHR/CPNMKqKvOc7fZYrFYuj5q46n9D
         kcvvljIwCshOB6j7s8rfD4jftOuPpxYYSob9q2YEb67yy9qR2/3cIW+IUGXUVWVbVy
         WNrxlQIomgnbweBSVTZIxyYXIKIKPxCGIzgolanDMw4n/7Ar7ZaAYfgUsXCdQa+lX/
         SjPlrOTGit1qg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3120E60283;
        Wed, 31 Mar 2021 21:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qrtr: Convert qrtr_ports from IDR to XArray
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722680819.17862.17453967388507390845.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 21:40:08 +0000
References: <20210331043643.959675-1-willy@infradead.org>
In-Reply-To: <20210331043643.959675-1-willy@infradead.org>
To:     Matthew Wilcox (Oracle) <willy@infradead.org>
Cc:     bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        ebiggers@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 31 Mar 2021 05:36:42 +0100 you wrote:
> The XArray interface is easier for this driver to use.  Also fixes a
> bug reported by the improper use of GFP_ATOMIC.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/qrtr/qrtr.c | 42 ++++++++++++++----------------------------
>  1 file changed, 14 insertions(+), 28 deletions(-)

Here is the summary with links:
  - qrtr: Convert qrtr_ports from IDR to XArray
    https://git.kernel.org/netdev/net-next/c/3cbf7530a163

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


