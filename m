Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FC0630B90
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbiKSDx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbiKSDxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:53:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9312C285E
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 19:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E328F6284C
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3DC83C433D7;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668829818;
        bh=WuBERht+HDnmJYitbTbpjb4TbLEmyuSyWMht+Ct6ABE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h7uljxzl6NQXKc/5GJjAx+M6qQ7wWkMrrEd94x4i2zhkCCeED0uco6W4f7HMaVDOC
         Z13kIA1/bWmUmKNcjIbGcawOrV3DU14cbFgy7ldNbdtlGBBhahtF9ZjoGmmYhHsadq
         MvD5YqG5jn7coJMcE1+R457CQJwTPaRuWbOpZRk3XhnKq0+NLAKv9lqhdb5Zh/jjQ+
         0Z3o98dhzxh/oa8diSv3Ifjv4YT3J4LqCJa/BVnTOHbnq5//k3n7tDK9g5SB1PyCxQ
         ksUSHW+4oDLUR7srU6qgUFLnN1uIBJOVm6ak4VEWJQGVtE3pDNGOgZs52uZg/zOlsZ
         YV4IyjDvcnCFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 26666E4D017;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv4 net] bonding: fix ICMPv6 header handling when receiving IPv6
 messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166882981815.27279.7611867364193696030.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Nov 2022 03:50:18 +0000
References: <20221118034353.1736727-1-liuhangbin@gmail.com>
In-Reply-To: <20221118034353.1736727-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jtoppins@redhat.com, pabeni@redhat.com,
        dsahern@gmail.com, tom@herbertland.com, edumazet@google.com,
        liali@redhat.com, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 18 Nov 2022 11:43:53 +0800 you wrote:
> Currently, we get icmp6hdr via function icmp6_hdr(), which needs the skb
> transport header to be set first. But there is no rule to ask driver set
> transport header before netif_receive_skb() and bond_handle_frame(). So
> we will not able to get correct icmp6hdr on some drivers.
> 
> Fix this by using skb_header_pointer to get the IPv6 and ICMPV6 headers.
> 
> [...]

Here is the summary with links:
  - [PATCHv4,net] bonding: fix ICMPv6 header handling when receiving IPv6 messages
    https://git.kernel.org/netdev/net/c/4d633d1b468b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


