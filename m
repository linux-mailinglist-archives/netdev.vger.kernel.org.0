Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DED6EBFB7
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 15:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjDWNUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 09:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDWNUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 09:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F584E63;
        Sun, 23 Apr 2023 06:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AF2D61127;
        Sun, 23 Apr 2023 13:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BBE6C433D2;
        Sun, 23 Apr 2023 13:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682256020;
        bh=v0kIUN2KeUVtv834UWdMBEC3h8ScLO+1wTqlK/Kjlew=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hZ80bHCYJyAOTe2RjOjG93iH2mG9m4C5S5Lho5ChoDnUEav84NZfno5HJPtO1dvfe
         C8C5x+ecS6kvt0hjiyWubJHNPWIU3kqUdAahgM5NWGFBqjTHsEHCZZ6ualPKWCxW7Z
         ATGdsqK1I0fMKSI0NhSe3eoPkVMDsKVcWM1zpnLuD2gv1WSNJlA40eEFHbR9uQYUzg
         I1asBdokwi0XpueRBbChEHr1TOyNplMChd9x8Aru1ANcbRLkrXouscbOsm6Mf0H1Pw
         +/MyxYOMrXfcSlpD5Lo+FXRNEX2TQfYayUqPVFnw3bmbw7pFde7eJXNyfdEIMuqPzk
         Ny1buu0s2SxBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3C7E9C395C8;
        Sun, 23 Apr 2023 13:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/9] Remove skb_mac_header() dependency in DSA
 xmit path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168225602024.29216.4761574559092982747.git-patchwork-notify@kernel.org>
Date:   Sun, 23 Apr 2023 13:20:20 +0000
References: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        madalin.bucur@nxp.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Apr 2023 01:55:52 +0300 you wrote:
> Eric started working on removing skb_mac_header() assumptions from the
> networking xmit path, and I offered to help for DSA:
> https://lore.kernel.org/netdev/20230321164519.1286357-1-edumazet@google.com/
> 
> The majority of this patch set is a straightforward replacement of
> skb_mac_header() with skb->data (hidden either behind skb_eth_hdr(), or
> behind skb_vlan_eth_hdr()). The only patch which is more "interesting"
> is 9/9.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/9] net: vlan: don't adjust MAC header in __vlan_insert_inner_tag() unless set
    https://git.kernel.org/netdev/net-next/c/f90615ada0b1
  - [v2,net-next,2/9] net: vlan: introduce skb_vlan_eth_hdr()
    https://git.kernel.org/netdev/net-next/c/1f5020acb33f
  - [v2,net-next,3/9] net: dpaa: avoid one skb_reset_mac_header() in dpaa_enable_tx_csum()
    https://git.kernel.org/netdev/net-next/c/e2fdfd711912
  - [v2,net-next,4/9] net: dsa: tag_ocelot: do not rely on skb_mac_header() for VLAN xmit
    https://git.kernel.org/netdev/net-next/c/eabb1494c9f2
  - [v2,net-next,5/9] net: dsa: tag_ksz: do not rely on skb_mac_header() in TX paths
    https://git.kernel.org/netdev/net-next/c/499b2491d550
  - [v2,net-next,6/9] net: dsa: tag_sja1105: don't rely on skb_mac_header() in TX paths
    https://git.kernel.org/netdev/net-next/c/f9346f00b5af
  - [v2,net-next,7/9] net: dsa: tag_sja1105: replace skb_mac_header() with vlan_eth_hdr()
    https://git.kernel.org/netdev/net-next/c/b5653b157e55
  - [v2,net-next,8/9] net: dsa: update TX path comments to not mention skb_mac_header()
    https://git.kernel.org/netdev/net-next/c/f0a9d563064c
  - [v2,net-next,9/9] net: dsa: tag_ocelot: call only the relevant portion of __skb_vlan_pop() on TX
    https://git.kernel.org/netdev/net-next/c/0bcf2e4aca6c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


