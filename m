Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DF3562B26
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 08:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiGAGAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 02:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbiGAGAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 02:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDDE6B27F;
        Thu, 30 Jun 2022 23:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D3DE6227C;
        Fri,  1 Jul 2022 06:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2A42C341CA;
        Fri,  1 Jul 2022 06:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656655214;
        bh=47E4M9JOzrqiA0X3UNMYZxEMTUR7SPIMTad7EZfslh8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nhwR1ymjC8H5pX1vUDxt+HWj9tKXVU77oBPUebPjJuPuhTWYmiWQ5sFKTb50AJav3
         BDGsBcKaDxkSEsgvW7B29E6FpzP45SvM1ezEL0c/MGoiIfXlToMKFOEXK6KcCZzTVv
         pw3j6AIdov5yfpStrOWg/9Kz9GlELeoWmeuaDEem2P/ye1FpI/7vPfz/UaHej23q1w
         RNWvzklWpAzbNZlD/VfVNgJ49TVvnpjw8FoY4SpWhvEq5f5ib9mHgTZ8U5cOtyFwIr
         LZEI+VxnTAsmmxJ09w4Kco9eff/XgbR6ldQh0ACSxPMgVce5xDy+28y9WTo6eu7yQN
         wiN9UIac1CD0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9E4A2E49FA0;
        Fri,  1 Jul 2022 06:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/4] Prevent permanently closed tc-taprio gates
 from blocking a Felix DSA switch port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165665521464.30449.14354184109113080227.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 06:00:14 +0000
References: <20220628145238.3247853-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220628145238.3247853-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiaoliang.yang_1@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, michael@walle.cc,
        vinicius.gomes@intel.com, fido_max@inbox.ru,
        colin.foster@in-advantage.com, richard.pearn@nxp.com,
        linux-kernel@vger.kernel.org, luto@kernel.org, tglx@linutronix.de,
        vincenzo.frascino@arm.com
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Jun 2022 17:52:34 +0300 you wrote:
> v1->v2:
> - define PSEC_PER_NSEC in include/linux/time64.h rather than
>   include/vdso/time64.h
> - add missing #include <linux/time.h> to users of PSEC_PER_NSEC
> - move the PSEC_PER_NSEC consolidation to the last patch
> 
> Richie Pearn reports that if we install a tc-taprio schedule on a Felix
> switch port, and that schedule has at least one gate that never opens
> (for example TC0 below):
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/4] net: dsa: felix: keep reference on entire tc-taprio config
    https://git.kernel.org/netdev/net-next/c/1c9017e44af2
  - [v2,net-next,2/4] net: dsa: felix: keep QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF) out of rmw
    https://git.kernel.org/netdev/net-next/c/d68a373bfbf4
  - [v2,net-next,3/4] net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port
    https://git.kernel.org/netdev/net-next/c/55a515b1f5a9
  - [v2,net-next,4/4] time64.h: consolidate uses of PSEC_PER_NSEC
    https://git.kernel.org/netdev/net-next/c/837ced3a1a5d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


