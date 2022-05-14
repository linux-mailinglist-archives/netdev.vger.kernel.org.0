Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C492B526F33
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiENBEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 21:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiENBEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 21:04:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9864348DEF;
        Fri, 13 May 2022 17:39:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46832B83251;
        Sat, 14 May 2022 00:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1739C3411D;
        Sat, 14 May 2022 00:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652487014;
        bh=taWX7cesI14fgCKFIUh55h+I5TEy+aQ7dwFOpulVPac=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hiKP/+CH2dQrtQclQpDDLd+wSfqy6IQSdhOlYj36Im7n3WVfgx2YwAxiRoT+My8Fu
         TSNTjbTKO8p3yFdNTWqxb7I/UMSMkX9S9QAYWBVZBwg02564g6ZsGaIrUyuuVVIKN1
         RQgWBLZGxAPEOF3Wx4S0s50pAd47dr0t/B/+RmNEc8RBxkcomWoiy02hxtfjT1G52J
         tpaUr/vGb3VEDA2pSlM2QkWEupO94Bz2FFaN6q2+Vhv4VBQtOarjFK2DIbS9He+FNh
         FSg1kXlNnUygyOmE0xo/aDnaKqQKBwGglcHCUucXY/cDIzjph8nfC7odjkm8WfiG1I
         o9Cw4tpHU2B1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D44CBF03939;
        Sat, 14 May 2022 00:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] ixgbe: add xdp frags support to ndo_xdp_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165248701386.14999.167778541642287959.git-patchwork-notify@kernel.org>
Date:   Sat, 14 May 2022 00:10:13 +0000
References: <20220512212621.3746140-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220512212621.3746140-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, lorenzo@kernel.org, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        sandeep.penigalapati@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 May 2022 14:26:21 -0700 you wrote:
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> Add the capability to map non-linear xdp frames in XDP_TX and ndo_xdp_xmit
> callback.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] ixgbe: add xdp frags support to ndo_xdp_xmit
    https://git.kernel.org/netdev/net-next/c/470bcfd6039b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


