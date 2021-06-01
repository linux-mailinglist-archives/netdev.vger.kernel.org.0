Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4F1397CD4
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 01:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbhFAXBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 19:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234656AbhFAXBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 19:01:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F15E1613BC;
        Tue,  1 Jun 2021 23:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622588403;
        bh=tbqCPYrPXuGVLzNNNZFMxmyWcRmpu8AG1sQfIicFoq8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tJpyGTBZt9ZKeMnd2wlkLnKlqJVrus7LULc1RVwAEVJ/fV8y5oWZP0nMRG8gFlWzj
         W4Ww2MYBz5hKnlj+Yk941R8cLacHGXzU5DkElWwJ8oGeN/VIbZmjoNg0Th/GoQOhJ7
         7ZdV1PvOgYiLUH6QI764+fYi7/rnwublpxhAqC73u7Q1gkFiWWxlrXqt13HFtYVmep
         JCJVbrD5jLxA6SPoeidotIVPwhM/HMW1VTiOAeV3I0h12OLQ6E8uf3rSnsKHCgm3J2
         tJFy8TKMspLMcw+COSUiycPOOHiaNicfop56Yu7ewCWWjWffZGYY2dPbepLPDWYtub
         tDFPd8S2VH3qQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E35FC60A47;
        Tue,  1 Jun 2021 23:00:02 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: myri10ge: Fix missing error code in
 myri10ge_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162258840292.25475.8812296337772071436.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 23:00:02 +0000
References: <1622545491-18706-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1622545491-18706-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     christopher.lee@cspi.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  1 Jun 2021 19:04:51 +0800 you wrote:
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'status'.
> 
> Eliminate the follow smatch warning:
> 
> drivers/net/ethernet/myricom/myri10ge/myri10ge.c:3818 myri10ge_probe()
> warn: missing error code 'status'.
> 
> [...]

Here is the summary with links:
  - ethernet: myri10ge: Fix missing error code in myri10ge_probe()
    https://git.kernel.org/netdev/net/c/f336d0b93ae9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


