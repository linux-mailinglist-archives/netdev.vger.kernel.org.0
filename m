Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2905A4BC5
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiH2M1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiH2M07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:26:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E782B19001
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 05:10:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C60D4B80FAF
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6CCF5C43140;
        Mon, 29 Aug 2022 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661775017;
        bh=KxM7HV1FWpRTJD1i9WP1VYbIARUVb9yIcdUS+sqs9ew=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h6DDX26Q9CrXrQ41apMtDCbiI9IsFJnjr2ziAdSUlGSnFORYKlRWTjlXVzjp6Yapt
         bAinMBpQqpUUsyfXvZB/kZmSHeS0fXqbCj2j+yfj107mHz0HUs2+9avbIOei6VAckA
         3abKtBnnuxXztf0qYI3HoveJY+HSUfstvICT90Vlxn0s9Zg2b8mCdZi+13KOeL3GsD
         QGe2psWBO+SBcdhPDm0/967M/r0aAN8K7Nlgs0rkkQXXTTHxrpCYwG4UKz2eU2tWHf
         PCHKIOCnE48xcc8ZzuP7jV2IB0o/y/Cs7XFyE/M4j3NiiPmGjPeciL0FnIZcJ1fqLG
         /2KVP9ODI67XA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 55EDCE924D4;
        Mon, 29 Aug 2022 12:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/3] net: sparx5: add mrouter support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166177501734.22813.8476681912767231646.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Aug 2022 12:10:17 +0000
References: <20220825092837.907135-1-casper.casan@gmail.com>
In-Reply-To: <20220825092837.907135-1-casper.casan@gmail.com>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Thu, 25 Aug 2022 11:28:34 +0200 you wrote:
> This series adds support for multicast router ports to SparX5. To manage
> mrouter ports the driver must keep track of mdb entries. When adding an
> mrouter port the driver has to iterate over all mdb entries and modify
> them accordingly.
> 
> v2:
> - add bailout in free_mdb
> - re-arrange mdb struct to avoid holes
> - change devm_kzalloc -> kzalloc
> - change GFP_ATOMIC -> GFP_KERNEL
> - fix spelling
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/3] ethernet: Add helpers to recognize addresses mapped to IP multicast
    https://git.kernel.org/netdev/net-next/c/e8013f8edaa3
  - [v2,net-next,2/3] net: sparx5: add list for mdb entries in driver
    https://git.kernel.org/netdev/net-next/c/c8a3ea43b5cb
  - [v2,net-next,3/3] net: sparx5: add support for mrouter ports
    https://git.kernel.org/netdev/net-next/c/04e551d66dd8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


