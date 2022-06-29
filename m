Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7175600FB
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbiF2NKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbiF2NKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:10:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EE021A2;
        Wed, 29 Jun 2022 06:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAE8061DE8;
        Wed, 29 Jun 2022 13:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57202C341CB;
        Wed, 29 Jun 2022 13:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656508215;
        bh=7YM6pTsDK2XVPmkR6++yTEqzX03KJjCzPOtYRGHpzbI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y4DXgvjWdGEMcQM6R5xUjOuuHK/BrLocwkl27LDCaZfiJgFM5iFlnBbJuur2tQ+UN
         GgEhBTQbFO3mOnXAPMSZZE3UbhXUWRmp0LG5Ju17Zx4QggSzMAoFNriY1qUVz36hAB
         5CrJsj6vASUK5fJ6FIn7UEqpEL4ejajIyGDKibNw5gu285EnfDh5dcshJFsU4by7vZ
         3JLGNpHJV1e/ktdvJ+UztrVznN2OLlbi5aT9SjnqpK/UlvjCLgIaXjgl+eYpA3HrBv
         x1yKTaY1slbh386ZIudVYMdMbu+yu/L5Q9Es8QNokvmlaNKMPFEWtxGoQzvV6TjTqN
         dgOnbW9A7o5Nw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E30CE49F61;
        Wed, 29 Jun 2022 13:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] NFC: nxp-nci: Don't issue a zero length
 i2c_master_read()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165650821524.20617.14794992816689313521.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 13:10:15 +0000
References: <20220627170643.98239-1-michael@walle.cc>
In-Reply-To: <20220627170643.98239-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     krzysztof.kozlowski@linaro.org, clement.perrochaud@nxp.com,
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Jun 2022 19:06:42 +0200 you wrote:
> There are packets which doesn't have a payload. In that case, the second
> i2c_master_read() will have a zero length. But because the NFC
> controller doesn't have any data left, it will NACK the I2C read and
> -ENXIO will be returned. In case there is no payload, just skip the
> second i2c master read.
> 
> Fixes: 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver")
> Signed-off-by: Michael Walle <michael@walle.cc>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> [...]

Here is the summary with links:
  - [v2,1/2] NFC: nxp-nci: Don't issue a zero length i2c_master_read()
    https://git.kernel.org/netdev/net/c/eddd95b94239
  - [v2,2/2] NFC: nxp-nci: don't print header length mismatch on i2c error
    https://git.kernel.org/netdev/net/c/9577fc5fdc8b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


