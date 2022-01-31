Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4566A4A45C7
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376790AbiAaLqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:46:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52208 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377972AbiAaLkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:40:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73E82B82A8F;
        Mon, 31 Jan 2022 11:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2490BC36AE7;
        Mon, 31 Jan 2022 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643629211;
        bh=Zas3iMSEXsI9ThkZ6FbV3DG8f3yfiG2CrFJ2C+Ok5tE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I3kPkVhnZt/OqHH3Sdz0BahS4BlFWX7gcTBmQr/6uCONkuEHAXAuEmr91mDunFuKh
         OZv/jOI7MaT4GZ0Vf2TPHrb7nnHiFpc1QZPs9Zyiq/mVXGyrSgN2/M8qTXubn9Kax6
         LlpAczO6o03pooHrYACLMq6qCRv4uKgumpCvSXiEvebCmAsmbBrGNAUMLVPaXE7k8P
         jQlH4ON+UKhawOuh8O8s0Nra7sYuz7il6bA7Ux0Jr4iQ7ts6mpZvm51TBIuQMjh7zw
         Pc7mlo0JkzL3ERxGwwAzMI9U1s6kWhRuUfsZu9/TozVgrlw3MSZpBUlrPJkJ7/tJ7a
         OO1Vllv7ELBqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0614EE6BBCA;
        Mon, 31 Jan 2022 11:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/fsl: xgmac_mdio: fix return value check in
 xgmac_mdio_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164362921102.6327.11411849430767861808.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Jan 2022 11:40:11 +0000
References: <20220129012702.3220704-1-weiyongjun1@huawei.com>
In-Reply-To: <20220129012702.3220704-1-weiyongjun1@huawei.com>
To:     weiyongjun (A) <weiyongjun1@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        tobias@waldekranz.com, mw@semihalf.com, calvin.johnson@oss.nxp.com,
        markus@notsyncing.net, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 29 Jan 2022 01:27:02 +0000 you wrote:
> In case of error, the function devm_ioremap() returns NULL pointer
> not ERR_PTR(). The IS_ERR() test in the return value check should
> be replaced with NULL test.
> 
> Fixes: 1d14eb15dc2c ("net/fsl: xgmac_mdio: Use managed device resources")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/fsl: xgmac_mdio: fix return value check in xgmac_mdio_probe()
    https://git.kernel.org/netdev/net-next/c/cc4598cf179f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


