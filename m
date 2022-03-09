Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118A34D2D66
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 11:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiCIKvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 05:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiCIKvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 05:51:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12B2F68FD
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 02:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D236617B9
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 10:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9482C340EE;
        Wed,  9 Mar 2022 10:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646823011;
        bh=3Dvssk1nwkKURgWhwZV1kKPwFgZ3VzHCGD6msoMjSDY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sBVl3SMUVoI40AEEF0P1E61gNsmLfvcsMZEibxvbcUFeCuwA4iz8hbv5r/dvR23Yp
         1odgQ3uDRd9QgjTzJbozGQpmaxXmzdTaze08LO9i0ArLjVGT3aY9hiZa97kXqdq/tD
         P/YJ0pFemQlt6+C/xsxi6r99NeRFQehJniEsj8tI//ayGidhYix6Hy2Fz63LiUdvo2
         aNP5qG//LNlPTLQKvruhciRIPlRnRgqGGG3UqDuEODVvDsIIoqt2d/Xfr9l0NNZ/8Z
         z2rxCwOM+tWXPYK1jGevivTvqKKWqGJXFk0mQZBbOuArZvSg8lPhMIWNYfKhiP/sIs
         NST6roxT82Vew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9DB13E7BB08;
        Wed,  9 Mar 2022 10:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/7] iavf: Fix handling of vlan strip virtual channel
 messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164682301164.2489.3475199917504058485.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 10:50:11 +0000
References: <20220308234513.1089152-2-anthony.l.nguyen@intel.com>
In-Reply-To: <20220308234513.1089152-2-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.maloszewski@intel.com,
        netdev@vger.kernel.org, sassmann@redhat.com,
        norbertx.ciosek@intel.com, konrad0.jankowski@intel.com
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

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue,  8 Mar 2022 15:45:07 -0800 you wrote:
> From: Michal Maloszewski <michal.maloszewski@intel.com>
> 
> Modify netdev->features for vlan stripping based on virtual
> channel messages received from the PF. Change is needed
> to synchronize vlan strip status between PF sysfs and iavf ethtool.
> 
> Fixes: 5951a2b9812d ("iavf: Fix VLAN feature flags after VFR")
> Signed-off-by: Norbert Ciosek <norbertx.ciosek@intel.com>
> Signed-off-by: Michal Maloszewski <michal.maloszewski@intel.com>
> Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> [...]

Here is the summary with links:
  - [net,v2,1/7] iavf: Fix handling of vlan strip virtual channel messages
    https://git.kernel.org/netdev/net/c/2cf29e558948
  - [net,v2,2/7] iavf: Fix adopting new combined setting
    https://git.kernel.org/netdev/net/c/57d03f5608c3
  - [net,v2,3/7] i40e: stop disabling VFs due to PF error responses
    https://git.kernel.org/netdev/net/c/5710ab791665
  - [net,v2,4/7] ice: stop disabling VFs due to PF error responses
    https://git.kernel.org/netdev/net/c/79498d5af8e4
  - [net,v2,5/7] ice: Fix error with handling of bonding MTU
    https://git.kernel.org/netdev/net/c/97b0129146b1
  - [net,v2,6/7] ice: Don't use GFP_KERNEL in atomic context
    https://git.kernel.org/netdev/net/c/3d97f1afd8d8
  - [net,v2,7/7] ice: Fix curr_link_speed advertised speed
    https://git.kernel.org/netdev/net/c/ad35ffa252af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


