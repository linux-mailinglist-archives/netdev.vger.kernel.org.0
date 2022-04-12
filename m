Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAC54FEB59
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiDLXYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiDLXYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:24:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8538A5BD0D;
        Tue, 12 Apr 2022 15:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8BA4FCE20CB;
        Tue, 12 Apr 2022 22:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE27EC385AA;
        Tue, 12 Apr 2022 22:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649800811;
        bh=1pT1rKstnA/xfByk8gzUWt5r+vz6RbFdQNtjjloFPq4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cS+6/lgLPAuhPGp8lxPTY24+WP+3iQGjGrM0Liom18Gu0z1/WSVSEvrcupW67b7bp
         tRGlTMwK0lTURg5Ck0gyCbWIU2tFy2i70jty6ssLU42M8uWd8IAxgEXcmyeeZLHP58
         O6W+pwdK+4NDTvd4A2R3Rm4iZ2IrwbOBOTq/pLgIhnikrJqqdlklQWiBT4qcgeLQqk
         hRvnIB94iBfFkc7YNL9KG0JJmF9mD3VGBeY/4bFZmDuZzmRt2pMGPs5Vcn1009EhoF
         L4P2SwIYec6Td0Q8k7Ifv1SZfI0u7WRb1SNfX/x1Z9rOJ7nRRkFixxxWnsQmtYhNbU
         N0rUpXlxS2VaA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8EED7E8DD5E;
        Tue, 12 Apr 2022 22:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] fou: Remove XRFM from NET_FOU Kconfig
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164980081157.20212.8870993161912217213.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 22:00:11 +0000
References: <20220411213717.3688789-1-lixiaoyan@google.com>
In-Reply-To: <20220411213717.3688789-1-lixiaoyan@google.com>
To:     Coco Li <lixiaoyan@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        willemb@google.com, edumazet@google.com, gthelen@google.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 11 Apr 2022 14:37:17 -0700 you wrote:
> XRFM is no longer needed for configuring FOU tunnels
> (CONFIG_NET_FOU_IP_TUNNELS), remove from Kconfig.
> 
> Also remove the xrfm.h dependency in fou.c. It was
> added in '23461551c006 ("fou: Support for foo-over-udp RX path")'
> for depencies of udp_del_offload and udp_offloads, which were removed in
> 'd92283e338f6 ("fou: change to use UDP socket GRO")'.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] fou: Remove XRFM from NET_FOU Kconfig
    https://git.kernel.org/netdev/net-next/c/753b953774b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


