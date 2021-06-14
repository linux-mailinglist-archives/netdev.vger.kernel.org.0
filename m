Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128973A711D
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 23:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbhFNVWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 17:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235156AbhFNVWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 17:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 324CB61209;
        Mon, 14 Jun 2021 21:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623705603;
        bh=AkDNscB7sJNc/oJNy6ys+Yc/Lxli0Gk0CEZExSF3334=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PcRr1/aQ3YtLCsEv3jrzkGAyk6OQF1g1gThZG5VfMhGrjligCS5lLHBD/PuqbeMUw
         qfVsXMDar8P3kfiaXaIt3CdsExCWH8ahdxDMngGHnFpZzXPAHYijrdCay70289NGzD
         aLeCmHyAwlQkbQHWYKEN1+KwxTLQ/xLtHQXtk0Hj4PgKmguHkr+YMTlUvgRCSpe7Nc
         FtBlXxE51n6p42ml9j9/rvbSY0CJUiu/S4bNSeirZU4a35Yn6k/PZhoRMwW5Y0lUHg
         r2sTdHzIbkpYH5il3+QGvVRvXanZpDslELHhBOEWionGmbBnJ19ZnS9/A6XqX7Tx58
         3/BPYJw3mSvvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 25C1B60977;
        Mon, 14 Jun 2021 21:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mhi_net: Update the transmit handler prototype
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370560314.22470.17540540933115942569.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 21:20:03 +0000
References: <1623704605-22913-1-git-send-email-subashab@codeaurora.org>
In-Reply-To: <1623704605-22913-1-git-send-email-subashab@codeaurora.org>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     stranche@codeaurora.org, hemantk@codeaurora.org,
        manivannan.sadhasivam@linaro.org, loic.poulain@linaro.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 14 Jun 2021 15:03:25 -0600 you wrote:
> Update the function prototype of mhi_ndo_xmit to match
> ndo_start_xmit. This otherwise leads to run time failures when
> CFI is enabled in kernel.
> 
> Fixes: 3ffec6a14f24 ("net: Add mhi-net driver")
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> 
> [...]

Here is the summary with links:
  - [net] net: mhi_net: Update the transmit handler prototype
    https://git.kernel.org/netdev/net/c/2214fb53006e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


