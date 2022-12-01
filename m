Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FDB63E8F9
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 05:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiLAEua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 23:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiLAEuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 23:50:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF758983A7;
        Wed, 30 Nov 2022 20:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50C9861BC2;
        Thu,  1 Dec 2022 04:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 933DBC43143;
        Thu,  1 Dec 2022 04:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669870216;
        bh=KGus3DEVSCkNwKgnG+34eJNWEcvAksc8hT/r7f+ntGY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=afvlJLMRc34lP/sa+XWk1fxy4U8yG+Mv4SQG4cCBmX/iG8vRYsWDvdb9jcpIf/e1Z
         Pz1/d08hwmyOrA+TNqQRUy7sPrMmZz6rCwrBkIfipxPvnOD+fLxtrVmnhqEcGhZ+a+
         a0uCaWwf1zOgRiW/Rtw89MdQRXHEIRLsx360ZYet3sfzkA+LrLvrZtVr00xNOF0Nwi
         xIedtweDrOeECvYgcL7K5hXkMywQtuq2Wbxo6+uauUhoc9M++BHUNTxLv8oDKNKB5U
         EvBHIBQyhcF1DzfAXkOek/y31Hyawuv4qSodOohnpslpR00Hp9Bart83OhZtK8SzA/
         m3/L8KQestmUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79AA1E50D64;
        Thu,  1 Dec 2022 04:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/5] octeontx2-af: Fix a potentially spurious error message
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166987021649.2850.15484096041241790130.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 04:50:16 +0000
References: <5ce01c402f86412dc57884ff0994b63f0c5b3871.1669378798.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <5ce01c402f86412dc57884ff0994b63f0c5b3871.1669378798.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 25 Nov 2022 13:23:57 +0100 you wrote:
> When this error message is displayed, we know that the all the bits in the
> bitmap are set.
> 
> So, bitmap_weight() will return the number of bits of the bitmap, which is
> 'table->tot_ids'.
> 
> It is unlikely that a bit will be cleared between mutex_unlock() and
> dev_err(), but, in order to simplify the code and avoid this possibility,
> just take 'table->tot_ids'.
> 
> [...]

Here is the summary with links:
  - [1/5] octeontx2-af: Fix a potentially spurious error message
    https://git.kernel.org/netdev/net-next/c/2450d7d93fd2
  - [2/5] octeontx2-af: Slightly simplify rvu_npc_exact_init()
    https://git.kernel.org/netdev/net-next/c/b6a0ecaee2e6
  - [3/5] octeontx2-af: Use the bitmap API to allocate bitmaps
    https://git.kernel.org/netdev/net-next/c/05a7b52ee5e4
  - [4/5] octeontx2-af: Fix the size of memory allocated for the 'id_bmap' bitmap
    https://git.kernel.org/netdev/net-next/c/6d135d9e2b00
  - [5/5] octeontx2-af: Simplify a size computation in rvu_npc_exact_init()
    https://git.kernel.org/netdev/net-next/c/450f06505396

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


