Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C78068E7FD
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 07:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjBHGAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 01:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBHGAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 01:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7879AEB49
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 22:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0838614D5
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 06:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4689FC433D2;
        Wed,  8 Feb 2023 06:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675836019;
        bh=YehzESYJJ9YHxY3vexDs9ki2xLov2CcoHxB3qy3RKCs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s8jglDfTYGWM2m9Cf/tFBsGUCNU94BNBjKCZYJy1pVNHnOvxDt05HN2753I6rRg+Z
         mBQQmP1GkZjcouD17SmXk8WvrMFSsVaQBUSTyOmpk9/y24WKb1DRNFxmgPMHDu/uwm
         uIB4jzGKXN74C49groFi3xn3F26u3WN6fYPgo9mQ2nanjCKDFYtvF+EmTLfFzXFO3e
         f1vvmCkoT/ZI0r/J1alj/yrrbe6kaWLoh1qaePRi9YyEltLAFGhPxhYQ4L124YXPBW
         aXviGNFhCdPwG3PcgXP60JUrvguJYnGcEoMkH0SD23aCau5S9h5AJC3uoN7TgtVBCm
         NAC+D4eofSUTQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C83EE50D62;
        Wed,  8 Feb 2023 06:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/13][pull request] ice: various virtualization
 cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167583601917.31060.6040165620261123739.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 06:00:19 +0000
References: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        jacob.e.keller@intel.com
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

On Mon,  6 Feb 2023 13:48:00 -0800 you wrote:
> Jacob Keller says:
> 
> This series contains a variety of refactors and cleanups in the VF code for
> the ice driver. Its primary focus is cleanup and simplification of the VF
> operations and addition of a few new operations that will be required by
> Scalable IOV, as well as some other refactors needed for the handling of VF
> subfunctions.
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] ice: Add more usage of existing function ice_get_vf_vsi(vf)
    https://git.kernel.org/netdev/net-next/c/772dec645934
  - [net-next,02/13] ice: fix function comment referring to ice_vsi_alloc
    https://git.kernel.org/netdev/net-next/c/a2ca73eae33f
  - [net-next,03/13] ice: drop unnecessary VF parameter from several VSI functions
    https://git.kernel.org/netdev/net-next/c/157acda5b1fa
  - [net-next,04/13] ice: refactor VSI setup to use parameter structure
    https://git.kernel.org/netdev/net-next/c/5e509ab237f1
  - [net-next,05/13] ice: move vsi_type assignment from ice_vsi_alloc to ice_vsi_cfg
    https://git.kernel.org/netdev/net-next/c/e15881970692
  - [net-next,06/13] ice: move ice_vf_vsi_release into ice_vf_lib.c
    https://git.kernel.org/netdev/net-next/c/1efee0734b98
  - [net-next,07/13] ice: Pull common tasks into ice_vf_post_vsi_rebuild
    https://git.kernel.org/netdev/net-next/c/aeead3d04fa0
  - [net-next,08/13] ice: add a function to initialize vf entry
    https://git.kernel.org/netdev/net-next/c/b5dcff1fd57a
  - [net-next,09/13] ice: introduce ice_vf_init_host_cfg function
    https://git.kernel.org/netdev/net-next/c/b1b5694235ef
  - [net-next,10/13] ice: convert vf_ops .vsi_rebuild to .create_vsi
    https://git.kernel.org/netdev/net-next/c/5531bb851fba
  - [net-next,11/13] ice: introduce clear_reset_state operation
    https://git.kernel.org/netdev/net-next/c/fa4a15c85c84
  - [net-next,12/13] ice: introduce .irq_close VF operation
    https://git.kernel.org/netdev/net-next/c/537dfe06acca
  - [net-next,13/13] ice: remove unnecessary virtchnl_ether_addr struct use
    https://git.kernel.org/netdev/net-next/c/e0645311e1ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


