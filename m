Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB3D5B36B7
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 13:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiIILuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 07:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiIILuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 07:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127908B98B;
        Fri,  9 Sep 2022 04:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1E5D619F4;
        Fri,  9 Sep 2022 11:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE932C433D7;
        Fri,  9 Sep 2022 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662724215;
        bh=uy5XQ1qVprhoZbKSfCQ44KUvLeF3EGSNA/jvAc5x2/s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uEQTNHIMP1kLVF09Hnd584eyOEajiUvu1/6vTHIsv9pd8NpQQ/MRWErxlyrqwJpCT
         KBgne8kCM8hSoqwO/2lhhi9teqhUFt5MM3fSLecVhsGBkGnRyDzFvm3SRd7phDTOMC
         aOXOKcIs7nA2/jCThsOslif+Rq0rNTizBQVz5ymyqEtahC1lOUtwRni2KYJ2YeoDYm
         wz0YtHCMBBLLSNfTjA9nr4btAmGdqMIXuZdGdeeUgLiU4bc91XjaTFUQCFwbgG1JLY
         pM3OcHLNxP20YGB4vFDBELDdDWCubSApb84zAoKjFO7nmOpzHWmd1U1Jx1NXd4fl2H
         AtkVa/W23WvAQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D381AE1CABD;
        Fri,  9 Sep 2022 11:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipvlan: Fix out-of-bound bugs caused by unset
 skb->mac_header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166272421486.25944.8198403867606791696.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Sep 2022 11:50:14 +0000
References: <20220907101204.255213-1-luwei32@huawei.com>
In-Reply-To: <20220907101204.255213-1-luwei32@huawei.com>
To:     Lu Wei <luwei32@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vulab@iscas.ac.cn, maheshb@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Wed, 7 Sep 2022 18:12:04 +0800 you wrote:
> If an AF_PACKET socket is used to send packets through ipvlan and the
> default xmit function of the AF_PACKET socket is changed from
> dev_queue_xmit() to packet_direct_xmit() via setsockopt() with the option
> name of PACKET_QDISC_BYPASS, the skb->mac_header may not be reset and
> remains as the initial value of 65535, this may trigger slab-out-of-bounds
> bugs as following:
> 
> [...]

Here is the summary with links:
  - [net] ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header
    https://git.kernel.org/netdev/net/c/81225b2ea161

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


