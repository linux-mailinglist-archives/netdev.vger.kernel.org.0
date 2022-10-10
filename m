Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777995F9A75
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 09:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbiJJHvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 03:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbiJJHvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 03:51:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CC06276
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 00:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1038660E15
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 07:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78036C433D7;
        Mon, 10 Oct 2022 07:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665388214;
        bh=1b+Ksvin2DnqRnqNgqzWCoBhJU4BRDzNFD6IwoyAV4g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g7amWq/iWojRSLXzkJqb2sseiaZjtLm2XNp2mDngmEigp4I7MedNoiEb79JVJfFFM
         vXf+whypmulYnZBy8af9ycuZesaG6AWQh3MsYBFrPKU/KwJqWGSzlJEBS50uUAS6X+
         RDD9Q0Fw0zimcZ9a+hzsExGGL/6DbJCZPNxzPKgKEc8xV0SP3rwfoaKB7ueewDlTyv
         pz45jTfAhVDMshfZoO84Wuf/w6gqAKAHnyJpiBTRouZ0rMoXIiwwJ2bO2IZP/tl/Jd
         QK4mhw6gm5CxSKyxuBlQdmAPlfcy5IdglBKiQIkW+uM3TeBeWoT4bYJ5tAfRdlboA2
         VVpdE2ZMXbS6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5796CE50D9B;
        Mon, 10 Oct 2022 07:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] octeontx2-pf: mcs: fix possible memory leak in
 otx2_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166538821435.7397.5233971243250020622.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Oct 2022 07:50:14 +0000
References: <20221010033945.2067861-1-yangyingliang@huawei.com>
In-Reply-To: <20221010033945.2067861-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, sbhatta@marvell.com, sgoutham@marvell.com,
        davem@davemloft.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 10 Oct 2022 11:39:45 +0800 you wrote:
> In error path after calling cn10k_mcs_init(), cn10k_mcs_free() need
> be called to avoid memory leak.
> 
> Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] octeontx2-pf: mcs: fix possible memory leak in otx2_probe()
    https://git.kernel.org/netdev/net/c/af7d23f9d96a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


