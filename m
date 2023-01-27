Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1A967E538
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 13:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbjA0Mab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 07:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbjA0Ma0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 07:30:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0AF7EC9;
        Fri, 27 Jan 2023 04:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D94DB820FD;
        Fri, 27 Jan 2023 12:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47DD5C4339B;
        Fri, 27 Jan 2023 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674822617;
        bh=SbC/boJ/yGBnMY57AJibUvbKncIO3cNQPa+XXxoUvz4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GXeGPdB/MeMPNSe63xjiSIin0YGKacS6rEoENhiU1+/BtSR7fAGAS1irZgdfFwZkg
         MbHfNidm2axRllYFnml8yCUQ/jj3Q65jQLHbTBKYMfrkko9w1qi3EXmXDok0szBAo/
         xq9Jemoo2rqfUiznk2BVwH1mhlyQ+PU37GPV+3M8ubWSRcvBgZjfPGSAoGQp4mtYvi
         qrcnYgdp/NHpUwJvD6IiOOXsv+AdrGeLlAQSZ0HRNBV/1Cttp9Q1T/uNPHYG5T+YWu
         4of9fFC0F5As2Dbne7n4EVUHgsNX6mvF5hxW172zeAFh5zC4+2o9+BIMuHTlWp6tdx
         oRkCFrm02tclg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 332CBC39564;
        Fri, 27 Jan 2023 12:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v3 1/2] net: dsa: qca8k: add QCA8K_ATU_TABLE_SIZE
 define for fdb access
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167482261720.5150.8443955278027273073.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Jan 2023 12:30:17 +0000
References: <20230125203517.947-1-ansuelsmth@gmail.com>
In-Reply-To: <20230125203517.947-1-ansuelsmth@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Wed, 25 Jan 2023 21:35:16 +0100 you wrote:
> Add and use QCA8K_ATU_TABLE_SIZE instead of hardcoding the ATU size with
> a pure number and using sizeof on the array.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
> 
> v3:
> - Add patch
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] net: dsa: qca8k: add QCA8K_ATU_TABLE_SIZE define for fdb access
    https://git.kernel.org/netdev/net-next/c/e03cea60c3db
  - [net-next,v3,2/2] net: dsa: qca8k: convert to regmap read/write API
    https://git.kernel.org/netdev/net-next/c/c766e077d927

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


