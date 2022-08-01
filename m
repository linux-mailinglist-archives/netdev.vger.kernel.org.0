Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133B55871BB
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbiHATuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbiHATuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DB7FCD;
        Mon,  1 Aug 2022 12:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DC9C61346;
        Mon,  1 Aug 2022 19:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4742C433D7;
        Mon,  1 Aug 2022 19:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659383413;
        bh=XbMu4u7qC681Oufg6pCEm6FQOATQp4hHLAqIxj8axgM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SLFLmUC5jqcVenV89Nrn74jXFdib/t/Lx6eMfh+TM2Icy/INYG/Tp7DnTOootOVBX
         OTe4DpfB4cGVL35DGzHlC7kZmpz0j062ECkrEGfug6oILhJBGFJpYtAeE2Ezto/SUC
         uWPifFX/DQsgVh19zZA377A0+vjDbhDWmJhlsxzgO5MH6BBjuZuq2f9+WsW+kCXRRZ
         ph3GDfCAclM4yQCEZoh19jAGXyLt9WwYHVLmRl7wi5OBcTVPq5GgRbQy2Oz99NhsiL
         lLbVYLrqOBmLHlDfgoIYrbEdmDuOllWeIQ/ryz6mV0nQpMEK1C3x9UbyYAraya2Kp3
         uGmqE7HEPlrOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99EB1C43140;
        Mon,  1 Aug 2022 19:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: fix using wrong flags to check features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165938341362.9721.5948160417702328560.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 19:50:13 +0000
References: <20220729101755.4798-1-huangguangbin2@huawei.com>
In-Reply-To: <20220729101755.4798-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, snelson@pensando.io, brett@pensando.io,
        drivers@pensando.io, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 29 Jul 2022 18:17:53 +0800 you wrote:
> We find that some drivers may use wrong flags to check features, so fix
> them.
> 
> Jian Shen (2):
>   net: ice: fix error NETIF_F_HW_VLAN_CTAG_FILTER check in
>     ice_vsi_sync_fltr()
>   net: ionic: fix error check for vlan flags in ionic_set_nic_features()
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: ice: fix error NETIF_F_HW_VLAN_CTAG_FILTER check in ice_vsi_sync_fltr()
    https://git.kernel.org/netdev/net/c/7dc839fe4761
  - [net,2/2] net: ionic: fix error check for vlan flags in ionic_set_nic_features()
    https://git.kernel.org/netdev/net/c/a86e86db5e6d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


