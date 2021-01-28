Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25ED2308048
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhA1VKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:10:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231156AbhA1VKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 16:10:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 576DA64DE6;
        Thu, 28 Jan 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611868210;
        bh=DowqKo9gfbes78VknKzpUfMf+fG+DmvWsC6/wBJusa4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m3NhHf30E3NWhKyvdL7kf0VM9D/9B7Dyyvchu2DmKfeSbWorXer+QZhPdgOMP/YXx
         rErGLTQHgS6j8BnISEMc9diVcFcL06W7FhSDDRezppT7rdZ46OFiZh8DGO1UUDlKQz
         TNV5Z0iflLLOOzj++k+mP3QjWGYPbVlTmX33utdd5CsEHCFNP3wUWam2MyGcDtxG0c
         S3eV/cfWiK+6vSHPHzVykBawNecWqmdpX0X0qiF5mhJEXkzYJg2d90/SuUFAmFs+TM
         QTxfvVYApfv4CZ3XMmxJRf/7muFNsSoqpMww6szopJGPzCYypRIx1tBiT2g2WdYT81
         S+eWraSe6JeeA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 52CD76530E;
        Thu, 28 Jan 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] stmmac: intel: Add ADL-S 1Gbps PCI IDs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161186821033.20635.6438134736508926068.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 21:10:10 +0000
References: <20210126085832.3814-1-vee.khee.wong@intel.com>
In-Reply-To: <20210126085832.3814-1-vee.khee.wong@intel.com>
To:     Wong Vee Khee <vee.khee.wong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 26 Jan 2021 16:58:32 +0800 you wrote:
> From: "Wong, Vee Khee" <vee.khee.wong@intel.com>
> 
> Added PCI IDs for both Ethernet TSN Controllers on the ADL-S.
> 
> Also, skip SerDes programming sequences as these are being carried out
> at the BIOS level for ADL-S.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] stmmac: intel: Add ADL-S 1Gbps PCI IDs
    https://git.kernel.org/netdev/net-next/c/88af9bd4efbd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


