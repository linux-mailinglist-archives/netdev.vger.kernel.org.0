Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C985305A5
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 21:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350871AbiEVTun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 15:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350966AbiEVTuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 15:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573513A1A7;
        Sun, 22 May 2022 12:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E11A3B80D28;
        Sun, 22 May 2022 19:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87E7EC34116;
        Sun, 22 May 2022 19:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653249012;
        bh=ITrqTt7SNDgV1cQ8I6DKcBM+VFwHVlJTs8dlFefsyGU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E1cxlOmMOa1BQ4HqwnxWsp21zewBTWo5OMi4A1xwI09q6+W5HhHux610Jx/Codr+o
         U0zSBELn/leCesXJsc5dxeTziJC7AwyDMB6kY2PXwQyZSl3LV3gsIhLI2y/guCdvIE
         c2aJkxtRTcU/AomSVLX3OiEBgnNWI5+D2BYzXjKTRzCgCAJLfKFQPEN6eXNyfDWihx
         cYnsadleinfkFioNwMKw6RaX65kwYfaK8v4RBpgUCQygVHRNJ5Jf0xUwW4RXgzmzE+
         N8MDjfyEliVYZYv173ill0Sw/FhXlD0fi3LCI3soenu4viRrtA+w8xkHDzIZ9m1buO
         9Y3+z2DXC9rag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6BF00F03943;
        Sun, 22 May 2022 19:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sparx5: switchdev: fix typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165324901243.28407.5648416203237285810.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 19:50:12 +0000
References: <20220521111145.81697-10-Julia.Lawall@inria.fr>
In-Reply-To: <20220521111145.81697-10-Julia.Lawall@inria.fr>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     davem@davemloft.net, kernel-janitors@vger.kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sat, 21 May 2022 13:10:20 +0200 you wrote:
> Spelling mistake (triple letters) in comment.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  drivers/net/ethernet/microchip/sparx5/sparx5_port.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: sparx5: switchdev: fix typo in comment
    https://git.kernel.org/netdev/net-next/c/1f36a72ae347

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


