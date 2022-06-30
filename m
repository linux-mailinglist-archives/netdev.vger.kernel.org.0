Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8DD562256
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 20:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235898AbiF3SuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 14:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbiF3SuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 14:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355482AC7E
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 11:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C169462274
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 18:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FE0AC341CD;
        Thu, 30 Jun 2022 18:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656615014;
        bh=nnzz3Q4PmOyX9205wlPt8jKNWrmyzDiECkiW3iUHiV8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lhj7Ikcw8fWEwSSYchpUlrZWgOKV+ztdPKG57NTVX5ztMbpRXqx1m10r8qQcmCnwa
         4XkEi969jlS133pFu/Ox3mwAtjtQo7Ccm8cq7jxtvqLFEdgIYeJQjdbny2Fqlm0SBf
         OLFk98kWcuucJuVmLXTpZKoWbie2BNVDcHviQD6vvymnV3juTPPHwYTk7mAXFnS8X+
         PkJ/Z43Q0NYL49KyHnz/hR7f9Td/310qezxHZUWG64S2OC+zbcUUC2SKCvaekKWNpr
         z3McC3NWX9s7G5sa+w1+i/T0RP2Cs4gHbmfJe/E+7KN4vQ640E4mghltzyAhXtczts
         BHUpzyjquR+hw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 01C2AE49BBB;
        Thu, 30 Jun 2022 18:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: felix: fix race between reading PSFP stats and
 port stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165661501400.16120.15157252523300924647.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 18:50:14 +0000
References: <20220629183007.3808130-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220629183007.3808130-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiaoliang.yang_1@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, fido_max@inbox.ru,
        colin.foster@in-advantage.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Jun 2022 21:30:07 +0300 you wrote:
> Both PSFP stats and the port stats read by ocelot_check_stats_work() are
> indirectly read through the same mechanism - write to STAT_CFG:STAT_VIEW,
> read from SYS:STAT:CNT[n].
> 
> It's just that for port stats, we write STAT_VIEW with the index of the
> port, and for PSFP stats, we write STAT_VIEW with the filter index.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: felix: fix race between reading PSFP stats and port stats
    https://git.kernel.org/netdev/net/c/58bf4db69528

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


