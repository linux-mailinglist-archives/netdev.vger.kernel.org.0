Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3A85AD3E7
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237787AbiIENaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237743AbiIENaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2310615A10;
        Mon,  5 Sep 2022 06:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3003B8119E;
        Mon,  5 Sep 2022 13:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FD81C433D7;
        Mon,  5 Sep 2022 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662384614;
        bh=7XONn9KaUTnR3WKojdkRi/lvfYNW+Pp+4J0HaSGdd2o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BvEQK6meER+TAYOo+F4z0cz9x6AQDGGcyxjPrKaHQEP+zhBoprqa1Ah47FFL06+C5
         0LcayaKEXLql+97ZPM6VRrohXS8lPJ2xcuRvySLtzZ2IWfv0ESPqDb0are/r39UjNb
         bZ9Qq0v6JFMl1mjEzdG8tyiSmxVFVn3q0PJY4CzKTS5iT3uoKJMDbpX2br+28yBtkd
         CUsqjph4ciptxSbGzHEnOcHT3LUCT4Z3EGDJh/szDA+PyGKLkycNEtWKJHIb9Uub07
         FaA4elaa6oRxlBJJlki3YTtzdmC5m21nR4IasNB2yAs21f2beK+yDCJNfgAF/8/vPx
         AF4jkjZRrHtjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66986E1CABF;
        Mon,  5 Sep 2022 13:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] stmmac: intel: Simplify intel_eth_pci_remove()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166238461441.27659.12239110868917016619.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 13:30:14 +0000
References: <35ab3ac5b67716acb3f7073229b02a38fce71fb7.1662135995.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <35ab3ac5b67716acb3f7073229b02a38fce71fb7.1662135995.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  2 Sep 2022 18:26:56 +0200 you wrote:
> There is no point to call pcim_iounmap_regions() in the remove function,
> this frees a managed resource that would be release by the framework
> anyway.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [v3] stmmac: intel: Simplify intel_eth_pci_remove()
    https://git.kernel.org/netdev/net/c/1621e70fc79d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


