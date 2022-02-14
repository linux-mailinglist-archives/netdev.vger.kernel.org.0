Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA154B51E5
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 14:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354497AbiBNNkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 08:40:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiBNNkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 08:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793B25714E
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 05:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 281C1B80EBD
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 13:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC6E0C340EF;
        Mon, 14 Feb 2022 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644846009;
        bh=KsQgzR2rmti1gCQ/r9YjjyFmrbWzp2/3Mm6FYU1Hz0k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oIDTTUdwi0vzUQkdGlseH/62ICL3qgDl2HE8rosAldQliatViqno7/2ZgcnUaIDkA
         MA9Y+WYxaOlu783UZald5arDQ2AnRxhM/vXlKVO4QEf5VZHu0fOllfkjxZxPYC3J8A
         KEaIhh8XZ1wT2UU5ZPGBNsHcY+KzH2Yld/35Vjdw84xcqg8u8Zr875zSJTDT6LkQuo
         gr6RKFm7LIHHpvV7XAEmfuti/6GzL973wRcZIDq6m4OuyZsNvUX6R1gzQSvuncH8jO
         DJpIQZjpnDK3TwJJ5KyND24E+kzTDCJ3JmwxKOQckh17CRMjQ3nBK66SfWHw/VbA9v
         X22yK43pPhyng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B569CE6D458;
        Mon, 14 Feb 2022 13:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: flush switchdev FDB workqueue before
 removing VLAN
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164484600973.23487.8886750074489246883.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 13:40:09 +0000
References: <20220211174506.3874409-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220211174506.3874409-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, rafael.richter@gin.de, daniel.klauer@gin.de
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Feb 2022 19:45:06 +0200 you wrote:
> mv88e6xxx is special among DSA drivers in that it requires the VTU to
> contain the VID of the FDB entry it modifies in
> mv88e6xxx_port_db_load_purge(), otherwise it will return -EOPNOTSUPP.
> 
> Sometimes due to races this is not always satisfied even if external
> code does everything right (first deletes the FDB entries, then the
> VLAN), because DSA commits to hardware FDB entries asynchronously since
> commit c9eb3e0f8701 ("net: dsa: Add support for learning FDB through
> notification").
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mv88e6xxx: flush switchdev FDB workqueue before removing VLAN
    https://git.kernel.org/netdev/net/c/a2614140dc0f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


