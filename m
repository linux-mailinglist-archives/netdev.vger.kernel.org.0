Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBE65FA9E5
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 03:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiJKBUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 21:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJKBUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 21:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4F31F2D0;
        Mon, 10 Oct 2022 18:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15BF7B80EB7;
        Tue, 11 Oct 2022 01:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F6B6C433D7;
        Tue, 11 Oct 2022 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665451215;
        bh=dSXhxWOrf2f4b42wi+393TOcx81up8SMo6/uWAF8SeY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fx6AHLxvMzfKFIH07QfHeOFe+441USDn7fd575YYaBtUh/0Xd71JG0ypRzZSpkBna
         UdzYRIUd6iq/oaoogPoo1wi7ePSWrFwcyp1yM4KlD/G/Llq54V9bfsZ/+Ycz0h7B2w
         Nm770QLgzwWbjwj9t+Q+rd/cmghB0+ZwfysGvNvAuinaJXvVkF2HyoEsIMeiTnYrdU
         ok6nhKIx2SHBqk3F3QsGN+OiyHpWnu21CDuNKmaE9biBvb+wrfmbA6NT4OLCBElG7U
         gg34WWK2jfg9PzjVQ3nOrhzByBqzaJhas0MbyciVA32AsyQBlytkAIySqxrlDCwBOW
         J4/vf97H3PmZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7AC1BE43EFE;
        Tue, 11 Oct 2022 01:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: prestera: span: do not unbind things things that
 were never bound
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166545121549.22576.14666975915147855361.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Oct 2022 01:20:15 +0000
References: <20221006190600.881740-1-maksym.glubokiy@plvision.eu>
In-Reply-To: <20221006190600.881740-1-maksym.glubokiy@plvision.eu>
To:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, serhiy.boiko@plvision.eu,
        vkochan@marvell.com, vmytnyk@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  6 Oct 2022 22:06:00 +0300 you wrote:
> Fixes: 13defa275eef ("net: marvell: prestera: Add matchall support")
> Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_span.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: prestera: span: do not unbind things things that were never bound
    https://git.kernel.org/netdev/net/c/32391e646a71

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


