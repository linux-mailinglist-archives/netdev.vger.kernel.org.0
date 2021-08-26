Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722103F8491
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 11:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241112AbhHZJbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 05:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241120AbhHZJa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 05:30:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B31E9610CD;
        Thu, 26 Aug 2021 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629970206;
        bh=NyLoSJ+rp2cx5CiOkqrd0r7D0yxRMTkV5vFSeHna51s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CsvvSipvAZ00JTVR01bsKLj0AXWneNXSixcxB5jRTkFC8cYKBvOnhxLKUs6K5xJk/
         PJ6Pr7RYkRF+nJdFT5tdu249clky0LYONZ07lnAzrkEQoXxfwGrv8U21ReMW6ZOz7J
         AEix40zD0oZKXUlqWCSJQNbwmhVegmAc/+c75h2nsF7L/L1LN1qn7IsMTqQh81YewI
         LP7tWynPlFgzmOipziYnUOZhTSKiDnrNzyMqhCQavrTDAQNL91yy/dB8B0eEY7zycJ
         xGojSfQNxg45Yehg3VR1yAxNpIw8Zu/F3FlpE1/0S5KBkOT8fqVO2CYAy0Qjff5/ci
         l0IBrvrU2OL6w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A8F1F60A14;
        Thu, 26 Aug 2021 09:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cxgb4: dont touch blocked freelist bitmap after free
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162997020668.28182.4516840602174292379.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 09:30:06 +0000
References: <1629926982-6393-1-git-send-email-rahul.lakkireddy@chelsio.com>
In-Reply-To: <1629926982-6393-1-git-send-email-rahul.lakkireddy@chelsio.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rajur@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 26 Aug 2021 02:59:42 +0530 you wrote:
> When adapter init fails, the blocked freelist bitmap is already freed
> up and should not be touched. So, move the bitmap zeroing closer to
> where it was successfully allocated. Also handle adapter init failure
> unwind path immediately and avoid setting up RDMA memory windows.
> 
> Fixes: 5b377d114f2b ("cxgb4: Add debugfs facility to inject FL starvation")
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> 
> [...]

Here is the summary with links:
  - [net] cxgb4: dont touch blocked freelist bitmap after free
    https://git.kernel.org/netdev/net/c/43fed4d48d32

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


