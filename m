Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4294D2DFB
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 12:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiCILbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 06:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbiCILbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 06:31:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0485014FBD6
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 03:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 924046184B
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02270C340F3;
        Wed,  9 Mar 2022 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646825413;
        bh=0iSQd7ZEtTyj3hjQ1xIP0cyZ2vXbvrn5At3cGNfQR5g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AlsDQ2hopsDfcE5Tz88ZhZiMD3W4Ds7dqgcwzHBUaML0WXcAp6n3aWpdAGUmqst77
         xFhOwnmDA0DA4XGNPC8SyqEiVK7YcoDXb+INAGIEO3kx1F6DMi/YJp3/0cgnRHfiy1
         UfXdhqVGyKCtwvYU3iNc1nc03ffekZ6HgwCOyBlD4TvhFcTZtmjjUsrn1RLwaq9zdI
         /8ln//9PsBmM7lwAiORjsbf4xX6PYwtHFF7BkJHAmvWJqwKbdDbIR1dkuvC0d2os8S
         cE+9SQS+0M42t+pxbh0WEPDFQSdE2p+mu4vSOQ8hfwA6HL7zQLQ2G8LXhLrxkoiTZt
         fYeinp1X/jDRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7516E8DD5B;
        Wed,  9 Mar 2022 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] Incremental fixups for DSA unicast filtering
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164682541287.22286.5287815676964235776.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 11:30:12 +0000
References: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alsi@bang-olufsen.dk
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  8 Mar 2022 11:15:09 +0200 you wrote:
> There are some bugs I've discovered in the recently merged "DSA unicast
> filtering" series:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220302191417.1288145-1-vladimir.oltean@nxp.com/
> 
> First bug is the dereference of an uninitialized list (dp->fdbs) when
> the "initial" tag protocol is placed in the device tree for the Felix
> switch driver. This is a scenario I hadn't tested. It is handled by
> patches 1-3.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: dsa: warn if port lists aren't empty in dsa_port_teardown
    https://git.kernel.org/netdev/net-next/c/0832cd9f1f02
  - [net-next,2/6] net: dsa: move port lists initialization to dsa_port_touch
    https://git.kernel.org/netdev/net-next/c/fe95784fb14e
  - [net-next,3/6] net: dsa: felix: drop "bool change" from felix_set_tag_protocol
    https://git.kernel.org/netdev/net-next/c/c69f40ac6006
  - [net-next,4/6] net: dsa: be mostly no-op in dsa_slave_set_mac_address when down
    https://git.kernel.org/netdev/net-next/c/e2d0576f0c00
  - [net-next,5/6] net: dsa: felix: actually disable flooding towards NPI port
    https://git.kernel.org/netdev/net-next/c/f2e2662ccf48
  - [net-next,6/6] net: dsa: felix: avoid early deletion of host FDB entries
    https://git.kernel.org/netdev/net-next/c/7e580490ac98

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


