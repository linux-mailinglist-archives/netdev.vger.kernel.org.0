Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28FF5280EF
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 11:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbiEPJkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 05:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiEPJkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 05:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAF32FFDC
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 02:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDB11612C4
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 09:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4DDFAC385B8;
        Mon, 16 May 2022 09:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652694018;
        bh=liXEkumsNkvhrbp+mui1STPmgCqBoLmBbssuC6pziLg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fnzo+MgI/vV6ZhFwGizdAWca9L758czrr9PTHU/LmVQueSPx2gTaFuq74dCvKpUjN
         uct8wbuPms385TFiBH1DBo3C2mD8crmfyTEADRNfc9ZWBb4b+4qpwSPsjAyFhYQ7pD
         4379RaLYh+32zg49rXGj6RvB1W0QdmWgtMO158hJb/MyXPzA8yBT1dmYetMT6yUmB2
         uihToWAsn++y2/ML0umjDOgGZDTTBnDA48al4e+34Qxd0xmeeW7xW/+yMZ5e9VzdJZ
         F8XKmDRMYup+zEMhKYU6Rf6kfQ0v6FeEDQsvHkBT0ycIyLzZiejOykxRqkUoYNWG9S
         mITHiYwnx+s9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 23C93F0392C;
        Mon, 16 May 2022 09:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 net-next 00/13] tcp: BIG TCP implementation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269401814.10450.4347707681628225161.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 09:40:18 +0000
References: <20220513183408.686447-1-eric.dumazet@gmail.com>
In-Reply-To: <20220513183408.686447-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, alexanderduyck@fb.com,
        lixiaoyan@google.com, edumazet@google.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 13 May 2022 11:33:55 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This series implements BIG TCP as presented in netdev 0x15:
> 
> https://netdevconf.info/0x15/session.html?BIG-TCP
> 
> Jonathan Corbet made a nice summary: https://lwn.net/Articles/884104/
> 
> [...]

Here is the summary with links:
  - [v7,net-next,01/13] net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes
    https://git.kernel.org/netdev/net-next/c/89527be8d8d6
  - [v7,net-next,02/13] net: allow gso_max_size to exceed 65536
    https://git.kernel.org/netdev/net-next/c/7c4e983c4f3c
  - [v7,net-next,03/13] net: limit GSO_MAX_SIZE to 524280 bytes
    https://git.kernel.org/netdev/net-next/c/34b92e8d19da
  - [v7,net-next,04/13] tcp_cubic: make hystart_ack_delay() aware of BIG TCP
    https://git.kernel.org/netdev/net-next/c/9957b38b5e7a
  - [v7,net-next,05/13] ipv6: add struct hop_jumbo_hdr definition
    https://git.kernel.org/netdev/net-next/c/7c96d8ec96bb
  - [v7,net-next,06/13] ipv6/gso: remove temporary HBH/jumbo header
    https://git.kernel.org/netdev/net-next/c/09f3d1a3a52c
  - [v7,net-next,07/13] ipv6/gro: insert temporary HBH/jumbo header
    https://git.kernel.org/netdev/net-next/c/81fbc812132c
  - [v7,net-next,08/13] net: allow gro_max_size to exceed 65536
    https://git.kernel.org/netdev/net-next/c/0fe79f28bfaf
  - [v7,net-next,09/13] ipv6: Add hop-by-hop header to jumbograms in ip6_output
    https://git.kernel.org/netdev/net-next/c/80e425b61342
  - [v7,net-next,10/13] net: loopback: enable BIG TCP packets
    https://git.kernel.org/netdev/net-next/c/d6f938ce52f9
  - [v7,net-next,11/13] veth: enable BIG TCP packets
    https://git.kernel.org/netdev/net-next/c/d406099d6a15
  - [v7,net-next,12/13] mlx4: support BIG TCP packets
    https://git.kernel.org/netdev/net-next/c/1169a64265c4
  - [v7,net-next,13/13] mlx5: support BIG TCP packets
    https://git.kernel.org/netdev/net-next/c/de78960e025f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


