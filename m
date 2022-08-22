Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1459659BF2A
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 14:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbiHVMBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 08:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbiHVMAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 08:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E301837F86;
        Mon, 22 Aug 2022 05:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A01FBB81136;
        Mon, 22 Aug 2022 12:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57B85C433D7;
        Mon, 22 Aug 2022 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661169615;
        bh=QyidKXxjUxGzKYu32qxGAry+J6qOOqN7bBtWkrUeVxk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WBR6Yf7C72dq+COy6A0koV6V2dz8mMhRiwDUyLdWKM7qbG6ZM7Lee9dnXzhCj9cMA
         0bFqZd6Qqj6TTi4aBnwsksKlGSmxQ5iFypaQnSUretTnPpxkCuiO4SWe17F2v4sdK3
         fOi0nT8zSOshzBncjbXs0DndUq6ZH1e7ZL6myXYZjlZDt8QeIdVoXnI5xkuQ7EjFkE
         xmUbYnFEwR7PTgB9preZ1WK6cHj89n35wTuXymr9uXS5SfBjNLKJ5D0mPKP2OsKKp6
         GUVyrhpJEDKdrvENcpYaGK4oUr7TewcVcQx4Wgcp7R8I25iMoylrc35E7nCdvWHEV3
         x2TSCOdosMFzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3697AC04E59;
        Mon, 22 Aug 2022 12:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next] net: ethernet: ti: davinci_mdio: Add workaround
 for errata i2329
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166116961521.23061.17601464950387342608.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Aug 2022 12:00:15 +0000
References: <20220817094406.10658-1-r-gunasekaran@ti.com>
In-Reply-To: <20220817094406.10658-1-r-gunasekaran@ti.com>
To:     Ravi Gunasekaran <r-gunasekaran@ti.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kishon@ti.com, vigneshr@ti.com, lkp@intel.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Aug 2022 15:14:06 +0530 you wrote:
> On the CPSW and ICSS peripherals, there is a possibility that the MDIO
> interface returns corrupt data on MDIO reads or writes incorrect data
> on MDIO writes. There is also a possibility for the MDIO interface to
> become unavailable until the next peripheral reset.
> 
> The workaround is to configure the MDIO in manual mode and disable the
> MDIO state machine and emulate the MDIO protocol by reading and writing
> appropriate fields in MDIO_MANUAL_IF_REG register of the MDIO controller
> to manipulate the MDIO clock and data pins.
> 
> [...]

Here is the summary with links:
  - [v3,net-next] net: ethernet: ti: davinci_mdio: Add workaround for errata i2329
    https://git.kernel.org/netdev/net-next/c/d04807b80691

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


