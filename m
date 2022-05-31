Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F250D538AAB
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 06:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243873AbiEaEkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 00:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiEaEkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 00:40:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D59D939F0;
        Mon, 30 May 2022 21:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16502B80FA8;
        Tue, 31 May 2022 04:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFFDDC3411C;
        Tue, 31 May 2022 04:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653972011;
        bh=qFMOFCDi4rmlh+onSEhdmRDK//H/eJvTtl1RozzJufA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PKvtFMe58ogQyuEcUY5OqRlugS22GnThNSUF3Fnv0czrpbEW6tOODBF/Sgt2icV/n
         l5ulp2nWLiBtYNCP4uI/zYMWRcljZmMoWRepAlyQcPz0p/SokStOSLrdbSbaoBQheL
         Cwt6oUIQWfcTEVfYN8lei3qLqim4JTLZUmk+sQtDajXFRGnAyguQnXMIohZ7fdqOup
         NTwphbaI+7HzsT92v0biYvoCmIwaIc+g1U7NP+wyBxv2UhWIFd7dp9fkvMb05xiuNV
         T3WwTWmOVf7Fs7rIv08qkA+wKMrpcnKE0UikgESGjEzbPSk9BYcvIhjfmZ5E6376oP
         TxT4Vp156Ghdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A33E2E7BA5A;
        Tue, 31 May 2022 04:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: ipv4: Avoid bounds check warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165397201166.21793.15800268803365816812.git-patchwork-notify@kernel.org>
Date:   Tue, 31 May 2022 04:40:11 +0000
References: <20220526101213.2392980-1-zhanggenjian@kylinos.cn>
In-Reply-To: <20220526101213.2392980-1-zhanggenjian@kylinos.cn>
To:     zhanggenjian <zhanggenjian123@gmail.com>
Cc:     pabeni@redhat.com, edumazet@google.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huhai@kylinos.cn
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 26 May 2022 18:12:13 +0800 you wrote:
> From: huhai <huhai@kylinos.cn>
> 
> Fix the following build warning when CONFIG_IPV6 is not set:
> 
> In function ‘fortify_memcpy_chk’,
>     inlined from ‘tcp_md5_do_add’ at net/ipv4/tcp_ipv4.c:1210:2:
> ./include/linux/fortify-string.h:328:4: error: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>   328 |    __write_overflow_field(p_size_field, size);
>       |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [v2] net: ipv4: Avoid bounds check warning
    https://git.kernel.org/netdev/net/c/3a2cd89bfbeb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


