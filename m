Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3845663A511
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 10:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiK1JaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 04:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiK1JaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 04:30:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E219BB7F3
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 01:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4710061070
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 09:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99C9FC43152;
        Mon, 28 Nov 2022 09:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669627815;
        bh=NfOMV4yCx+EYr4CVHseemlvjSiRBHIJF744l5el2/So=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GiqRdcHXyibAdoUP/+8PsQx8Kmh8ePwZNBiS9SdIE7c4aFJlz45si7+/6u0MZ2sFt
         QGOZM3rOYGCLw4idexlbIjtMsrSIM1PlTVk90RKYKADaTd93YkQy9AWJsVA1PzMD6m
         iPMSLHxJb+uVnKEju2dUhVIQMTdolouwY4m27742AUcbxK6iWxK90B2qXIRAJhyglb
         g4OcwvujM0aay7W1ZCaEUqFztf7f/FACY9MmzmNXYY31jCUfJvFSw+udInc6z0P257
         m5197PHfBWf9KRyQiu9425E5gF5St0LNKbJA/ITCB/41jprmVuxwOXER7rPPCYIL+s
         uRXKiFxKa9oXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76179E270C8;
        Mon, 28 Nov 2022 09:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates
 2022-11-23 (ixgbevf, i40e, fm10k, iavf, e100)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166962781547.31578.12805556389386026918.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Nov 2022 09:30:15 +0000
References: <20221123230406.3562753-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221123230406.3562753-1-anthony.l.nguyen@intel.com>
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

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 23 Nov 2022 15:04:01 -0800 you wrote:
> This series contains updates to various Intel drivers.
> 
> Shang XiaoJing fixes init module error path stop to resource leaks for
> ixgbevf and i40e.
> 
> Yuan Can also does the same for fm10k and iavf.
> 
> [...]

Here is the summary with links:
  - [net,1/5] ixgbevf: Fix resource leak in ixgbevf_init_module()
    https://git.kernel.org/netdev/net/c/8cfa238a48f3
  - [net,2/5] i40e: Fix error handling in i40e_init_module()
    https://git.kernel.org/netdev/net/c/479dd0614942
  - [net,3/5] fm10k: Fix error handling in fm10k_init_module()
    https://git.kernel.org/netdev/net/c/771a794c0a3c
  - [net,4/5] iavf: Fix error handling in iavf_init_module()
    https://git.kernel.org/netdev/net/c/227d8d2f7f22
  - [net,5/5] e100: Fix possible use after free in e100_xmit_prepare
    https://git.kernel.org/netdev/net/c/45605c75c52c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


