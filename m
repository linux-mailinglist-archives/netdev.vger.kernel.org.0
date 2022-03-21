Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24E34E2509
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 12:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243740AbiCULLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 07:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346630AbiCULLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 07:11:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB362393C9;
        Mon, 21 Mar 2022 04:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 946ADB81259;
        Mon, 21 Mar 2022 11:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D5ADC340F5;
        Mon, 21 Mar 2022 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647861010;
        bh=Q66QSD+oXVd4pgUkFcd3/42N83l4FkWMoGBDNJ743lo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CERtJwVzZYSVZwivluxuMHPIx6aE+4rthrzsn2cocXgVi0gts6Pdq2fNs/YNHnmLh
         ffJel/Qkdfg+lAsGI/bdJFI2NIgQNBItdQRAmCZw2JiJJ9gkOybfA7pSkdwqw5F8C9
         Oh9cDVl+ZgHSx1WrUyUTzv4A36Oxbs+dPEQOUOOT3ZeVAZmKAZJQHugjYSuL0g5/XZ
         /TSr0Zx3xVErrsW7x/cntASOfosRfCIYfeKjqCGrn/xESYacrrYr3Fztbi7qw227y9
         AORn6qgE5NUQv2nIwQYdrTztvVDXt4emEQfRaBc9VB8SeuJ+Frg+yWDAC/ai2lNXWI
         vYDDBbu/fjT/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30D5DF0383F;
        Mon, 21 Mar 2022 11:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netlabel: fix out-of-bounds memory accesses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164786101019.12168.17918424530007349763.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 11:10:10 +0000
References: <20220318063508.1348148-1-wangyufen@huawei.com>
In-Reply-To: <20220318063508.1348148-1-wangyufen@huawei.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     paul@paul-moore.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 18 Mar 2022 14:35:08 +0800 you wrote:
> In calipso_map_cat_ntoh(), in the for loop, if the return value of
> netlbl_bitmap_walk() is equal to (net_clen_bits - 1), when
> netlbl_bitmap_walk() is called next time, out-of-bounds memory accesses
> of bitmap[byte_offset] occurs.
> 
> The bug was found during fuzzing. The following is the fuzzing report
>  BUG: KASAN: slab-out-of-bounds in netlbl_bitmap_walk+0x3c/0xd0
>  Read of size 1 at addr ffffff8107bf6f70 by task err_OH/252
> 
> [...]

Here is the summary with links:
  - [net-next] netlabel: fix out-of-bounds memory accesses
    https://git.kernel.org/netdev/net-next/c/f22881de730e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


