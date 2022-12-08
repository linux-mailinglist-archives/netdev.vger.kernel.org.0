Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0403064681C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 05:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiLHEKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 23:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiLHEKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 23:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704158C6BC;
        Wed,  7 Dec 2022 20:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1456661D7A;
        Thu,  8 Dec 2022 04:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61AC9C433D7;
        Thu,  8 Dec 2022 04:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670472617;
        bh=HUSOoUc6Ang6qCld8EX48PL0LPT4Qr2BguSasnkKP70=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KKSf6jyjdzpIWP8tXW/+/puCs+A73H0tgFSDDxA9vp9cel4Ve9hH83G+72YS1RMlx
         4Yi/0PI0CEeFzJRJjcaxOp4Bzyu87fb1zkT5pDCefW83c1qZeesaYCsS5L5bqmriRU
         a9OrCV7z9sMEYAw/fk+ip9wTOtps0KXHJ+crFbkVz1svY9rYriw3jnmUtoqFFL5ZrK
         +GfNri5AAyZWVTSpoUK2T7qGx7itugAL1LT7jh89qFJtF+zgBRvuHb6x2r+u6+vQ1Y
         8VyhucxYWfFqnjHFkIHFoUkZtVtcxdo8olMfSTgRkKaG1/1cxC/uhdhmp/bSQedXlr
         aKOVM3nOPDl7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 419DAE4D02D;
        Thu,  8 Dec 2022 04:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: phy: mxl-gpy: add MDINT workaround
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167047261726.18861.14289044396650307534.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 04:10:17 +0000
References: <20221205200453.3447866-1-michael@walle.cc>
In-Reply-To: <20221205200453.3447866-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     lxu@maxlinear.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  5 Dec 2022 21:04:53 +0100 you wrote:
> At least the GPY215B and GPY215C has a bug where it is still driving the
> interrupt line (MDINT) even after the interrupt status register is read
> and its bits are cleared. This will cause an interrupt storm.
> 
> Although the MDINT is multiplexed with a GPIO pin and theoretically we
> could switch the pinmux to GPIO input mode, this isn't possible because
> the access to this register will stall exactly as long as the interrupt
> line is asserted. We exploit this very fact and just read a random
> internal register in our interrupt handler. This way, it will be delayed
> until the external interrupt line is released and an interrupt storm is
> avoided.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: phy: mxl-gpy: add MDINT workaround
    https://git.kernel.org/netdev/net/c/5f4d487d01ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


