Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEED40C3A0
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbhIOKbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232307AbhIOKbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 06:31:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 88CFA61268;
        Wed, 15 Sep 2021 10:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631701813;
        bh=O8YAqVYLFad566aHABtAFYceMxe7upnunVpfLKPh+dw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n0zWvtjAi99U/8qz4jgf8W8THjjK8FeX48YwvwH/qlQlwyOb20sW8on/UJDcn2Y3Z
         stcMg1wcRdLkrrH8zC8bfWRmk/6N9mPBNvM2EFt8Y1Exu7tGY5GTJ/yZYLm49DWt8s
         +v3k0xsrJwG2IyaRuEqs8HMZ1b1qrEsS0OJXCXE39FSmywdRuePEdE7K91AfvGzIkr
         0xoE7OAtrHpKoSlbAkfjIPvVG+JCJO8/iONR+M2q1GYi1kBojSSgG+hKM1WBKnWxkt
         z321a12NG0XnBeSTURr/cPwjahw0u2rcFVzakfy/QG2Oe86T9wMahRohDyfj849HDZ
         uxsm7EyFLIhhw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7DE7860A9E;
        Wed, 15 Sep 2021 10:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next RESEND v2 0/9] ibmvnic: Reuse ltb, rx, tx pools
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163170181351.3937.8766296625890221115.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Sep 2021 10:30:13 +0000
References: <20210915035259.355092-1-sukadev@linux.ibm.com>
In-Reply-To: <20210915035259.355092-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, brking@linux.ibm.com,
        cforno12@linux.ibm.com, drt@linux.ibm.com, ricklind@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 14 Sep 2021 20:52:50 -0700 you wrote:
> It can take a long time to free and reallocate rx and tx pools and long
> term buffer (LTB) during each reset of the VNIC. This is specially true
> when the partition (LPAR) is heavily loaded and going through a Logical
> Partition Migration (LPM). The long drawn reset causes the LPAR to lose
> connectivity for extended periods of time and results in "RMC connection"
> errors and the LPM failing.
> 
> [...]

Here is the summary with links:
  - [net-next,RESEND,v2,1/9] ibmvnic: Consolidate code in replenish_rx_pool()
    https://git.kernel.org/netdev/net-next/c/38106b2c433e
  - [net-next,RESEND,v2,2/9] ibmvnic: Fix up some comments and messages
    https://git.kernel.org/netdev/net-next/c/0f2bf3188c43
  - [net-next,RESEND,v2,3/9] ibmvnic: Use/rename local vars in init_rx_pools
    https://git.kernel.org/netdev/net-next/c/0df7b9ad8f84
  - [net-next,RESEND,v2,4/9] ibmvnic: Use/rename local vars in init_tx_pools
    https://git.kernel.org/netdev/net-next/c/8243c7ed6d08
  - [net-next,RESEND,v2,5/9] ibmvnic: init_tx_pools move loop-invariant code
    https://git.kernel.org/netdev/net-next/c/0d1af4fa7124
  - [net-next,RESEND,v2,6/9] ibmvnic: Use bitmap for LTB map_ids
    https://git.kernel.org/netdev/net-next/c/129854f061d8
  - [net-next,RESEND,v2,7/9] ibmvnic: Reuse LTB when possible
    https://git.kernel.org/netdev/net-next/c/f8ac0bfa7d7a
  - [net-next,RESEND,v2,8/9] ibmvnic: Reuse rx pools when possible
    https://git.kernel.org/netdev/net-next/c/489de956e7a2
  - [net-next,RESEND,v2,9/9] ibmvnic: Reuse tx pools when possible
    https://git.kernel.org/netdev/net-next/c/bbd809305bc7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


