Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E684C6E87A8
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbjDTBu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjDTBu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:50:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925624C20;
        Wed, 19 Apr 2023 18:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F2A66445C;
        Thu, 20 Apr 2023 01:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75F64C4339C;
        Thu, 20 Apr 2023 01:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681955419;
        bh=kFVavdxI+2ZOP1oeQy5/e4zp+JhWYB1Hgfo/bbpmcPM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sUt7VIJzcL09UoYyigcSuIcq/1/J2O3f4jPQPXJ4qStVYtRpXzz8QciC6z2mFeY8w
         uDlExF0JZcJNa8loxqMoHgKpfIV4MqfhZn/gR3byXxeLmvUbDIQcQqSLMkYkLksByc
         PcUK7RPWUTiclPVzXFATjBMw7Mi3ginOaAip8yI174z2+okyXgiOL2r464x2Obj4nj
         KWKAZ8avwaZ7aXgouUerCH2Ll8Ki/XFtzaxZF/6N1qBnSojFadMPYCGbAHH2jB51C1
         Qzx7iW+Mp7CQJhXeR/AQ90IfI+W988q6j+m/5inFs8s41KqduEU4W5t4+7zBglQnbi
         QrmvvfoeyI+Hg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 59E36C561EE;
        Thu, 20 Apr 2023 01:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: micrel: Update the list of supported phys
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168195541936.13596.611503428417262220.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 01:50:19 +0000
References: <20230418124713.2221451-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230418124713.2221451-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Apr 2023 14:47:13 +0200 you wrote:
> At the beginning of the file micrel.c there is list of supported PHYs.
> Extend this list with the following PHYs lan8841, lan8814 and lan8804,
> as these PHYs were added but the list was not updated.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: micrel: Update the list of supported phys
    https://git.kernel.org/netdev/net-next/c/3e9c0700bf42

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


