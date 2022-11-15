Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8AA962997F
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 14:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiKONAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 08:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238215AbiKONAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 08:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3C11788D
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3399261740
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 13:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BF33C43147;
        Tue, 15 Nov 2022 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668517215;
        bh=VF4Q0WzM2CiusNuMpims9Ot44VyD7qu0aefy2AZtTrc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IOc4juoSaRS0kNtR75y9p6+leOkIdF5fXg8yWFZC0vOqlbdNhHQqKHWBGDC4mQopX
         w4mJcad/3OWFJw2qy7Pv63eZbXvnJZwDGbUEySZ/2gSEOMYeTwXpoN5i3TeEi60GSL
         U9kfF4QBSvmVkPuFT7dPZyJBnqmjzIqRveADH2+z5NhzzxzCPnE82Vydb1/+Ydm0dU
         2gGb37WxNfhMCvIxnWJ7UAEszIdJ/JfW3MqXTpnypMy9N+mTP0bGNUWYUTt7v7leUg
         NpD9SMnEGcZimDthraXkrQ6mGhOt5Xp/yxs6lKiLpCUpf+vRFIrrf/Hs7RD3GIwOSM
         f49eHOE2Mjpew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 685A8E21EFB;
        Tue, 15 Nov 2022 13:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bridge: switchdev: Fix memory leaks when changing VLAN
 protocol
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166851721541.14988.2851505012033520291.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Nov 2022 13:00:15 +0000
References: <20221114084509.860831-1-idosch@nvidia.com>
In-Reply-To: <20221114084509.860831-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, vladbu@nvidia.com,
        roopa@nvidia.com, razor@blackwall.org, mlxsw@nvidia.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 14 Nov 2022 10:45:09 +0200 you wrote:
> The bridge driver can offload VLANs to the underlying hardware either
> via switchdev or the 8021q driver. When the former is used, the VLAN is
> marked in the bridge driver with the 'BR_VLFLAG_ADDED_BY_SWITCHDEV'
> private flag.
> 
> To avoid the memory leaks mentioned in the cited commit, the bridge
> driver will try to delete a VLAN via the 8021q driver if the VLAN is not
> marked with the previously mentioned flag.
> 
> [...]

Here is the summary with links:
  - [net] bridge: switchdev: Fix memory leaks when changing VLAN protocol
    https://git.kernel.org/netdev/net/c/9d45921ee4cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


