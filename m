Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80706BC559
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCPElC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjCPElA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:41:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3A4ABB38
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 21:40:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4913561F25
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 04:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB8F3C4339B;
        Thu, 16 Mar 2023 04:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678941620;
        bh=a8MrIMvwk1IosZpepL54EHZL8KJvCRAecOKLvo5mudA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Juz+dW8k7TsHDQ0o47zoPU50+BYQ1dphW9/z9X2BlAFtfMeKH4Iy01NiO38i01ooI
         +qxVlgihAFNQ3w3Wzjq8Zx41bxC0BRnBUxkgccVEwW+Ni2DuqEuoOxAWjhoeVDbBYq
         LUNQTu0UCDJuTz8XTU0Aa9oYmyZHEQwPVnwTGJCRUUgWKPpC+gGluDvag11iLAsKlx
         XbMripqSCoYaI1BHFbdFF9bt9NApdu7odvxEyVi61ApAO2oIslgnVbgRXQA/cBwo2m
         jjplN9zDmCHIw5On8aQtkXJZgCk54uv7ZGuD+7DtBXF7v42lYGAHuyV8s3d05X+6o/
         3hE4ECbadeywA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C4D4E66CBB;
        Thu, 16 Mar 2023 04:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/14][pull request] ice: refactor mailbox overflow
 detection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167894162063.2389.8463430158338725225.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 04:40:20 +0000
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        jacob.e.keller@intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 13 Mar 2023 11:21:09 -0700 you wrote:
> Jake Keller says:
> 
> The primary motivation of this series is to cleanup and refactor the mailbox
> overflow detection logic such that it will work with Scalable IOV. In
> addition a few other minor cleanups are done while I was working on the
> code in the area.
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] ice: re-order ice_mbx_reset_snapshot function
    https://git.kernel.org/netdev/net-next/c/504ce971f260
  - [net-next,02/14] ice: convert ice_mbx_clear_malvf to void and use WARN
    https://git.kernel.org/netdev/net-next/c/28756d9ec93e
  - [net-next,03/14] ice: track malicious VFs in new ice_mbx_vf_info structure
    https://git.kernel.org/netdev/net-next/c/e4eaf8938852
  - [net-next,04/14] ice: move VF overflow message count into struct ice_mbx_vf_info
    https://git.kernel.org/netdev/net-next/c/8cd8a6b17d27
  - [net-next,05/14] ice: remove ice_mbx_deinit_snapshot
    https://git.kernel.org/netdev/net-next/c/4bdf5f258331
  - [net-next,06/14] ice: merge ice_mbx_report_malvf with ice_mbx_vf_state_handler
    https://git.kernel.org/netdev/net-next/c/07cc1a942216
  - [net-next,07/14] ice: initialize mailbox snapshot earlier in PF init
    https://git.kernel.org/netdev/net-next/c/dde7db637d99
  - [net-next,08/14] ice: declare ice_vc_process_vf_msg in ice_virtchnl.h
    https://git.kernel.org/netdev/net-next/c/33b035e70611
  - [net-next,09/14] ice: always report VF overflowing mailbox even without PF VSI
    https://git.kernel.org/netdev/net-next/c/4f0636fef61a
  - [net-next,10/14] ice: remove unnecessary &array[0] and just use array
    https://git.kernel.org/netdev/net-next/c/3f22fc3131b8
  - [net-next,11/14] ice: pass mbxdata to ice_is_malicious_vf()
    https://git.kernel.org/netdev/net-next/c/afc24d6584fb
  - [net-next,12/14] ice: print message if ice_mbx_vf_state_handler returns an error
    https://git.kernel.org/netdev/net-next/c/4508bf02bf8a
  - [net-next,13/14] ice: move ice_is_malicious_vf() to ice_virtchnl.c
    https://git.kernel.org/netdev/net-next/c/c414463ab1bb
  - [net-next,14/14] ice: call ice_is_malicious_vf() from ice_vc_process_vf_msg()
    https://git.kernel.org/netdev/net-next/c/be96815c6168

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


