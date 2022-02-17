Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914A74B97D3
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 05:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbiBQEk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 23:40:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbiBQEk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 23:40:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F216528423E
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 20:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85FD2B820FD
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 04:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 508DDC340F7;
        Thu, 17 Feb 2022 04:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645072810;
        bh=nibrx+GyO8g/sUisiAT4TW/Q/sMraoUrLeRGK1Kv7HQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R9q87HEQKI1SUhNQhLnJeyOdvBQPlOVqc5pWHwa2Sp63GkoBYNFZq5nXCJqBo9Bqv
         PrCDVq2t89TQrrvK7Hjo//S1r2cf0BGkU6mOgPOKtxT1UhSo/jU+UGPJVEobxJtm+T
         vxqsuhTcvZLIF6tzIMY+ILJ6DD8fOW6Fr6Q+wNIEbNeelvp9/EGAU/zmv1HRAh3F7t
         q5kt5PegTY1bkD2RHCqGZtkRDMq2WsKe0/qZ3lfaStrU5tIyN7zEoyFZWHzejRsH4Y
         9sfs+66rLmXCIk0YRML11glWifs/BFYbF+oePFFpu9M4NkvtnOhlvY1ngSPKo2sw6b
         qUahI0oQLuIMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3C9E8E7BB0A;
        Thu, 17 Feb 2022 04:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: tag_8021q: only call skb_push/skb_pull
 around __skb_vlan_pop
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164507281024.19778.14842934530813295523.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 04:40:10 +0000
References: <20220215204722.2134816-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220215204722.2134816-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        mans@mansr.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Feb 2022 22:47:22 +0200 you wrote:
> __skb_vlan_pop() needs skb->data to point at the mac_header, while
> skb_vlan_tag_present() and skb_vlan_tag_get() don't, because they don't
> look at skb->data at all.
> 
> So we can avoid uselessly moving around skb->data for the case where the
> VLAN tag was offloaded by the DSA master.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: tag_8021q: only call skb_push/skb_pull around __skb_vlan_pop
    https://git.kernel.org/netdev/net-next/c/c8620335951d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


