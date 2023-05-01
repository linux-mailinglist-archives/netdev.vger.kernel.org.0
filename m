Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE716F2EBF
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 08:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbjEAGkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 02:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjEAGkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 02:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4149218C;
        Sun, 30 Apr 2023 23:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8667961ABD;
        Mon,  1 May 2023 06:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4A26C4339B;
        Mon,  1 May 2023 06:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682923220;
        bh=gGSuGWgWgttdUPYq0QJwjR/Fo8OAhgQCTd+hV6AqmJQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=peOgYT3bBMmLfZdfmT6ANQ66GDIQmTnrZFIns3XaJFHsndOYoHPLoK4z/pVPJEXm4
         k+H7HzfJ/mHlrPEgIzcRftgzmfODhXuquFx0nD1xUFeXLyx7YnV4Exe2oUjlugOn03
         qfQFpiKrqGfXPZ9IALnBLq1/mzChTtnnLZtyQ3RNszP0cE9roZK9qNIVHS9vYbclKe
         km5ReNpEvYioCjLTQ1LxT35IMkA/V8cSAKljpYXNW/4FiLGilgAUJX7Nhx6abFREUU
         i+cuy+I+4XqYyGNHa1lWe6tH4Dgd/PreXMxNHtKWgughuH1ILfENKr/vzywcoc0qrp
         Z0iHwj+P/vTKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A0FDAC40C5E;
        Mon,  1 May 2023 06:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: atlantic: Define aq_pm_ops conditionally on CONFIG_PM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168292322064.19130.1892036141540950855.git-patchwork-notify@kernel.org>
Date:   Mon, 01 May 2023 06:40:20 +0000
References: <20230428214321.2678571-1-trix@redhat.com>
In-Reply-To: <20230428214321.2678571-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

On Fri, 28 Apr 2023 17:43:21 -0400 you wrote:
> For s390, gcc with W=1 reports
> drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c:458:32: error:
>   'aq_pm_ops' defined but not used [-Werror=unused-const-variable=]
>   458 | static const struct dev_pm_ops aq_pm_ops = {
>       |                                ^~~~~~~~~
> 
> The only use of aq_pm_ops is conditional on CONFIG_PM.
> The definition of aq_pm_ops and its functions should also
> be conditional on CONFIG_PM.
> 
> [...]

Here is the summary with links:
  - net: atlantic: Define aq_pm_ops conditionally on CONFIG_PM
    https://git.kernel.org/netdev/net/c/4f163bf82b02

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


