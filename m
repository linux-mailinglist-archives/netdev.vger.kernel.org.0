Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99B5675479
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 13:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjATMa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 07:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjATMa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 07:30:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E09A8392
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F3665CE2835
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 12:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12E5BC4339B;
        Fri, 20 Jan 2023 12:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674217821;
        bh=/OrI3bpuToECiMq3/45P1mPqtzEjEwZ5hlGzs8+uGdQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DjqKZicrekBw+IcikoX9odjabRZEv9HvTKKGY088okuW45tAkDj9+8IGHErkCl6wa
         d/j6Zs5vlamWsyX/2wu10cEj+EGu8FJBVQc9pQsUqMPbes8AtU8aSxl8tVxFStOcxK
         OEDSBmKcyJozFocMkaRZDv8Ot3GaAMeDajVoAdb/MdIHam9Tpb87pnub77Y3rVAXO+
         8WngJVE7t8xPUu85nvHxTjobZU60/sySgkNZPTbqvxeYkXCrw/jTcXo2EILucTrxx4
         vEriRn5+oaSgfzKaLGKrqY6oQns19ikM9zFvMxDTT5jIjAGnL/UMk2/siX5B5XHyIw
         oTMazNkMbIOTw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1313C395DC;
        Fri, 20 Jan 2023 12:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15][pull request] Intel Wired LAN Driver Updates
 2023-01-19 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167421782091.21057.1590442445820967127.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 12:30:20 +0000
References: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 19 Jan 2023 13:27:27 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Tsotne and Anatolii implement new handling, and AdminQ command, for
> firmware LLDP, adding a pending notification to allow for proper
> cleanup between TC changes.
> 
> Amritha extends support for drop action outside of switchdev.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] ice: Add 'Execute Pending LLDP MIB' Admin Queue command
    https://git.kernel.org/netdev/net-next/c/a4f68f37e63f
  - [net-next,02/15] ice: Handle LLDP MIB Pending change
    https://git.kernel.org/netdev/net-next/c/7d8d7754e6f7
  - [net-next,03/15] ice: Support drop action
    https://git.kernel.org/netdev/net-next/c/390889a4b40e
  - [net-next,04/15] ice: restrict PTP HW clock freq adjustments to 100, 000, 000 PPB
    https://git.kernel.org/netdev/net-next/c/8aa4318c3a12
  - [net-next,05/15] ice: remove redundant non-null check in ice_setup_pf_sw()
    https://git.kernel.org/netdev/net-next/c/d5a6df44375c
  - [net-next,06/15] ice: add missing checks for PF vsi type
    https://git.kernel.org/netdev/net-next/c/6a8d013e904a
  - [net-next,07/15] ice: Add support for 100G KR2/CR2/SR2 link reporting
    https://git.kernel.org/netdev/net-next/c/2481e8207748
  - [net-next,08/15] ice: combine cases in ice_ksettings_find_adv_link_speed()
    https://git.kernel.org/netdev/net-next/c/9d20797fcdab
  - [net-next,09/15] ice: Remove cppcheck suppressions
    https://git.kernel.org/netdev/net-next/c/df2a4c3f6530
  - [net-next,10/15] ice: Move support DDP code out of ice_flex_pipe.c
    https://git.kernel.org/netdev/net-next/c/2ffd87d38d6b
  - [net-next,11/15] ice: Reduce scope of variables
    https://git.kernel.org/netdev/net-next/c/bd557d97978e
  - [net-next,12/15] ice: Explicitly return 0
    https://git.kernel.org/netdev/net-next/c/91dbcb91d006
  - [net-next,13/15] ice: Match parameter name for ice_cfg_phy_fc()
    https://git.kernel.org/netdev/net-next/c/388740b3f63d
  - [net-next,14/15] ice: Introduce local var for readability
    https://git.kernel.org/netdev/net-next/c/643ef23bd9dd
  - [net-next,15/15] ice: Remove excess space
    https://git.kernel.org/netdev/net-next/c/d52a6180c746

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


