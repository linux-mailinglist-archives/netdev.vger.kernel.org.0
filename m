Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2044DA2D6
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 20:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351195AbiCOTB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 15:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351187AbiCOTB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 15:01:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C421750E36
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 12:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70E2DB81893
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 19:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0AC7C340F7;
        Tue, 15 Mar 2022 19:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647370812;
        bh=/cI8f/RhPkEdAv0b3kVylkH5JlUE1mEV8Pyvyv1IdHk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cUZKuJ+kuv9hbiB6mulo433u9gQ+XpnZQcMVRlggLVa3TMWXkiT5p5RfiJuzSMuUg
         wZLPKrpOshvCrRwORy8sf8/jv0zf4Pwwa2jxrKcFACfTHlXUsyag8emLcggY/9C/Pm
         bw4WJmjY9+GjQpPn0FxGp57seQY1ye2E6dbfQOOFUHu8oMfMGB8Ow/fx26ia6nWmI/
         FjVWmGz1LLOZxhlQnVR0rMW3KYAyT0Vw6YCpj1jx56CkZq6OgFDpzy6YGxsmS4zDXw
         AJ7CQAxG9Z8+loqikwyQmpD2n7hG45I9XizSzzS7iU+5RIHsP9xJkOYZClY4yAxtyl
         OF4COmjdpoI/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A14FF03841;
        Tue, 15 Mar 2022 19:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mscc: ocelot: fix build error due to missing
 IEEE_8021QAZ_MAX_TCS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164737081260.13795.1784032870489014411.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Mar 2022 19:00:12 +0000
References: <20220315131215.273450-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220315131215.273450-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Mar 2022 15:12:15 +0200 you wrote:
> IEEE_8021QAZ_MAX_TCS is defined in include/uapi/linux/dcbnl.h, which is
> included by net/dcbnl.h. Then, linux/netdevice.h conditionally includes
> net/dcbnl.h if CONFIG_DCB is enabled.
> 
> Therefore, when CONFIG_DCB is disabled, this indirect dependency is
> broken.
> 
> [...]

Here is the summary with links:
  - [net-next] net: mscc: ocelot: fix build error due to missing IEEE_8021QAZ_MAX_TCS
    https://git.kernel.org/netdev/net-next/c/72f56fdb97b2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


