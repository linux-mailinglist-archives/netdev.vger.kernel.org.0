Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC54F68D589
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 12:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjBGLbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 06:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbjBGLbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 06:31:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1085539291;
        Tue,  7 Feb 2023 03:30:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7CC06CE1D78;
        Tue,  7 Feb 2023 11:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 328C4C4339B;
        Tue,  7 Feb 2023 11:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675769418;
        bh=8y3WhzO7sDBgy3Fsq/THsijwl9HUGqvh/0JBaNiMwgY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pCEgFp2Uyf2sNaALJcWNh21vAj7u/+3KBmMPBMvLCIJN7w5eae+iLMEhxPzk2zLd+
         F9134uLDV3tIoivS4thLWZIU7MLK7IX3rDZTve7wdIzTvZFsL2tECOX7fGA4yA5S8Q
         3MsdQZMvNpuTfLEWghw1AN52kFeX6HlaoGDKg6qRWfrIZueqhmPFVC9QrGmfYz57Ug
         dZUoBNlZtO6rxanNWL+QasyWqyBEM4/zpfzaEPJY0HvoKtnCYupX1NfUfonPdib2sm
         WFB1P8//NOzA/BXO5ji+uakCBbMOr+6So1G5thKEncTTIAcpuinZc2YLs5YCip5SqJ
         Qd5Wu3EAS5FAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15C26E55F07;
        Tue,  7 Feb 2023 11:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] net: mscc: ocelot: fix VCAP filters not matching on
 MAC with "protocol 802.1Q"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167576941808.4371.16125260499189510076.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Feb 2023 11:30:18 +0000
References: <20230205192409.1796428-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230205192409.1796428-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        richard.pearn@nxp.com, xiaoliang.yang_1@nxp.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun,  5 Feb 2023 21:24:08 +0200 you wrote:
> Alternative short title: don't instruct the hardware to match on
> EtherType with "protocol 802.1Q" flower filters. It doesn't work for the
> reasons detailed below.
> 
> With a command such as the following:
> 
> tc filter add dev $swp1 ingress chain $(IS1 2) pref 3 \
> 	protocol 802.1Q flower skip_sw vlan_id 200 src_mac $h1_mac \
> 	action vlan modify id 300 \
> 	action goto chain $(IS2 0 0)
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: mscc: ocelot: fix VCAP filters not matching on MAC with "protocol 802.1Q"
    https://git.kernel.org/netdev/net/c/f964f8399df2
  - [net,2/2] selftests: ocelot: tc_flower_chains: make test_vlan_ingress_modify() more comprehensive
    https://git.kernel.org/netdev/net/c/bbb253b206b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


