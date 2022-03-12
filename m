Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9064D6E9B
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 13:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiCLMLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 07:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiCLMLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 07:11:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4F110C1
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 04:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A011CB82E4D
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 12:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E6C7C340EB;
        Sat, 12 Mar 2022 12:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647087012;
        bh=6gppKD9PTRrOGkXNjRyAMZHyYnM/XlwCqyXzKFB6Ddg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=It6sCoxByyLG0R/SJROgiodKBKdvKvkr7XZuzZQFpE/jItVbNz5KtwqaXzJSgkdPx
         pjq20o5FVQyonW5iuwuBrka2AV9Isy4aPbQbCOcvV20E8MT0ywrX216lg0LneKHQLT
         hxVHZQ46+5f1yvQ9pD+nIjlGxfIX0rCNdl/IaJxTELEntxkYmMeyr7Q7FibvgZyNN9
         4FhOXo19HTzkQ1GKCFbPBkGR0akhOcIJaAEnatIveFXMGyfbux4gQr9Spr7Y6FcaiK
         y0daJyTSbSuYrqIon2fjfclJe1veD3F614xNYiA+3CVZcDs4E0tdjh0JubZ5RQEYFL
         fbiN7bz4q9v1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 453CDE6D3DD;
        Sat, 12 Mar 2022 12:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v11 0/7][pull request] ice: GTP support in switchdev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164708701228.11169.15700740251869229843.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Mar 2022 12:10:12 +0000
References: <20220311171821.3785992-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220311171821.3785992-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        marcin.szycik@linux.intel.com, michal.swiatkowski@linux.intel.com,
        wojciech.drewek@intel.com, jiri@resnulli.us, pablo@netfilter.org,
        laforge@gnumonks.org, xiyou.wangcong@gmail.com, jhs@mojatatu.com,
        osmocom-net-gprs@lists.osmocom.org
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

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri, 11 Mar 2022 09:18:14 -0800 you wrote:
> Marcin Szycik says:
> 
> Add support for adding GTP-C and GTP-U filters in switchdev mode.
> 
> To create a filter for GTP, create a GTP-type netdev with ip tool, enable
> hardware offload, add qdisc and add a filter in tc:
> 
> [...]

Here is the summary with links:
  - [net-next,v11,1/7] gtp: Allow to create GTP device without FDs
    https://git.kernel.org/netdev/net-next/c/b20dc3c68458
  - [net-next,v11,2/7] gtp: Implement GTP echo response
    https://git.kernel.org/netdev/net-next/c/9af41cc33471
  - [net-next,v11,3/7] gtp: Implement GTP echo request
    https://git.kernel.org/netdev/net-next/c/d33bd757d362
  - [net-next,v11,4/7] net/sched: Allow flower to match on GTP options
    https://git.kernel.org/netdev/net-next/c/e3acda7ade0a
  - [net-next,v11,5/7] gtp: Add support for checking GTP device type
    https://git.kernel.org/netdev/net-next/c/81dd9849fa49
  - [net-next,v11,6/7] ice: Fix FV offset searching
    https://git.kernel.org/netdev/net-next/c/e5dd661b8bb3
  - [net-next,v11,7/7] ice: Support GTP-U and GTP-C offload in switchdev
    https://git.kernel.org/netdev/net-next/c/9a225f81f540

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


