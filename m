Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9886C31B8
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjCUMaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCUMaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8508E1715;
        Tue, 21 Mar 2023 05:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BCD161B74;
        Tue, 21 Mar 2023 12:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70B28C4339B;
        Tue, 21 Mar 2023 12:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679401818;
        bh=2fyTuaCHjdl/UpR50suXht+irQY2VJBJxNpLECv+KFE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cLKPTAK57jDdVKjnX9PtETAr7N7zs1gUmraocFGmvMgry8jPaNXLSAKLpmQlm+83E
         7p8T5dB/dA91tQD1YmDoDt4hM+AGc2avfVQgcb/OGjSn6z0wX3SmjNJicrHfquY11n
         PfOhX3uJYye0z7Boew8UBtPdGVT+OPfSOIgcDpOxciQBPgDDxJpJqX3j4snOnU7mzt
         Pg4F3HtQZ3Y5nktm+Q+f5hmjBOJqsoFKNQaXT9bbYy2qLK0f1SQNizDOBp6EEmoonr
         24AgCeb3uw/QWWA6RxIMmmve5uHYDjMrKauDfaBMSpKLWe8GaeIc1DgxdJIh2oKolf
         TyXO8y6MArsmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57164E52513;
        Tue, 21 Mar 2023 12:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: b53: add support for BCM63xx RGMIIs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167940181835.17617.10779789931458547899.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Mar 2023 12:30:18 +0000
References: <20230319220805.124024-1-noltari@gmail.com>
In-Reply-To: <20230319220805.124024-1-noltari@gmail.com>
To:     =?utf-8?q?=C3=81lvaro_Fern=C3=A1ndez_Rojas_=3Cnoltari=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 19 Mar 2023 23:08:05 +0100 you wrote:
> BCM63xx RGMII ports require additional configuration in order to work.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  v2: add changes suggested by Andrew:
>   - Use a switch statement.
>   - Use dev_dbg() instead of dev_info().
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: b53: add support for BCM63xx RGMIIs
    https://git.kernel.org/netdev/net-next/c/ce3bf94871f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


