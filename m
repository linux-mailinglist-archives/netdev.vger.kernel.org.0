Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3548B567BBB
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 04:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiGFCAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 22:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiGFCAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 22:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE0219030;
        Tue,  5 Jul 2022 19:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB554618A8;
        Wed,  6 Jul 2022 02:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DF48C341CB;
        Wed,  6 Jul 2022 02:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657072813;
        bh=ym+Ggjc2Q+HgpMh5Xf/DHbuNAh51S9COLnqD1a4CyiQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YbRTTe2SrxrQNbUhgumraNOTTcTe4EgZGlahUx0ARGm0J0u/OOSvVT0DKraLcy2oy
         g3WNhuSCdNLgIrVNN7KiJu0EkVbWo35h1CDzadNiFMC7eBvSIC30J+LcCC9e8JXK5O
         j10Qtzd/Fni90cNs1YECUbx3HoZ2n1+6XEi9xDMMvke9keeFQQymB96KlTZ73JZFMv
         G/zMcEW1fx13KScMjzdkqKANcayTMeb8FYbVuxLAuoMx4k2xMlaBFeaQKjczCBOvWs
         jiHwLXp8LHRm+s6KPJ0fTd0VN7+YEr2jR0xge3ESgrBkMF5HLaBjhzCXEnJcH1Qosw
         XZEiJMy0my3fw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6FB2E45BDC;
        Wed,  6 Jul 2022 02:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: asix: change the type of asix_set_sw/hw_mii to
 static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165707281287.10391.10415762275144014594.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Jul 2022 02:00:12 +0000
References: <20220704123448.128980-1-shaozhengchao@huawei.com>
In-Reply-To: <20220704123448.128980-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        paskripkin@gmail.com, linux@rempel-privat.de, andrew@lunn.ch,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 4 Jul 2022 20:34:48 +0800 you wrote:
> The functions of asix_set_sw/hw_mii are not called in other files, so
> change them to static.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  drivers/net/usb/asix.h        |  3 ---
>  drivers/net/usb/asix_common.c | 40 ++++++++++++++++++-----------------
>  2 files changed, 21 insertions(+), 22 deletions(-)

Here is the summary with links:
  - [net-next] net: asix: change the type of asix_set_sw/hw_mii to static
    https://git.kernel.org/netdev/net-next/c/7e40e16e38ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


