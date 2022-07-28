Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92820583648
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 03:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbiG1BaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 21:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbiG1BaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 21:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C668213D12
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 18:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82D0CB822BF
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D7BBC433D7;
        Thu, 28 Jul 2022 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658971813;
        bh=6M7LPl7AVnCuHvCFPetCs1ladM55LdMMFJo6wjlBxDI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=REo/EZHHHcGvY39+WHiNa5bXSx4zmZcyn5+pOp5swUOpO+61nahDP92LxxTOxrV/w
         JvZq0qFf5cX9G2awZIG7TqtfKYaEOo6Y564CLqRuhaxZRBpaLNVnvQe65bBnoo/v5N
         HMbnrYdJPHtzDWuX7n4N/42zSRqTUFK8w5pUiAb4QnMkptoJAEV0fOFcjiOZo2nWnl
         19C3GMddnEf0fYxSaI3OMTfE/rOKGt/zYwmVYanelSnNUxiZevv/CCH0DScRlSg26L
         708mHKjFgz7YBYXiuX8plLknZ+QEhpw6sstbpIhf+VFK8rL6/paq/w2HbApEtNYU3v
         InMKwtyCxalmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2272EC43142;
        Thu, 28 Jul 2022 01:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] sfc: disable softirqs for ptp TX
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165897181313.2015.11008674774502875788.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jul 2022 01:30:13 +0000
References: <20220726064504.49613-1-alejandro.lucero-palau@amd.com>
In-Reply-To: <20220726064504.49613-1-alejandro.lucero-palau@amd.com>
To:     <alejandro.lucero-palau@amd.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-net-drivers@amd.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        edumazet@google.com, fw@strlen.de
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Jul 2022 08:45:04 +0200 you wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Sending a PTP packet can imply to use the normal TX driver datapath but
> invoked from the driver's ptp worker. The kernel generic TX code
> disables softirqs and preemption before calling specific driver TX code,
> but the ptp worker does not. Although current ptp driver functionality
> does not require it, there are several reasons for doing so:
> 
> [...]

Here is the summary with links:
  - [v3,net] sfc: disable softirqs for ptp TX
    https://git.kernel.org/netdev/net/c/67c3b611d92f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


