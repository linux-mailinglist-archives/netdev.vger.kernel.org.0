Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FB2609E29
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiJXJkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiJXJkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58CA36435
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 825FB61018
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 09:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CEEE2C433D7;
        Mon, 24 Oct 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666604415;
        bh=JzdoT4MY66f5zqM/ZpgjLgahnWuV2zXbMajX3IUNhHI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hemmkvQlhEbvdcR+Kh/UFkFU2+TJ7C+XruUIRLwFh1OPM0k+xHoJ9LkKJJXDcS3Yt
         ajOvRDjbZGYkyVfYlqpU1Lssx9qm6l7K8RjcqzxGki5SX1+TEITMjVqhw8E0x/6o9f
         EfcOUtM0BJGEjYC4eiNSJ/d1zNIQJs/4U7Kg6Pjg1U8BvUbK/b5W0wjw7tYZ1IYqAX
         aEw+vDvocVSZOSF6Xi8ani6wm8sTlSxfICEcmj4WkV0M//QAwuaC4BD7gs830eqp5n
         EwBd+8PHfKFPbdoBSCq2cCAaYU9xdY+xCzBaea0/Mq1xjIbyD/6NIKtnjEUkH8m3w0
         NW2NhzohJRk6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AFEE0E270DE;
        Mon, 24 Oct 2022 09:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower: tunnel neigh support bond offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166660441571.21682.6908499368003796088.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 09:40:15 +0000
References: <20221020082834.81724-1-simon.horman@corigine.com>
In-Reply-To: <20221020082834.81724-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        yanguo.li@corigine.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Oct 2022 09:28:34 +0100 you wrote:
> From: Yanguo Li <yanguo.li@corigine.com>
> 
> Support hardware offload when tunnel neigh out port is bond.
> These feature work with the nfp firmware. If the firmware
> supports the NFP_FL_FEATS_TUNNEL_NEIGH_LAG feature, nfp driver
> write the bond information to the firmware neighbor table or
> do nothing for bond. when neighbor MAC changes, nfp driver
> need to update the neighbor information too.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: tunnel neigh support bond offload
    https://git.kernel.org/netdev/net-next/c/abc210952af7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


