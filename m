Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9366C3F39
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 01:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjCVAko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 20:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCVAkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 20:40:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF0E34303;
        Tue, 21 Mar 2023 17:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95979B81ACB;
        Wed, 22 Mar 2023 00:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D60AC4339B;
        Wed, 22 Mar 2023 00:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679445617;
        bh=uA0W7Evl3i2X/hbk6XqyCpnveha3bfT8SZdOx00NR8M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ettNs0rzASSEzL/ZfIQjx3IyWmrRId7ih/AmDOgYID+reUIJ8pkuHNVOa1JqI3lW1
         8nHWJd+Tea6eX7OBZPoSgk7EM524RWHa4D8uef5GCj87wlYeereZmvs5+G/3wsH/4k
         HSyDDQ/lqlouhOyMnuUhxp+h0CKe6UDVBCkutcXK1EvL4XjMCM8QvGkXbn0+5sR5TL
         pFPXN6Fw8GVTIQWAeBx9Day+3J4lf2B4FI1lZq2vW4cfaL74qpdv3b9tY3k52Aso5x
         8VouvneoDJ46r0kzpp1R80OUX98hH8ediNRBN6ZwZ5zoZoe30UG8NDYuF8j+INPQIg
         jHx4v3DtFr6wQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0CEA3C39563;
        Wed, 22 Mar 2023 00:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: tag_brcm: legacy: fix daisy-chained switches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167944561704.18069.14666163144674500443.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 00:40:17 +0000
References: <20230319095540.239064-1-noltari@gmail.com>
In-Reply-To: <20230319095540.239064-1-noltari@gmail.com>
To:     =?utf-8?q?=C3=81lvaro_Fern=C3=A1ndez_Rojas_=3Cnoltari=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, jonas.gorski@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.swiatkowski@linux.intel.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 19 Mar 2023 10:55:40 +0100 you wrote:
> When BCM63xx internal switches are connected to switches with a 4-byte
> Broadcom tag, it does not identify the packet as VLAN tagged, so it adds one
> based on its PVID (which is likely 0).
> Right now, the packet is received by the BCM63xx internal switch and the 6-byte
> tag is properly processed. The next step would to decode the corresponding
> 4-byte tag. However, the internal switch adds an invalid VLAN tag after the
> 6-byte tag and the 4-byte tag handling fails.
> In order to fix this we need to remove the invalid VLAN tag after the 6-byte
> tag before passing it to the 4-byte tag decoding.
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: tag_brcm: legacy: fix daisy-chained switches
    https://git.kernel.org/netdev/net/c/032a954061af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


