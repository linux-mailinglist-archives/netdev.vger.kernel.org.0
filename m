Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76318516EF9
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 13:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384743AbiEBLnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 07:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbiEBLnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 07:43:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010759B
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 04:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C907612A5
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 11:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4D80C385AF;
        Mon,  2 May 2022 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651491611;
        bh=En8ZaIWe5j7whgMGdUsFM66C3iAsw33+gKse8mGyMts=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JL62rPSGepcsBH00rjSdTRvzPfOl1P1oeSAPXlhtCOxnmrXELP/g/ui0ftsC2Tg5/
         7ckLITiIngPQWR5nDQID5chdE/WXcOSo8n6UvwSkG47iE+CYf2BGzF1H7NG4OdzQ0l
         xR2P5LxUTAAKC89m5sx/Aqlbj9ZIIgIgr21JQuBOl13+9x6lyFx/aCQS16noPlENZU
         OCEXsY0IA0FrAtA1ijCOrkddxDfOwsf92Mv4A8zlnY88d61HTzW/x3JwrBWC9TyFnJ
         7I/xYgheT5fziresP+wleByWcFy1+ianyHpI4XuRGJY6HlahDut95F8BDypSc82MpO
         mTMMyY0k/m7hw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BE8D0E8DBDA;
        Mon,  2 May 2022 11:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 0/5] Use MMD/C45 helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165149161177.12583.961198651546856539.git-patchwork-notify@kernel.org>
Date:   Mon, 02 May 2022 11:40:11 +0000
References: <20220430173037.156823-1-andrew@lunn.ch>
In-Reply-To: <20220430173037.156823-1-andrew@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     kuba@kernel.org, vladimir.oltean@nxp.com, f.fainelli@gmail.com,
        Jose.Abreu@synopsys.com, hkallweit1@gmail.com,
        rmk+kernel@armlinux.org.uk, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 30 Apr 2022 19:30:32 +0200 you wrote:
> MDIO busses can perform two sorts of bus transaction, defined in
> clause 22 and clause 45 of 802.3. This results in two register
> addresses spaces. The current driver structure for indicating if C22
> or C45 should be used is messy, and many C22 only bus drivers will
> wrongly interpret a C45 transaction as a C22 transaction.
> 
> This patchset is a preparation step to cleanup the situation. It
> converts MDIO bus users to make use of existing _mmd and _c45 helpers
> to perform accesses to C45 registers. This will later allow C45 and
> C22 to be kept separate.
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/5] net: phylink: Convert to mdiobus_c45_{read|write}
    https://git.kernel.org/netdev/net-next/c/70dcf3cdc342
  - [net-next,v1,2/5] net: phy: Convert to mdiobus_c45_{read|write}
    https://git.kernel.org/netdev/net-next/c/260bdfea873a
  - [net-next,v1,3/5] net: phy: bcm87xx: Use mmd helpers
    https://git.kernel.org/netdev/net-next/c/cad75717c71b
  - [net-next,v1,4/5] net: dsa: sja1105: Convert to mdiobus_c45_read
    https://git.kernel.org/netdev/net-next/c/639e4b93ab68
  - [net-next,v1,5/5] net: pcs: pcs-xpcs: Convert to mdiobus_c45_read
    https://git.kernel.org/netdev/net-next/c/d18af067c98e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


