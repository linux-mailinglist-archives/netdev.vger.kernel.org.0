Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095404BA304
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241873AbiBQOaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:30:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239248AbiBQOa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:30:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F2C2B167A;
        Thu, 17 Feb 2022 06:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0742261D61;
        Thu, 17 Feb 2022 14:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59568C340E9;
        Thu, 17 Feb 2022 14:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645108211;
        bh=eK6MomQAZ16LYLh7N2nWeAKr5jRAXftA9wakH12THWA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xq322ZOnqhqGhyL+PP4AFuwujUSXbAb6/UlC4h/jjqODutqWscuRT+vCz8CbNifra
         rFY8oEFZ2wvSIvgGnQctisP8Vz577Tu9DX06ULu0lwRWL8I1IRfTsOezL0JyEbjBej
         rtTmPKXsgY70i3jx7ecvnyZLlYGwOXsdinuKCQQeb+3mmtzgTYb6jdqHDeosqz1r9u
         TwrKRQAVpv0o5uA4I0qeumrokKFy3Ysk3JOhBiC996IZyY9dq7NwLiovMBSx5wJQoC
         NMnWAIf/PgsIKjFZCj6S+7M6gbWe7MX7L9qU53/PU6x6s/mSrQBFgpV+9PezmiTfu/
         6/kbdKN6rdT8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E880E7BB07;
        Thu, 17 Feb 2022 14:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] Remove BRENTRY checks from switchdev drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164510821125.30096.6822385772551279625.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 14:30:11 +0000
References: <20220216164752.2794456-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220216164752.2794456-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, horatiu.vultur@microchip.com,
        UNGLinuxDriver@microchip.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, grygorii.strashko@ti.com,
        kgraul@linux.ibm.com, linux-omap@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 16 Feb 2022 18:47:47 +0200 you wrote:
> As discussed here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220214233111.1586715-2-vladimir.oltean@nxp.com/#24738869
> 
> no switchdev driver makes use of VLAN port objects that lack the
> BRIDGE_VLAN_INFO_BRENTRY flag. Notifying them in the first place rather
> seems like an omission of commit 9c86ce2c1ae3 ("net: bridge: Notify
> about bridge VLANs").
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] mlxsw: spectrum: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
    https://git.kernel.org/netdev/net-next/c/ddaff5047003
  - [net-next,2/5] net: lan966x: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
    https://git.kernel.org/netdev/net-next/c/ba43b547515e
  - [net-next,3/5] net: sparx5: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
    https://git.kernel.org/netdev/net-next/c/318994d3e2ab
  - [net-next,4/5] net: ti: am65-cpsw-nuss: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
    https://git.kernel.org/netdev/net-next/c/1d21c327281a
  - [net-next,5/5] net: ti: cpsw: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
    https://git.kernel.org/netdev/net-next/c/5edb65eac10f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


