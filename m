Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E832B6240FC
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 12:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiKJLKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 06:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiKJLKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 06:10:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A13C6F340
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 03:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D49DB82170
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 11:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C07ADC433D7;
        Thu, 10 Nov 2022 11:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668078614;
        bh=GzYclDh4u2Z1oMYCEvrMPng12cvgV1aE2sWx2u50mEE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n97UlQn4NzKRoch+e1+Un2pEXwNejEGP+ismJPxyEtnZzunuIxQosQqEVi5nMHLgV
         E4GrzO9Wff6nAjwOZk/mAhgAzSQan2z6F53D+K/LqNUU/+IDD0XJhiG+M9kjFHblEA
         sthJGfjnxKntAO18aLyhEVKkwLCvokfKH8vEpbRKVReE6hebYiiI13loFdPvyf/yK8
         6iQXOKrVrDlsZqIFWULj3Fl2ZAIB4RAh6Edf/UyrCdWWJPlCF2IuYLhfEx0Rg4AWMQ
         FEfElUk3ntfG0E+t/xvZC+VGfG51giRCCXWDCpjmBmtPzUnIqMsK2phjsGG+bNHV4h
         9ITMx2fplhVvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6BE5C395F8;
        Thu, 10 Nov 2022 11:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] macsec: clear encryption keys in h/w drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166807861467.26157.1927496799417807435.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 11:10:14 +0000
References: <20221108153459.811293-1-atenart@kernel.org>
In-Reply-To: <20221108153459.811293-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, sd@queasysnail.net, irusskikh@marvell.com,
        netdev@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  8 Nov 2022 16:34:57 +0100 you wrote:
> Hello,
> 
> Commit aaab73f8fba4 ("macsec: clear encryption keys from the stack after
> setting up offload") made sure to clean encryption keys from the stack
> after setting up offloading but some h/w drivers did a copy of the key
> which need to be zeroed as well.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: phy: mscc: macsec: clear encryption keys when freeing a flow
    https://git.kernel.org/netdev/net/c/1b16b3fdf675
  - [net,2/2] net: atlantic: macsec: clear encryption keys from the stack
    https://git.kernel.org/netdev/net/c/879785def0f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


