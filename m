Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D92B45F530
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbhKZTbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:31:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38209 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237248AbhKZT3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:29:51 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A0ACB82878;
        Fri, 26 Nov 2021 19:20:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id A903E601FA;
        Fri, 26 Nov 2021 19:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637954409;
        bh=mtS8SRa+ogqmiJChg46cP6dNj9fmgRMyeQnLcTVaC6U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O2IHPRxlKPIssPd+gVSg1wmsQOTUXCNp0DCqAYoVlXwMHLWyIvfDm7MlFD4rH/kAv
         sDbgygT/V3+lMfht5CENtNsLcauvjkJT351npggZsMnJPVN0CNOquSCZtfIXkg6qqC
         QZbqTJepAtD/pTQv6DP/nWnETS4GrHgMVSNU+8qsmeE2inFMRqOiYW1czNz5r5BIBs
         cKdt7iAuy32ufnmfinQGmepbz6Mol4+ZuFkBA5wK1FO22r4dWzuuVGxA/d+gbuMDtQ
         p9LYZFjhdrJKvMfk7/pnhWH8sLWHVKE1S0i+srEOuPGJgHq6HlHoOcPaAePGpTVwUx
         ZaWfgs9jaegmQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9BA4D60A4E;
        Fri, 26 Nov 2021 19:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: virtual_ncidev: change default device permissions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163795440963.10734.4124366092965219674.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 19:20:09 +0000
References: <20211125141457.716921-1-cascardo@canonical.com>
In-Reply-To: <20211125141457.716921-1-cascardo@canonical.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        krzysztof.kozlowski@canonical.com, bongsu.jeon@samsung.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Nov 2021 11:14:57 -0300 you wrote:
> Device permissions is S_IALLUGO, with many unnecessary bits. Remove them
> and also remove read and write permissions from group and others.
> 
> Before the change:
> crwsrwsrwt    1 0        0          10, 125 Nov 25 13:59 /dev/virtual_nci
> 
> After the change:
> crw-------    1 0        0          10, 125 Nov 25 14:05 /dev/virtual_nci
> 
> [...]

Here is the summary with links:
  - nfc: virtual_ncidev: change default device permissions
    https://git.kernel.org/netdev/net/c/c26381f97e2a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


