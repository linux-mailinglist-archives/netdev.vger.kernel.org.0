Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3A74DAE43
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 11:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355113AbiCPKbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 06:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243190AbiCPKba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 06:31:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1562E5DE69
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 03:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA8D9B81A64
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 10:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E3FCC340F0;
        Wed, 16 Mar 2022 10:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647426613;
        bh=vgfsW+wPV2X2GWMdav5BFOF5ZJnNNsYkL7x7zdpnhtw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uzK2J250OTXCbLvLi8Dj8tD8zExJMwH4F7CqKPzLADAfPP9KdikdOsCprqaeecSBm
         yKmekU1Dxt0XRTuK7AJFuxcGOwqf4aPEEYux5wTrGV1hy2rbIXjez90+Otc5lY8WIR
         R+Kf2Zke9cQfPlp8YxmtEN36GriAwshzD8bjZqaTTMkLkIdA4blNioyEBXUpTVk1DK
         bNreoquAOg2PxLqffdf3h0DE1os1XNGXe4FyaNmRUyRv8lbqd7PA9M2MX0dBnzlAKc
         nuTc4iJ5mK8Ty8NVojWGbiDFFqLJA7T5wuycugkCEnG7rh2v+Grae4wfH4wiz/viAK
         MjsT5wrDePmRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42B75E6D3DD;
        Wed, 16 Mar 2022 10:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/14][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-03-15
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164742661326.25444.18220941374715825016.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Mar 2022 10:30:13 +0000
References: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, jacob.e.keller@intel.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 15 Mar 2022 15:22:06 -0700 you wrote:
> Jacob Keller says:
> 
> The ice_sriov.c file now houses almost all of the virtualization code in the
> ice driver. This includes both Single Root specific implementation as well
> as generic functionality such as the virtchnl interface.
> 
> We are planning to implement support for Scalable IOV in the ice driver in
> the future. This implementation will want to use the generic functionality
> in ice_sriov.c
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] ice: introduce ice_vf_lib.c, ice_vf_lib.h, and ice_vf_lib_private.h
    https://git.kernel.org/netdev/net-next/c/109aba47ca9b
  - [net-next,02/14] ice: fix incorrect dev_dbg print mistaking 'i' for vf->vf_id
    https://git.kernel.org/netdev/net-next/c/f5840e0da639
  - [net-next,03/14] ice: introduce VF operations structure for reset flows
    https://git.kernel.org/netdev/net-next/c/9c6f787897f6
  - [net-next,04/14] ice: fix a long line warning in ice_reset_vf
    https://git.kernel.org/netdev/net-next/c/5de95744ff6a
  - [net-next,05/14] ice: move reset functionality into ice_vf_lib.c
    https://git.kernel.org/netdev/net-next/c/16686d7fbbe4
  - [net-next,06/14] ice: drop is_vflr parameter from ice_reset_all_vfs
    https://git.kernel.org/netdev/net-next/c/dac57288751c
  - [net-next,07/14] ice: make ice_reset_all_vfs void
    https://git.kernel.org/netdev/net-next/c/fe99d1c06c16
  - [net-next,08/14] ice: convert ice_reset_vf to standard error codes
    https://git.kernel.org/netdev/net-next/c/4fe193cc9dd0
  - [net-next,09/14] ice: convert ice_reset_vf to take flags
    https://git.kernel.org/netdev/net-next/c/7eb517e434c6
  - [net-next,10/14] ice: introduce ICE_VF_RESET_NOTIFY flag
    https://git.kernel.org/netdev/net-next/c/9dbb33da1236
  - [net-next,11/14] ice: introduce ICE_VF_RESET_LOCK flag
    https://git.kernel.org/netdev/net-next/c/f5f085c01d26
  - [net-next,12/14] ice: cleanup long lines in ice_sriov.c
    https://git.kernel.org/netdev/net-next/c/8cf52bec5ca0
  - [net-next,13/14] ice: introduce ice_virtchnl.c and ice_virtchnl.h
    (no matching commit)
  - [net-next,14/14] ice: remove PF pointer from ice_check_vf_init
    https://git.kernel.org/netdev/net-next/c/5a57ee83d961

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


