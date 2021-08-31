Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4998F3FC670
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241466AbhHaLLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241413AbhHaLLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 07:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A3E161041;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630408208;
        bh=KpGv2quDoLVdaX43kOv7Z1379XKKaRvB6/GLJ7iIgfw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n5GRC+nXFWqp0NA1qRsdG7mbb1AabyvAlfhsHLBuSfrOuKOMOCVRuKM6t/FBWhOJy
         xgrIOfyya/tWTssbhSDB0MC9wN+Vw01YMo8ZV0Xf3RsnGaceMCsQKmSqWZkMwNh+c9
         +EsnfAmBLRmOCJduTaJB8DDms1cXRWKHxduG8ThxX8k28KyAaORMHNuASRrwMukGhO
         crKQVFhW+MkqHRzQXpPimh0MOgeEfETJPnb85PBNwKY5adBvgsu5bGekUJrGjWlOa2
         nWqzmYRSZwag8D6Rg1qrxdyU/jo0ArXyYwDnsYQliVjSepJm8x/OWbvqt2pX3daNEm
         j4xVCD34AFzGA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 450976097A;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/mlxbf_gige: Make use of
 devm_platform_ioremap_resourcexxx()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163040820827.5377.9489080405038587654.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Aug 2021 11:10:08 +0000
References: <20210831080231.878-1-caihuoqing@baidu.com>
In-Reply-To: <20210831080231.878-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gsomlo@gmail.com,
        asmaa@nvidia.com, limings@nvidia.com, jgg@ziepe.ca,
        davthompson@nvidia.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 31 Aug 2021 16:02:31 +0800 you wrote:
> Use the devm_platform_ioremap_resource_byname() helper instead of
> calling platform_get_resource_byname() and devm_ioremap_resource()
> separately
> 
> Use the devm_platform_ioremap_resource() helper instead of
> calling platform_get_resource() and devm_ioremap_resource()
> separately
> 
> [...]

Here is the summary with links:
  - net/mlxbf_gige: Make use of devm_platform_ioremap_resourcexxx()
    https://git.kernel.org/netdev/net-next/c/464a57281f29

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


