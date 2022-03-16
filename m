Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742BE4DA984
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 06:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353584AbiCPFL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 01:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiCPFL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 01:11:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3430A41FAB;
        Tue, 15 Mar 2022 22:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF965B81A42;
        Wed, 16 Mar 2022 05:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 898B7C340F0;
        Wed, 16 Mar 2022 05:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647407410;
        bh=5+kAqeu0Cft15Amj5f6mU/4PCjSG7a4rbxYBTDwIVEM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UFCZN1Lc6MKr5JaBVxC2vu/BJq2nGG5cq3vxqIIi4UuBQWEbZqi/Q406wQKsr2knF
         nIGgSuvQQjc6Z+pnBrh3hUpnN1OCOA3CyAuYx5m3HzddJZwE9uECTKJH2g7yN1Tx57
         TmIllj5yQ+p8wUlAe+KWg97gQnpzaRrQjOEI1/jm+Wppe3hrh4M4dMor4HO5XyE19b
         P58VLNdyrx2UIlpXdkl1n3KlllfXG3nBKWjJ83GAuAMKtk2k65f8ofykMtMAyrU0nK
         MdfrxqzwXhZwfeNIvuLZlt83XQSGqHp+INlL77gOOUCFu3MchFDzrlgDCqLU2nypxc
         vxbFpOoFVVPog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D583E6D3DD;
        Wed, 16 Mar 2022 05:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] hv_netvsc: Add check for kvmalloc_array
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164740741044.14141.8438133497735845995.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Mar 2022 05:10:10 +0000
References: <20220314020125.2365084-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20220314020125.2365084-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     stephen@networkplumber.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 14 Mar 2022 10:01:25 +0800 you wrote:
> As the potential failure of the kvmalloc_array(),
> it should be better to check and restore the 'data'
> if fails in order to avoid the dereference of the
> NULL pointer.
> 
> Fixes: 6ae746711263 ("hv_netvsc: Add per-cpu ethtool stats for netvsc")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> [...]

Here is the summary with links:
  - [v2] hv_netvsc: Add check for kvmalloc_array
    https://git.kernel.org/netdev/net/c/886e44c9298a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


