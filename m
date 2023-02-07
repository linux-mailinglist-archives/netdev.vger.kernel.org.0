Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BC968CF90
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 07:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjBGGkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 01:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjBGGkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 01:40:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D741B222E7;
        Mon,  6 Feb 2023 22:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 272EE611E4;
        Tue,  7 Feb 2023 06:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73EA1C4339E;
        Tue,  7 Feb 2023 06:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675752019;
        bh=bYinYxrxMzNff9GwoV9XpG4Jeml5L5gmOF07qXSk5Xw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PKCUHDVg2UmfUaSMb9iQWO/2yIUvpZ+p+P31oy0zxSbnMV9QlQsHYEttwEI3oExgO
         uQEEHADFWGolk4CWI7vttgGpcwFKtR2CebGh6J2sOXmOvIB51mqr+yEVBP8PJ7RNuj
         iDBZ/blHi6bhxczh+yZPA+o0qdNLEwMaU9X8R8a5Y6BVKJ6lhi5+VUeUbY46CNc9ql
         8Uq1DtdB5fsOIeEVCQx6lKisbnzVlyX3inr425PoLsE078KkXoMZA+qQaBpxXZnCLl
         QqKLepjl/OQUaj5wm3IGGld7ywJ1FZp0rlAjevECiQAb5qY1cRwT8XvuQOJ8IZHUEG
         duYezo9Nhr7gw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A1EBE21ECC;
        Tue,  7 Feb 2023 06:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: mscc: ocelot: un-export unused regmap
 symbols
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167575201936.385.1755989454407061210.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Feb 2023 06:40:19 +0000
References: <20230204182056.25502-1-colin.foster@in-advantage.com>
In-Reply-To: <20230204182056.25502-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, richardcochran@gmail.com, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  4 Feb 2023 10:20:56 -0800 you wrote:
> There are no external users of the vsc7514_*_regmap[] symbols or
> vsc7514_vcap_* functions. They were exported in commit 32ecd22ba60b ("net:
> mscc: ocelot: split register definitions to a separate file") with the
> intention of being used, but the actual structure used in commit
> 2efaca411c96 ("net: mscc: ocelot: expose vsc7514_regmap definition") ended
> up being all that was needed.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: mscc: ocelot: un-export unused regmap symbols
    https://git.kernel.org/netdev/net-next/c/b1ca2f1b04b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


