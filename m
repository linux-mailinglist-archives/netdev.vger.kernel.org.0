Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89855EF00B
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 10:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbiI2IKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 04:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbiI2IKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 04:10:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435EE82752;
        Thu, 29 Sep 2022 01:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4EE6B823AB;
        Thu, 29 Sep 2022 08:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A5B9C433D7;
        Thu, 29 Sep 2022 08:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664439015;
        bh=ky137os0hbVFN+1bPQnekE+YN/7mA238NtcGnLwxVQU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XpaKGWJlb9Qe5aXk9cZ4n6yDkY7mFBAn1meGIym3g16XTr1HNyh331/SrtaPGG9xU
         aMvo/TZMZ7GzoZq3Ftk3nRo/Y0lKzBQlsoicKWluDcHI/E+tl1W9YbyvmC1L1sF0SA
         pHmROj59//TpEemof4mCqaecUvBbYEuIGo74g3vXpElziN+C75DnNPoRrGBnUHUBT6
         O/twkfNTTtsABPKOIuyLUljvLV2Vkm+5aLg0I/qA3S40n6X+1UcE1Oak1j6pCsIpMe
         LMwKbGnf6GAmySfh/xWdhNTXQ09HhkWnKPnQfA9EYAudxY57rWWzMi6G3PLGkYA0mn
         S6UoIIOABRDVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 59C39E4D01B;
        Thu, 29 Sep 2022 08:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: ethernet: mtk_eth_soc: use
 DEFINE_SHOW_ATTRIBUTE to simplify code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166443901536.2321.13062051638346979105.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 08:10:15 +0000
References: <20220927111925.2424100-1-liushixin2@huawei.com>
In-Reply-To: <20220927111925.2424100-1-liushixin2@huawei.com>
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     kuba@kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 27 Sep 2022 19:19:25 +0800 you wrote:
> Use DEFINE_SHOW_ATTRIBUTE helper macro to simplify the code.
> No functional change.
> 
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> ---
> 
> v1->v2: Rebase on net-next.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: ethernet: mtk_eth_soc: use DEFINE_SHOW_ATTRIBUTE to simplify code
    https://git.kernel.org/netdev/net-next/c/1a0c667ea8e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


