Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18586612051
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 07:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiJ2FKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 01:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiJ2FKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 01:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9942D8C03F
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 22:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3426860B38
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 05:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 952A6C433C1;
        Sat, 29 Oct 2022 05:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667020218;
        bh=fB8QCP3RKUjyLtWwoZRz02xcOnapuIdGpJZEb7bBaQo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OB1TFpPHz1sLY+tKaw/GdmADTnc02TEe6YoI0S7N3/mDgfE+rEXBbwwYAqj/7M2vO
         f8vgn8/A8bAG7YOVb7SGQPn3R981Ok5ueYmeFANxmHNP3V5P4uNOKJ2FJz+AmAIqCE
         Xr/THTrmJW9YvJfhvVjAVdVe+OFeu8uzQ40fL5IFbAXflR8CPiauDgzS0E6vW6M34O
         PG0ny6hgetO/GZJYds8OKQiPlO/M0wy0RGyJfaqbpU/eWvq2+2ls/gqw3IzhjM/RYP
         Fvg/Q+E5wCSWxsqyHaClsXCnJOKMzD07yxAjB9p5jlGuFckzc1LHqshdRnp5r8EnXs
         1R+K+8rX5xj7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7EE05C4166D;
        Sat, 29 Oct 2022 05:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] ice: Add additional CSR registers to
 ETHTOOL_GREGS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166702021851.21650.11843031777644496390.git-patchwork-notify@kernel.org>
Date:   Sat, 29 Oct 2022 05:10:18 +0000
References: <20221027104239.1691549-1-jacob.e.keller@intel.com>
In-Reply-To: <20221027104239.1691549-1-jacob.e.keller@intel.com>
To:     Keller@ci.codeaurora.org, Jacob E <jacob.e.keller@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        lukasz.czapnik@intel.com, mateusz.palczewski@intel.com,
        gurucharanx.g@intel.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Oct 2022 03:42:39 -0700 you wrote:
> From: Lukasz Czapnik <lukasz.czapnik@intel.com>
> 
> In the event of a Tx hang it can be useful to read a variety of hardware
> registers to capture some state about why the transmit queue got stuck.
> 
> Extend the ETHTOOL_GREGS dump provided by the ice driver with several CSR
> registers that provide such relevant information regarding the hardware Tx
> state. This enables capturing relevant data to enable debugging such a Tx
> hang.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] ice: Add additional CSR registers to ETHTOOL_GREGS
    https://git.kernel.org/netdev/net-next/c/637639cbfebb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


