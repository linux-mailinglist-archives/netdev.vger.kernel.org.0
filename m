Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D8D310310
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 04:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhBEDAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 22:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229692AbhBEDAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 22:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7DA3664FBA;
        Fri,  5 Feb 2021 03:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612494008;
        bh=FsNerPmnz8K8GWtpKxL80ZpjieweZcDoX15J4p9yH6c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MkOBjCGopYHcaFIIquWSBPuWLUexqKJzT/s48XHSE/NqziwCC0RVXhm/0Qvp1VfpS
         S48qRey7DkcJTwgLtDkQHWFBT5Ox11cM52Tc4fnUCzXf5y3Bc45Dl5oXSRj/t1hGq8
         FRWux1c/4CslnTCcMeaMhyd2bmkyHRxXH6QZ2l0YTfDuDalCQI1nnrEGbebPqHFw+6
         luEI8a+3m0qq52MzLQlf/+UC7IOs37hX+5sUuOfoZUKhJuce3D3v7BJrhsbi7lmCoE
         r+kRQ8Rr9zWPqe7lKS1dfNLV1Ezxo38bLRStwSrheCLrMdTTCG4nIrRtZqzZsRfhqf
         TQkbw+rp/aSXQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 624D3609F3;
        Fri,  5 Feb 2021 03:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hns3: avoid -Wpointer-bool-conversion warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249400839.18283.1348642498392879785.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 03:00:08 +0000
References: <20210204153813.1520736-1-arnd@kernel.org>
In-Reply-To: <20210204153813.1520736-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, huangguangbin2@huawei.com,
        tanhuazhong@huawei.com, arnd@arndb.de, moyufeng@huawei.com,
        shenjian15@huawei.com, liuyonglong@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  4 Feb 2021 16:38:06 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang points out a redundant sanity check:
> 
> drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:497:28: error: address of array 'filp->f_path.dentry->d_iname' will always evaluate to 'true' [-Werror,-Wpointer-bool-conversion]
> 
> This can never fail, so just remove the check.
> 
> [...]

Here is the summary with links:
  - net: hns3: avoid -Wpointer-bool-conversion warning
    https://git.kernel.org/netdev/net-next/c/8f8a42ff003a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


