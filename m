Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732AC529D20
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240417AbiEQJAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiEQJAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:00:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1050D42A11;
        Tue, 17 May 2022 02:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6A64B817D3;
        Tue, 17 May 2022 09:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E64DC34117;
        Tue, 17 May 2022 09:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652778012;
        bh=Ip8EJxYs024jQQID4j7LdE3vS/Nw0WWKaHDLLl0sjOo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AxFtPWXs5FBxmJBskZE7BFXK7Iw9mzCCPUFtfn2bcyz208zAB1pEscgdmm960uSAv
         /800yB+pJyWIisKEhrsnX4J/vc/Q7URheHD39CSdeg4f6ZnrGeVtWMK5rIuehtobJc
         +tKGrWdZiC5n7Ld6Zsm99VOs6bU/QJsjMtZhit3P/QYo6WEu77RIoDjJZlV0f4fWVm
         c4DTC/1YP4UFHer6Yyko7KQDF4RFM1GXOvvMPUF27aw2MVv8uil8y7I9a3of/Hq7Zv
         lXLr5msStCFqaoqDfFa1FtgfNTArHnDRiIEhcbk0BxBwUnn59ZslRk3U07aVrFRucM
         blg05y0HOXO4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CC8EF03935;
        Tue, 17 May 2022 09:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: systemport: Fix an error handling path in
 bcm_sysport_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165277801224.19918.9904654326981885748.git-patchwork-notify@kernel.org>
Date:   Tue, 17 May 2022 09:00:12 +0000
References: <99d70634a81c229885ae9e4ee69b2035749f7edc.1652634040.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <99d70634a81c229885ae9e4ee69b2035749f7edc.1652634040.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 15 May 2022 19:01:56 +0200 you wrote:
> if devm_clk_get_optional() fails, we still need to go through the error
> handling path.
> 
> Add the missing goto.
> 
> Fixes: 6328a126896ea ("net: systemport: Manage Wake-on-LAN clock")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - net: systemport: Fix an error handling path in bcm_sysport_probe()
    https://git.kernel.org/netdev/net/c/ef6b1cd11962

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


