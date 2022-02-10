Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309964B0BEE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 12:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240643AbiBJLKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 06:10:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235688AbiBJLKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 06:10:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCB0BE4
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 03:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AB3AB8252E
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 11:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7BA6C340ED;
        Thu, 10 Feb 2022 11:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644491411;
        bh=UAsNtLz3oX2b98GhRqN1dguSx9rgTQV6AJh2ed4kAkA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d2BxuWyEjRNpu5oJSyOvH1kCKGiwVkyRfnN3epRLBF4fWPmDc1pKuVRQrjv51dr2o
         CzWg/8ZEPPYornCsOXHBgwy4iMXmbAx6hNgOztTPZ91UeaoT1OIwGrQfOcJ+oV1DcE
         8pMbWDATC5bIXdDLaCFzpOETUnBFe8MaKZdRbKdHeo7lObOWeoiFJHhC/Rb23JEH8t
         fyHog4rlWEipfo2POE8zuMoVoQ0RMRy1Jsorb1XOTzsmNl8Z6NsK4qtmlX4XEb2QHN
         6mfyrSqwnffhyNf7HBdC3Npd6zhViyc3xffiiWP5yaUs4/eyDah9KgJ9mbi0A3lYut
         8zjoK5Dago6qA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5EF3E6BB38;
        Thu, 10 Feb 2022 11:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/14][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-02-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164449141180.11194.2379774120470963586.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 11:10:11 +0000
References: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  9 Feb 2022 13:56:52 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Brett adds support for QinQ. This begins with code refactoring and
> re-organization of VLAN configuration functions to allow for
> introduction of VSI VLAN ops to enable setting and calling of
> respective operations based on device support of single or double
> VLANs. Implementations are added for outer VLAN support.
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] ice: Refactor spoofcheck configuration functions
    https://git.kernel.org/netdev/net-next/c/daf4dd16438b
  - [net-next,02/14] ice: Add helper function for adding VLAN 0
    https://git.kernel.org/netdev/net-next/c/3e0b59714bd4
  - [net-next,03/14] ice: Add new VSI VLAN ops
    https://git.kernel.org/netdev/net-next/c/bc42afa95487
  - [net-next,04/14] ice: Introduce ice_vlan struct
    https://git.kernel.org/netdev/net-next/c/fb05ba1257d7
  - [net-next,05/14] ice: Refactor vf->port_vlan_info to use ice_vlan
    https://git.kernel.org/netdev/net-next/c/a19d7f7f0122
  - [net-next,06/14] ice: Use the proto argument for VLAN ops
    https://git.kernel.org/netdev/net-next/c/2bfefa2dab6b
  - [net-next,07/14] ice: Adjust naming for inner VLAN operations
    https://git.kernel.org/netdev/net-next/c/7bd527aa174f
  - [net-next,08/14] ice: Add outer_vlan_ops and VSI specific VLAN ops implementations
    https://git.kernel.org/netdev/net-next/c/c31af68a1b94
  - [net-next,09/14] ice: Add hot path support for 802.1Q and 802.1ad VLAN offloads
    https://git.kernel.org/netdev/net-next/c/0d54d8f7a16d
  - [net-next,10/14] ice: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2
    https://git.kernel.org/netdev/net-next/c/cc71de8fa133
  - [net-next,11/14] ice: Support configuring the device to Double VLAN Mode
    https://git.kernel.org/netdev/net-next/c/a1ffafb0b4a4
  - [net-next,12/14] ice: Advertise 802.1ad VLAN filtering and offloads for PF netdev
    https://git.kernel.org/netdev/net-next/c/1babaf77f49d
  - [net-next,13/14] ice: Add support for 802.1ad port VLANs VF
    https://git.kernel.org/netdev/net-next/c/cbc8b5645a4b
  - [net-next,14/14] ice: Add ability for PF admin to enable VF VLAN pruning
    https://git.kernel.org/netdev/net-next/c/f1da5a0866bc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


