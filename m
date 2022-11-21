Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98AD8631D4F
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiKUJuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiKUJuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:50:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05F526AD4;
        Mon, 21 Nov 2022 01:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8810F60F8F;
        Mon, 21 Nov 2022 09:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3F69C433C1;
        Mon, 21 Nov 2022 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669024214;
        bh=dD2eq0kkxs9QrsJG7bW0EimUcsHsADfU2u9aKvskfeE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vCXDD6SOkEEkbWSYz/xj8SWPGYeFyyGpbPPtGTCrbfKWM+UWJ250RW/e9H+luQkiU
         gcjl05bwp/ZRZmDSBXNFb/WP/1oj87r45tRGW1rG80aUpqXqgwDVe57QlW0kghdmAU
         FGt9pPMuqBly6Cy3abv/7OzPdEOjUArmHNfPCl1NY1BS2pzuTFxJCqnUeRg0S9DUb6
         BsYpDoe+NAdtt4Takb686vEz+d69eyFoqwXERCF8M78V5SVFPJmReHBtjYNeyC0x+A
         Cnj72apcwQEzWn16XR3gBlA+bLbeNFF9ecmLPl/oWtvVQ3exZ6dmME7j/ZUcjNFGLW
         GxChGdsowhcGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1E09E29F3E;
        Mon, 21 Nov 2022 09:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: microchip: sparx5: kunit test: Fix compile
 warnings.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166902421471.7862.3163181584528349376.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 09:50:14 +0000
References: <20221117132812.2105718-1-horatiu.vultur@microchip.com>
In-Reply-To: <20221117132812.2105718-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steen.Hegelund@microchip.com,
        lars.povlsen@microchip.com, daniel.machon@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Nov 2022 14:28:12 +0100 you wrote:
> When VCAP_KUNIT_TEST is enabled the following warnings are generated:
> 
> drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:257:34: warning: Using plain integer as NULL pointer
> drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:258:41: warning: Using plain integer as NULL pointer
> drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:342:23: warning: Using plain integer as NULL pointer
> drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:359:23: warning: Using plain integer as NULL pointer
> drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:1327:34: warning: Using plain integer as NULL pointer
> drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:1328:41: warning: Using plain integer as NULL pointer
> 
> [...]

Here is the summary with links:
  - [net-next] net: microchip: sparx5: kunit test: Fix compile warnings.
    https://git.kernel.org/netdev/net-next/c/aa5ac4be8da1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


