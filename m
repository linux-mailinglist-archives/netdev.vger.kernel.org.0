Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C3A5BD640
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiISVUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiISVUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:20:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130BA47B95;
        Mon, 19 Sep 2022 14:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4A886CE0AD3;
        Mon, 19 Sep 2022 21:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71C4EC433C1;
        Mon, 19 Sep 2022 21:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663622414;
        bh=akJpHY6MQEHvLsC1Re27oJlE5aMX8u2E99iMcnMhMxc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ou2550HnOwwWMe8oYpmod5gb+LfI4zWiwDtuDKmGlpOgOuf7mJOZG29hiSbscQpJx
         0EWw2EhGr5AZAWOuFhc9og2EcL4FWxvEub/YIl/pxZTqDB+CEyjV+lEUfhsTteo2gR
         /o/2RcYS5+Gro9dovTXax0TYykVO+PLI7c8RW+isu47qH+AKufD8hjb3cvTCF1Ye6R
         lR5w0eK5Ns7pG2ETmUqrTD0LQSPBOmo4FOoZk74qrL1UR97eQGmMH0rchbmO2x2nGV
         50v68fpor0BSq5JrsgtKlz5PM74HbXG08hYQF6hpZpj2g541BINxxJ9+POpFvx8CIW
         knlpDcCMB8g5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50A83E52536;
        Mon, 19 Sep 2022 21:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: remove fs_mii_disconnect and fs_mii_connect
 declarations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166362241432.4330.4829794093210572810.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Sep 2022 21:20:14 +0000
References: <20220909062959.1144493-1-cuigaosheng1@huawei.com>
In-Reply-To: <20220909062959.1144493-1-cuigaosheng1@huawei.com>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     pantelis.antoniou@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vbordug@ru.mvista.com, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 9 Sep 2022 14:29:59 +0800 you wrote:
> fs_mii_disconnect and fs_mii_connect have been removed since
> commit 5b4b8454344a ("[PATCH] FS_ENET: use PAL for mii management"),
> so remove them.
> 
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
>  drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 3 ---
>  1 file changed, 3 deletions(-)

Here is the summary with links:
  - net: ethernet: remove fs_mii_disconnect and fs_mii_connect declarations
    https://git.kernel.org/netdev/net-next/c/feceb24ed79a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


