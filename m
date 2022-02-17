Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC314B97D4
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 05:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbiBQEk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 23:40:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbiBQEk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 23:40:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40203284216;
        Wed, 16 Feb 2022 20:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9417B820F6;
        Thu, 17 Feb 2022 04:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6108FC340EC;
        Thu, 17 Feb 2022 04:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645072809;
        bh=SQie68LtRJwl6pfaDF+fS7AfThug4tVyYsyf5TnnDHk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hu1z+s5TJUTiOBBG6qj4KsIbqwHJn8CImpT8ZxGQs8I0X8ABWw3xjZoGW0mCb6E3R
         dEk3IHHjfuo58mRzDBHomA20lqgcAt8PgYKo+8SpqAznvnQomU00wFLCv4QDk7JK1q
         xjzCk3cEnvOaEv5Ysry4HwGDKJ+uv3kzEohmUEXtnuIT2Nnja2hauxSHgDozI185bI
         ZQEdm53zAzi5QtyS7sa3PTzjf7ggi324TdjgCS7JeiGrErZkH2+uU+MTS+zrc2ALHh
         WMP7OoYXeAVDorjxFcvawulYf/XCYodFkvuWXBuwab+1ivRTdq0ZRxTYttnGxLvjXn
         VfE3XH4mox8Kg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 463A6E7BB07;
        Thu, 17 Feb 2022 04:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: bridge: multicast: notify switchdev driver
 whenever MC processing gets disabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164507280928.19778.1810833319273321601.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 04:40:09 +0000
References: <20220215165303.31908-1-oleksandr.mazur@plvision.eu>
In-Reply-To: <20220215165303.31908-1-oleksandr.mazur@plvision.eu>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     roopa@nvidia.com, razor@blackwall.org, davem@davemloft.net,
        kuba@kernel.org, ivecera@redhat.com, yotamg@mellanox.com,
        nogahf@mellanox.com, jiri@mellanox.com, taras.chornyi@plvision.eu,
        volodymyr.mytnyk@plvision.eu, mickeyr@marvell.com,
        nikolay@nvidia.com, bridge@lists.linux-foundation.org,
        vladimir.oltean@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Feb 2022 18:53:03 +0200 you wrote:
> Whenever bridge driver hits the max capacity of MDBs, it disables
> the MC processing (by setting corresponding bridge option), but never
> notifies switchdev about such change (the notifiers are called only upon
> explicit setting of this option, through the registered netlink interface).
> 
> This could lead to situation when Software MDB processing gets disabled,
> but this event never gets offloaded to the underlying Hardware.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: bridge: multicast: notify switchdev driver whenever MC processing gets disabled
    https://git.kernel.org/netdev/net/c/c832962ac972

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


