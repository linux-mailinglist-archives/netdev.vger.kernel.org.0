Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB5C41AFE6
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 15:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240938AbhI1NVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 09:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240576AbhI1NVp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 09:21:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C723611C3;
        Tue, 28 Sep 2021 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632835206;
        bh=9Pa+V8+255FRuA+BDCRMbmE6rEpSEgwCkXnCN0iZZ0o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D+O3iCpCPRCRfJgKwhPYDR2uu3Q7dPTz4TxE5vd9W/kqSNJBOBYaCjyus3CB4yO5Q
         o5ybyP64o8hw8+yNvQvHjgsOqL/AUIPDji3VN7S6GBS8Za4qHD50ks/o3esgEcY3ZV
         JRVVwMFD552hYch0kD7unU7HkuqqVU3dAm1DWkK/gPfhVIUtFNnVCqMva97TFrXjb4
         MScM26Q/lYEzBpY9C9cA04WhgINZSAKsERa/PhmcegrTDCvhBarXNi6l0J2ZlhfF7m
         jW0hmOTtSZE7bcRrO3lBpjeR/3QOu/PzRd29fC1j4/Uf8AtqCJ6Gl7d6BpjaVlI0oP
         uoT1sotDdODVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7399A60A69;
        Tue, 28 Sep 2021 13:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v3 PATCH] octeontx2-pf: Use hardware register for CQE count
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283520646.29265.11641226830844674997.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 13:20:06 +0000
References: <20210928055526.19286-1-gakula@marvell.com>
In-Reply-To: <20210928055526.19286-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 28 Sep 2021 11:25:26 +0530 you wrote:
> Current driver uses software CQ head pointer to poll on CQE
> header in memory to determine if CQE is valid. Software needs
> to make sure, that the reads of the CQE do not get re-ordered
> so much that it ends up with an inconsistent view of the CQE.
> To ensure that DMB barrier after read to first CQE cacheline
> and before reading of the rest of the CQE is needed.
> But having barrier for every CQE read will impact the performance,
> instead use hardware CQ head and tail pointers to find the
> valid number of CQEs.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] octeontx2-pf: Use hardware register for CQE count
    https://git.kernel.org/netdev/net-next/c/af3826db74d1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


