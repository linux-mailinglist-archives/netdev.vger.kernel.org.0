Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB95510D94
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 03:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356548AbiD0BDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 21:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349706AbiD0BDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 21:03:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FE364D6;
        Tue, 26 Apr 2022 18:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F417D61B05;
        Wed, 27 Apr 2022 01:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46476C385A4;
        Wed, 27 Apr 2022 01:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651021211;
        bh=vqm946qqQBJwF4axpR8b2V8FU1H9J0rGyX36fxlNm+s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qgtBcxhELUXZae4iTZjvYvtosPPCmxCUlTGl9uHYezDjYNMq2ImBF+KmC5skQeRoM
         6sK1VNwL8VBIMXlzUMFFJTS7q0866ndzDVCQRbD6lQWX0Vtg4D6Wp0BN9EYRRxQcgM
         uelVN85qp3z2uinhJtlUqgWdBj5IYQ7b8Fe4ZfCYvR7UCIPWfqMBOBZl2IZxob8IIU
         R/9hR6hkLHnpcQe4kWh02tr6m3wP1HN0On3+l8029qIgMYBSOeLsDNM+NtIybDlmLt
         hLJZzPj6jy3HvaQ4Zds9GIxqPCUjtpP6hzFQ1LERpFIfgUn7RSQz2LRXNsgxBK+24l
         QM0Ggc2Jwp/3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E0D7F67CA0;
        Wed, 27 Apr 2022 01:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: lantiq_gswip: Don't set GSWIP_MII_CFG_RMII_CLK
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165102121112.22539.16102240739312593513.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 01:00:11 +0000
References: <20220425152027.2220750-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20220425152027.2220750-1-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, hauke@hauke-m.de,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, stable@vger.kernel.org,
        jan@3e8.eu
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 25 Apr 2022 17:20:27 +0200 you wrote:
> Commit 4b5923249b8fa4 ("net: dsa: lantiq_gswip: Configure all remaining
> GSWIP_MII_CFG bits") added all known bits in the GSWIP_MII_CFGp
> register. It helped bring this register into a well-defined state so the
> driver has to rely less on the bootloader to do things right.
> Unfortunately it also sets the GSWIP_MII_CFG_RMII_CLK bit without any
> possibility to configure it. Upon further testing it turns out that all
> boards which are supported by the GSWIP driver in OpenWrt which use an
> RMII PHY have a dedicated oscillator on the board which provides the
> 50MHz RMII reference clock.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: lantiq_gswip: Don't set GSWIP_MII_CFG_RMII_CLK
    https://git.kernel.org/netdev/net/c/71cffebf6358

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


