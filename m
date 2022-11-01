Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6090161439B
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 04:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiKADUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 23:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiKADUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 23:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84C26570;
        Mon, 31 Oct 2022 20:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5A7DB81B91;
        Tue,  1 Nov 2022 03:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F7CAC433C1;
        Tue,  1 Nov 2022 03:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667272816;
        bh=a/FO9/6TWnVQ+N3gM7SDqQzsKmU5zKCTl0KHacLdzJQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tT/BoTnO6lQOfIM9qobeOVjHVaXalvlowxUsXRgR4+ik1CFP//3VlhZGcLD5vPzlg
         9X1HiSEeFuIItvhvtSkd861nBip2n5qZzplZaRAZmo0FAe+noEfWgz1DR5iXYHIsww
         MYAUSE6sliNyA2se/JRjTZ0Sr8oUvmBSI1+OfSljwqpvUkEPbKBVftMfTLEOEPxl63
         VlhpHAXSCpc+UF681W1WYUQQ+//y0lCYBLkHvZ2uWR7ktNj6x+XTuPOCflLEj1cl47
         Yw4MtH6vVl1HS20nmXmAts+AyUfK1k8R9nZCucSnp5cksmfgkGQDPJZY+71fDAQIhs
         KWEtRGvUeVI7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 14816E50D71;
        Tue,  1 Nov 2022 03:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: tun: fix bugs for oversize packet when napi frags
 enabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166727281607.6120.17368468270995736765.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Nov 2022 03:20:16 +0000
References: <20221029094101.1653855-1-william.xuanziyang@huawei.com>
In-Reply-To: <20221029094101.1653855-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan (William) <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterpenkov96@gmail.com,
        maheshb@google.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 29 Oct 2022 17:41:01 +0800 you wrote:
> Recently, we got two syzkaller problems because of oversize packet
> when napi frags enabled.
> 
> One of the problems is because the first seg size of the iov_iter
> from user space is very big, it is 2147479538 which is bigger than
> the threshold value for bail out early in __alloc_pages(). And
> skb->pfmemalloc is true, __kmalloc_reserve() would use pfmemalloc
> reserves without __GFP_NOWARN flag. Thus we got a warning as following:
> 
> [...]

Here is the summary with links:
  - [net,v2] net: tun: fix bugs for oversize packet when napi frags enabled
    https://git.kernel.org/netdev/net/c/363a5328f4b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


