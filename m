Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F16134260E
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhCSTUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230317AbhCSTUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 15:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 99AE76197D;
        Fri, 19 Mar 2021 19:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616181608;
        bh=PNkTSEghEcOf9NjNWigmEqIl/yfal6hUAgzyXb6NDYk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t0Fe1ZSBKdkGt1WvCOCA79P9YHwZt9pcJNBdYNs83v8TP6hFV1IPoAomk7oIhTaMK
         jBtO12Wm6iT7yRx9iw6/ClgvfSDRse8PgvLVzI1GfzWlchSvh4R1ux/5YwPubR7FCA
         Eu7nl2yntcXHlCFLIVSjcNqwfuFxrAo4A33gLb2z8bidcog/9LZAceCJYbzoXO1q5r
         Z778df/uxdMpTMVJQwvCaljMnsUH2XoMnc3tT5cdlErw/Ek3n45j3Z4xpYOkvm9tn0
         4oqJIkgOj0qo26hHtK3llcxs6+dR5vZov3Rd2s4eDaqBmlsQ4dmlA3uuRJUSb3Ksvm
         HdC3k/LQxpvTQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8B17A626EC;
        Fri, 19 Mar 2021 19:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: enetc: teardown CBDR during PF/VF unbind
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618160856.4810.10350179822019482861.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 19:20:08 +0000
References: <20210319100806.801581-1-olteanv@gmail.com>
In-Reply-To: <20210319100806.801581-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        michael@walle.cc, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 19 Mar 2021 12:08:06 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Michael reports that after the blamed patch, unbinding a VF would cause
> these transactions to remain pending, and trigger some warnings with the
> DMA API debug:
> 
> $ echo 1 > /sys/bus/pci/devices/0000\:00\:00.0/sriov_numvfs
> pci 0000:00:01.0: [1957:ef00] type 00 class 0x020001
> fsl_enetc_vf 0000:00:01.0: Adding to iommu group 19
> fsl_enetc_vf 0000:00:01.0: enabling device (0000 -> 0002)
> fsl_enetc_vf 0000:00:01.0 eno0vf0: renamed from eth0
> 
> [...]

Here is the summary with links:
  - [net-next] net: enetc: teardown CBDR during PF/VF unbind
    https://git.kernel.org/netdev/net-next/c/c54f042dcc1b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


