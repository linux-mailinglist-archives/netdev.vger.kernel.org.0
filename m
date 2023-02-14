Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1C46957B3
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 05:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjBNEKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 23:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBNEKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 23:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2272B17CE4;
        Mon, 13 Feb 2023 20:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD8FB61411;
        Tue, 14 Feb 2023 04:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A04FC433EF;
        Tue, 14 Feb 2023 04:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676347817;
        bh=6YgtRESLJOJZw+w5fV3y/DLtb3rrTBK9V/y4YdS0XvU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TOftPHmCxZzmJE/bfGv8jV5niigTTok3GmcLCpoZLhsswswNj23ryqEDG6VQItFeB
         X3DRZiUNZwo+JjUxlf/nSFEYi67lzDdImNFQwh6Sooc3Gt3qoQFN7KVl4VyBCJVOuz
         Pv4vZleM1HUbegZB/TCy9eEs70NwZzcce9oG22r5VEjHrT4p8IMLOIg7m9b49U8qz1
         S7vQeoShHi/R9N1Zbl8cw5jfv0h0Lo9jIi0rd7onPn0vZaCK2hg3V+rDFKDlPe1MKp
         eu1oJWsAba58nYwjvpkoJDVjIILEH5JhKo/1igFkv0+05Nd0K6yUZ0Y5w+opCf1Dec
         pe07R5iuOjoqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DDDA6E270C2;
        Tue, 14 Feb 2023 04:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: fix order of dwmac5 FlexPPS parametrization
 sequence
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167634781689.18399.674406359781053459.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Feb 2023 04:10:16 +0000
References: <20230210143937.3427483-1-j.zink@pengutronix.de>
In-Reply-To: <20230210143937.3427483-1-j.zink@pengutronix.de>
To:     Johannes Zink <j.zink@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        kernel@pengutronix.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 10 Feb 2023 15:39:37 +0100 you wrote:
> So far changing the period by just setting new period values while
> running did not work.
> 
> The order as indicated by the publicly available reference manual of the i.MX8MP [1]
> indicates a sequence:
> 
>  * initiate the programming sequence
>  * set the values for PPS period and start time
>  * start the pulse train generation.
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: fix order of dwmac5 FlexPPS parametrization sequence
    https://git.kernel.org/netdev/net/c/4562c65ec852

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


