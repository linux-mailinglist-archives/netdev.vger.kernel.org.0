Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523024CBB5F
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 11:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbiCCKbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 05:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbiCCKa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 05:30:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67CC179A25;
        Thu,  3 Mar 2022 02:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C99BB824B5;
        Thu,  3 Mar 2022 10:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EBA83C340F0;
        Thu,  3 Mar 2022 10:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646303410;
        bh=XVR3iwjDM2lRJRdwj9pCEZ/DxoA/4L11Kz7WqsiiQXQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lh0/CR0UvGBN/FOJWN4IxhWL8JPeMegYxg522Jff2+HZuUqq9NpMG9xw22i3L6LOx
         Ql3hYBg+3mhY00otD4/c4E7zolHkCzJ72fkssdgD5SVfezxqEC+jHstLE8hruTfeU8
         AJ1tw3o50azodAg1BPdLajU3zL+FUWLx7zR54hnxU7UI5o7vkQUQmK7gdqpa0EBp+I
         bKCvbBR5Ozm0BBBpYHDKZchTouMlHqnvJQdTvKDBG1+K7pAxEOBLPwa8rFTkNJKAJz
         NbOACJWTyi2AcVdzIKmE3caHvUM8K+HyfmnSSxDaa5SwTx+7NRfV0HJO2emzHlvgBw
         +LCSqrmyWOvlg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5F01E8DD5B;
        Thu,  3 Mar 2022 10:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: arcnet: com20020: Fix null-ptr-deref in
 com20020pci_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164630340987.19668.16225347159086469942.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 10:30:09 +0000
References: <20220302122423.4029168-1-zheyuma97@gmail.com>
In-Reply-To: <20220302122423.4029168-1-zheyuma97@gmail.com>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     m.grzeschik@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Wed,  2 Mar 2022 20:24:23 +0800 you wrote:
> During driver initialization, the pointer of card info, i.e. the
> variable 'ci' is required. However, the definition of
> 'com20020pci_id_table' reveals that this field is empty for some
> devices, which will cause null pointer dereference when initializing
> these devices.
> 
> The following log reveals it:
> 
> [...]

Here is the summary with links:
  - [v2] net: arcnet: com20020: Fix null-ptr-deref in com20020pci_probe()
    https://git.kernel.org/netdev/net/c/bd6f1fd5d33d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


