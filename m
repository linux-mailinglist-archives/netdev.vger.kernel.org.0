Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D134E3B2C
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 09:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiCVIvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 04:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiCVIvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 04:51:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA8F7807F;
        Tue, 22 Mar 2022 01:50:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6685761630;
        Tue, 22 Mar 2022 08:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC2B4C340F2;
        Tue, 22 Mar 2022 08:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647939009;
        bh=YNySE8elfCgiCbbbMGaPZXw25+0rPhhVNbTJBkCN7Cw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KYLkMkZkOwg5E6r09wnSSv6o0o7mFIjdlze2QE8dxBEz3i7sVmxjW6eQZDtkvCQUZ
         QA7zQrvjsul2BC3Yr4Hf+hQ1d+0viH659Rmo1Hb2yFUd0POhSAVMWSWbXjpnriHDwZ
         WyudYUw+hB1zLpMGzma0u6p8b+iOdahp6KBG83MVH3Vu9xRhASkQ8jo99RkLZTAJ9B
         GtktRqq1fVtvXkgmZgHBDGyy2poUKMuK2/3WGGQaCg9HH1FJ21Mwrw9htBTb9pdCCH
         j7Mxg3y0FzEVAKX9ihIaiUcpZQaSst+oZ4eV4T6GNSXaVrD6Y/bP5H1al388oaxMea
         s9KGyK1LreIbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B3705EAC096;
        Tue, 22 Mar 2022 08:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: wwan: qcom_bam_dmux: fix wrong pointer passed to
 IS_ERR()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164793900973.17764.2911446319631283761.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Mar 2022 08:50:09 +0000
References: <20220319032450.3288224-1-yangyingliang@huawei.com>
In-Reply-To: <20220319032450.3288224-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, davem@davemloft.net,
        stephan@gerhold.net
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 19 Mar 2022 11:24:50 +0800 you wrote:
> It should check dmux->tx after calling dma_request_chan().
> 
> Fixes: 21a0ffd9b38c ("net: wwan: Add Qualcomm BAM-DMUX WWAN network driver")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/wwan/qcom_bam_dmux.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [-next] net: wwan: qcom_bam_dmux: fix wrong pointer passed to IS_ERR()
    https://git.kernel.org/netdev/net/c/6b3c74550224

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


