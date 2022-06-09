Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80E1544248
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbiFIEAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiFIEAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772276FA33;
        Wed,  8 Jun 2022 21:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1623361C4F;
        Thu,  9 Jun 2022 04:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67B58C34115;
        Thu,  9 Jun 2022 04:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654747213;
        bh=xTcjtWkH+5a+nce5MAwRaQbSWW626I4jvMlSp+LMiyQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HtvZX0u0vTMLT2Sis3EZYKifU37kJAiZp0B5NzFWJeHKXPTAd/z1MhjTXP1p3aEdw
         oe5Rl2FEsJqP4izJwbcuV9L4Zica6362HgV/M3Trrb/Eyg46sPysRzEkqq1scwxhwQ
         hZnQ0m2MkA/a0749NACEdyn4N3vAgMd5kLGId7CQqte7D7dePnU2FOsAcWCeXorwEK
         mkX482BIrBaaY2Adae5xNO02diTvu6UiGb4rjRqt40Ngok302gyr2orAkMHDHiCxsM
         0+8Ry4lm8JN496qhZjYU4eSTX8AUb5VIPI4W00Vw1dV+pSNqYKQhv/dGHUZ1VBiAEU
         ieUtVrjO/DKeQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C07AE737ED;
        Thu,  9 Jun 2022 04:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: altera: Fix refcount leak in altera_tse_mdio_create
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165474721330.28317.7209219946969772778.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 04:00:13 +0000
References: <20220607041144.7553-1-linmq006@gmail.com>
In-Reply-To: <20220607041144.7553-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     joyce.ooi@intel.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, vbridgers2013@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Jun 2022 08:11:43 +0400 you wrote:
> Every iteration of for_each_child_of_node() decrements
> the reference count of the previous node.
> When break from a for_each_child_of_node() loop,
> we need to explicitly call of_node_put() on the child node when
> not need anymore.
> Add missing of_node_put() to avoid refcount leak.
> 
> [...]

Here is the summary with links:
  - net: altera: Fix refcount leak in altera_tse_mdio_create
    https://git.kernel.org/netdev/net/c/11ec18b1d8d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


