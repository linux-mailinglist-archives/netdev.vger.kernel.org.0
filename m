Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9F66EBF8F
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 14:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjDWMuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 08:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDWMuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 08:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D02110CC;
        Sun, 23 Apr 2023 05:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3850F60EF6;
        Sun, 23 Apr 2023 12:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B2A4C433D2;
        Sun, 23 Apr 2023 12:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682254217;
        bh=0XtrEUR1rKRDtOBaE4iikDH8y7lfxm9ELVPwc7pzzWw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nv25gNiN1wBjMxGYgUFvfAbNrvZBRAZwHoDHlCAIDjTb2WjzUqa+TficF7srYiUPe
         hfSWeG1xbBWFm/pXe6wEB5BajErzMq3A9pgLulZIMr6plG/NheHWgXWYDzuIho54/c
         GgwagxGXeDB96wFXF/gJIQdvFxqtRwvDJKpvZbvO9iu2OK7Wp4Gh5r+5jPRtOrFHrD
         Qp+/uXM1kkIcjVo/QXj2x53GJMzxsMiivdmLNepjYX6PNigcSEE+NPKp3e/XV36ChX
         h3Po8zhL81iieORMEXc5uRnM365n2Ho7EtMND3tJyZrGYi4KombEH+VTaQI8+nkI1q
         dn92sGky5Worg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DD07E270E1;
        Sun, 23 Apr 2023 12:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: mediatek: remove return value check of
 `mtk_wed_hw_add_debugfs`
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168225421744.16046.7230758740526095778.git-patchwork-notify@kernel.org>
Date:   Sun, 23 Apr 2023 12:50:17 +0000
References: <20230421151010.130695-1-silver_code@hust.edu.cn>
In-Reply-To: <20230421151010.130695-1-silver_code@hust.edu.cn>
To:     Wang Zhang <silver_code@hust.edu.cn>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, lorenzo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
        hust-os-kernel-patches@googlegroups.com, dzm91@hust.edu.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Apr 2023 23:10:09 +0800 you wrote:
> Smatch complains that:
> mtk_wed_hw_add_debugfs() warn: 'dir' is an error pointer or valid
> 
> Debugfs checks are generally not supposed to be checked
> for errors and it is not necessary here.
> 
> fix it by just deleting the dead code.
> 
> [...]

Here is the summary with links:
  - net: ethernet: mediatek: remove return value check of `mtk_wed_hw_add_debugfs`
    https://git.kernel.org/netdev/net/c/b148b9abc844

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


