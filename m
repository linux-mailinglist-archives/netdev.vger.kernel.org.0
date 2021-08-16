Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDE23ED1A7
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbhHPKKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229741AbhHPKKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:10:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B1CED61BA9;
        Mon, 16 Aug 2021 10:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629108605;
        bh=x7jsrHvrjjPLpjpYi6DdNrOCHbwoBUewPPbMYvYCnd0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K3A3FFuNROwAxOIXfVWMe5Ay+xgX20j2lA8mbDvjeiAez7bvzJXY5TOOLew785pSU
         LeXeb9xTcVVTE/I8nIAIFd4bTOnqdT6nVfWmnJpOZNR0RD9dNnRxVR0Gkud3dQYNR9
         uGWqlbQ61vNbrP87o1E8EV+f4f0DKMMryc2yKUipQyAWKa2Ex6ojMcuS2bxaiBClpz
         E788DZEZDHhJTjHrLtssqy1bkubL730QjzT1Ml3aRntdRfCpGVTGQJUOd9PELy4MYj
         3o1lhgFkw8ayDX8TCApNg3tldoYpcX05YIVHcHetd5DnAY0Ye+laFh3qferpgCLlm2
         ZvYHxibH+SJuA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB543609CF;
        Mon, 16 Aug 2021 10:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: pcs: xpcs: Add Pause Mode support for SGMII
 and 2500BaseX
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910860569.22499.14682043682217951395.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:10:05 +0000
References: <20210813021129.1141216-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210813021129.1141216-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        kuba@kernel.org, davem@davemloft.net, linux@armlinux.org.uk,
        vladimir.oltean@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 13 Aug 2021 10:11:29 +0800 you wrote:
> SGMII/2500BaseX supports Pause frame as defined in the IEEE802.3x
> Flow Control standardization.
> 
> Add this as a supported feature under the xpcs_sgmii_features struct.
> 
> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: pcs: xpcs: Add Pause Mode support for SGMII and 2500BaseX
    https://git.kernel.org/netdev/net-next/c/849d2f83f52e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


