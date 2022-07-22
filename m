Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7E557D83E
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 04:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbiGVCKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 22:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbiGVCKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 22:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B16D1BEBA
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 19:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6682CB8266F
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0AC9FC341C6;
        Fri, 22 Jul 2022 02:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658455814;
        bh=ZWhjEjQrCexbTXAxPPTBsPfuE/gqRKaoEsMZA/oagys=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ix5zhuhqz1ytpN/c/mqTzLmqcChsAmxe3G2jvj1cHWy+s0aGNnvSXFK/X4h0lcele
         YBCrl/dk4wIk6UrKozK2IHaZEhl9AcEnsTKgFGUSfcJ/o03CMSwRHtXP3rX1DwPruc
         V3O5Yx2hM46U3V7b+fUBnfiUhBJc+fNhpVkOeC4BBhV5GyPJQW+yltYVQSuBV/BQ4V
         IpjEzWU4T/Bmuq0CtxAl6XIDu9tP1KRdg6kGdxGeLr0q+PZrUC69I8oMH0HVoJbWcl
         D1ITEHM88fc+dECI7lrw+/vfc8d+HTiba7EehjtkG+xcezpD9b7f7HfxE4Pzk2IvVG
         RPxrtjd1txDwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA1DEE451BA;
        Fri, 22 Jul 2022 02:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: pcs: xpcs: propagate xpcs_read error to
 xpcs_get_state_c37_sgmii
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165845581389.5037.9982674996416196525.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 02:10:13 +0000
References: <20220720112057.3504398-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220720112057.3504398-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jose.Abreu@synopsys.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        boon.leong.ong@intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 20 Jul 2022 14:20:57 +0300 you wrote:
> While phylink_pcs_ops :: pcs_get_state does return void, xpcs_get_state()
> does check for a non-zero return code from xpcs_get_state_c37_sgmii()
> and prints that as a message to the kernel log.
> 
> However, a non-zero return code from xpcs_read() is translated into
> "return false" (i.e. zero as int) and the I/O error is therefore not
> printed. Fix that.
> 
> [...]

Here is the summary with links:
  - [net] net: pcs: xpcs: propagate xpcs_read error to xpcs_get_state_c37_sgmii
    https://git.kernel.org/netdev/net/c/27161db0904e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


