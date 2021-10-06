Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4C6423B5F
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 12:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238059AbhJFKWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 06:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229824AbhJFKV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 06:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9089C6113E;
        Wed,  6 Oct 2021 10:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633515607;
        bh=AJtDo5u1fca9E/QnHXFoW07wSpG3oBRucBL795XEgUE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cd89ySXZr2/oUU04QvLyExtSUkalSqzQ105WFvMKIRA2D7sYqjbCp/ywne5BkDdA2
         TLFhL6SxUCMwcRz4aXlENK2AUamk+mPBSaZJQtqjqwqTcleqOqaI21s1ZZEFL1Aurd
         M01TIqGwUz+NNx3w1acOuapjrC1r59Oxg14iFjKZ2yggQnHfhM4jwLdYhOFWV2c/e8
         PLp97T+xhuuG4dLs6UbSOpnWBaiDPWPN/33fuNsFMMlg7uY1r6o3OgkiL3S5qQll+l
         39aweWJfv0ssJzmq3s1aTJOcoWyJCxBghvRbVZENyyqPDCwdNEvnrW++6pYwpffIhg
         OKtSu4W1TYgGQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 82BC560A39;
        Wed,  6 Oct 2021 10:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: stmmac: Turn off EEE on MAC link down
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163351560752.22404.5478730456180115680.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 10:20:07 +0000
References: <20211005115100.1648170-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20211005115100.1648170-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     davem@davemloft.net, Jose.Abreu@synopsys.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, kuba@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        mcoquelin.stm32@gmail.com, michael.wei.hong.sit@intel.com,
        veekhee@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue,  5 Oct 2021 19:50:58 +0800 you wrote:
> This patch series ensure PCS EEE is turned off on the event of MAC
> link down.
> 
> Tested on Intel AlderLake-S (STMMAC + MaxLinear GPY211 PHY).
> 
> Wong Vee Khee (2):
>   net: pcs: xpcs: fix incorrect steps on disable EEE
>   net: stmmac: trigger PCS EEE to turn off on link down
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: pcs: xpcs: fix incorrect steps on disable EEE
    https://git.kernel.org/netdev/net/c/590df78bc7d1
  - [net,2/2] net: stmmac: trigger PCS EEE to turn off on link down
    https://git.kernel.org/netdev/net/c/d4aeaed80b0e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


