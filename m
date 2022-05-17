Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906E552A31A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 15:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347518AbiEQNUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 09:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347537AbiEQNUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 09:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B6B41F94
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 06:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1407DB81893
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 13:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF093C34116;
        Tue, 17 May 2022 13:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652793611;
        bh=ltA9YCYrsngQy0OC90pIC8iFfBQfdrr4fzZtejgv7oQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RJ4VRJmoBQFpwQzqK3Htu2Llp5lEvZGATlMQlckCG0unSa5ZjCno6C4pZau9VfOjI
         6qGbFQMCv4fOvQQjooevaegry6XacDJ1YsqGtJaw5gfBDX7AlpWTL7JQEuQ/cJzeIU
         POlVaJ5NsQRsreDX8sLr1p22bliss72EQpPpT6lnylyVdEf3Dgi3RlvUEdCwGj3UjZ
         nq4qnt58ZaFLTa/0R8ECpYTDgzcw3kbhPHjL/CQhmkH3InEKq97aiAs7B2O7BVl1VX
         Q/FKHYeelKFDXksL8tGEnv5gOpxnr2q87NLmrqYrO018phkWTGIaZip2g4CtmsKbHX
         /5ovcmwvol+VA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AC5B8F0383D;
        Tue, 17 May 2022 13:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: phy: marvell: Add errata section 5.1 for Alaska PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165279361170.14667.8610844403745692069.git-patchwork-notify@kernel.org>
Date:   Tue, 17 May 2022 13:20:11 +0000
References: <20220516070859.549170-1-sr@denx.de>
In-Reply-To: <20220516070859.549170-1-sr@denx.de>
To:     Stefan Roese <sr@denx.de>
Cc:     netdev@vger.kernel.org, lpolak@arri.de, kabel@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 16 May 2022 09:08:59 +0200 you wrote:
> From: Leszek Polak <lpolak@arri.de>
> 
> As per Errata Section 5.1, if EEE is intended to be used, some register
> writes must be done once after every hardware reset. This patch now adds
> the necessary register writes as listed in the Marvell errata.
> 
> Without this fix we experience ethernet problems on some of our boards
> equipped with a new version of this ethernet PHY (different supplier).
> 
> [...]

Here is the summary with links:
  - [v2] net: phy: marvell: Add errata section 5.1 for Alaska PHY
    https://git.kernel.org/netdev/net-next/c/65a9dedc11d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


