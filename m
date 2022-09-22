Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CF85E582F
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiIVBkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiIVBkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:40:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EB17B297;
        Wed, 21 Sep 2022 18:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1F02B832D4;
        Thu, 22 Sep 2022 01:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27BA3C433B5;
        Thu, 22 Sep 2022 01:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663810817;
        bh=+pbXaovXEyZF6fqekCm4UyEw6yPZrVj8IXtW9wqsmkQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JeH5mgG2PNR6CVxTlqPM0xog+MD+a0O8olnoyeNeb/lccbIClkm2YPI6oCBY28c8H
         25zH/nPcwCHYkt0x4FMlv9QIqvrQz8QGT5crGSDe2UI2QcyIj35BgI0ZtQrxU9ktX7
         WiTLRIHxraB+s7DAT4Eu0VtZEdk95CNlLr2aK6HoYKX9Yj2yOORuT12Co1alXORVJf
         9DjHAKUdCUbH5TuQST0itsWRqiRzFgJ/ldzfxvtdLbBRQh4z+JqSQHQCZHEA6lvKK7
         Z9zJV7xGiDfvoElTXjwlgg63TThM+RzOs/URS0nglvhAO79vPj7GJ9SXjZaye3ZsjP
         9jMBd2ngyLL8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 03F98E21ECF;
        Thu, 22 Sep 2022 01:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net-next 0/2] clean up ocelot_reset() routine
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166381081701.5452.11098307943209592493.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 01:40:17 +0000
References: <20220917175127.161504-1-colin.foster@in-advantage.com>
In-Reply-To: <20220917175127.161504-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 17 Sep 2022 10:51:25 -0700 you wrote:
> ocelot_reset() will soon be exported to a common library to be used by
> the ocelot_ext system. This will make error values from regmap calls
> possible, so they must be checked. Additionally, readx_poll_timeout()
> can be substituted for the custom loop, as a simple cleanup.
> 
> I don't have hardware to verify this set directly, but there shouldn't
> be any functional changes.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] net: mscc: ocelot: utilize readx_poll_timeout() for chip reset
    https://git.kernel.org/netdev/net-next/c/21bb08cd2cda
  - [v2,net-next,2/2] net: mscc: ocelot: check return values of writes during reset
    https://git.kernel.org/netdev/net-next/c/fa1d90b048c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


