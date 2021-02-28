Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A3D327452
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 21:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhB1UKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 15:10:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhB1UKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 15:10:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5383B64E62;
        Sun, 28 Feb 2021 20:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614543007;
        bh=VTxMbI6sYLQmK7Ufzs9WBA6ke0YR6DkhfmBHMiiKyBk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=siChSZK0+1SisaAycvy8M408LqR3K4z93eLSbHboFWVKjFWtea8SCb8veq8XnfLSR
         lKU8YM3YBm8Ex4pOzyTVsLYMOL53LwI7RQwLzeT1kJYH1BL3W/cfqFbSt4PszPOUZR
         e3kZIRwcRllsikCOldKfAiQ5PzURDc1pdOWX5gR4v53UHwiTisbyRR+FhxqE/3Ag4V
         WrGSZ95sl9JeznyEbgEY6JUv3GCP9sFt7u2nkHxQ2FcXptqXwFHFfIWT+0mgHDc3Pa
         aXWPVvTlB+c3ptYgntrlfHCJ5pNN99+eW3tDbnhmWeki0aD0Gzz3mywVgxhFvZy2rw
         mItPDXqYSYjjQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4200E60A2E;
        Sun, 28 Feb 2021 20:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND net 0/3] net: hns3: fixes fot -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161454300726.32190.2129068233849392069.git-patchwork-notify@kernel.org>
Date:   Sun, 28 Feb 2021 20:10:07 +0000
References: <1614410693-8107-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1614410693-8107-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sat, 27 Feb 2021 15:24:50 +0800 you wrote:
> The patchset includes some fixes for the HNS3 ethernet driver.
> 
> Jian Shen (3):
>   net: hns3: fix error mask definition of flow director
>   net: hns3: fix query vlan mask value error for flow director
>   net: hns3: fix bug when calculating the TCAM table info
> 
> [...]

Here is the summary with links:
  - [RESEND,net,1/3] net: hns3: fix error mask definition of flow director
    https://git.kernel.org/netdev/net/c/ae85ddda0f1b
  - [RESEND,net,2/3] net: hns3: fix query vlan mask value error for flow director
    https://git.kernel.org/netdev/net/c/c75ec148a316
  - [RESEND,net,3/3] net: hns3: fix bug when calculating the TCAM table info
    https://git.kernel.org/netdev/net/c/b36fc875bcde

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


