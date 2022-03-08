Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CD34D1747
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 13:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346743AbiCHMbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 07:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346727AbiCHMbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 07:31:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDEC39829
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 04:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4864D60B09
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 12:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 967C4C340EC;
        Tue,  8 Mar 2022 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646742610;
        bh=6FszrISk1dSIgT1ZCr4pn2WXttnNm0A9IShBszaSE4g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z15SDG5piWI0HQAlErMTBxXMpfTZA8SZ24/okqswokz4BZdXb4OSJJk8QdVzL3gDB
         RoY5yzBj7G4lwHC34DrvUp3NBBs36XIM95cJrSAxFjy7QvPhBcePAY/RZdOsVEkT1h
         +KbDfS1m969124FOAcUgT5JLZLW9pgEW4gAi3M6AsIQcFUE+AaLKnSv6QMLTqyc3SZ
         1syl2C0NYquaxaCdLsr1RvfzL2fUeAUoa+/YrURAyRUghJ8qPCPxRN9fpFMMXZ+HXU
         N16NMQCSRw79Z38eM454+5kQxxt0K55SjenDV02ek++NkzUbWDWPvqlm3fnP31w0oa
         5eAP9aVW+n/aQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 777B4E6D3DD;
        Tue,  8 Mar 2022 12:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mt7530: fix incorrect test in
 mt753x_phylink_validate()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164674261048.611.6556079639015466902.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Mar 2022 12:30:10 +0000
References: <E1nRCF0-00CiXD-7q@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nRCF0-00CiXD-7q@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     dqfext@gmail.com, Landen.Chao@mediatek.com, sean.wang@mediatek.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 07 Mar 2022 12:13:30 +0000 you wrote:
> Discussing one of the tests in mt753x_phylink_validate() with Landen
> Chao confirms that the "||" should be "&&". Fix this.
> 
> Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> As the mt7530 maintainers are not very responsive to my recent two patch
> series, but Landen Chao did state that this should be "&&" not "||", lets
> at least get this patch merged.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mt7530: fix incorrect test in mt753x_phylink_validate()
    https://git.kernel.org/netdev/net/c/e5417cbf7ab5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


