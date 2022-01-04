Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66744841D8
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 13:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbiADMuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 07:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiADMuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 07:50:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9794FC061761;
        Tue,  4 Jan 2022 04:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37E82613EA;
        Tue,  4 Jan 2022 12:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99BBDC36AE9;
        Tue,  4 Jan 2022 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641300609;
        bh=TqgMG3MwNnvtaSZcK4NktQ8b5DMrl33eJugvV8prBWc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hr8XGhaZXiE4KleAn0RpzsJ5B3BQzh0bqUkfNRHbQrFfK59y29xl+7qI3g4/pr01U
         +bFdnCiSnWdeCJKHUAKeYGCH0QgRUMUp7bIKL5H6Jnbil+XydQzEGVm1j+NLbrafuB
         zvOsLxXHPbJg2BPI1KMS0nFMmljsXsSnTS5Qf9ZfVczliZEC/N5Y86+GxKsM7qfxwB
         B2Q1sqB0rMd4mDERe0rWp+cde79y0LtsPRmzMuWEwfu4EjVgviqcMR1+JkfFvBqHtv
         78iigfO/AhxZkzGjxqwIh/swoyjpcwGsHV/EG8lo6S+ExE27MHLIG+x9kgqm35WlQN
         K+CZmRNoPCqjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B762F79405;
        Tue,  4 Jan 2022 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet/sfc: remove redundant rc variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164130060947.30501.17771232026723861571.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 12:50:09 +0000
References: <20220104113543.602221-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220104113543.602221-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chi.minghao@zte.com.cn,
        zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  4 Jan 2022 11:35:43 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Return value from efx_mcdi_rpc() directly instead
> of taking this in another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
> 
> [...]

Here is the summary with links:
  - ethernet/sfc: remove redundant rc variable
    https://git.kernel.org/netdev/net-next/c/416b27439df9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


