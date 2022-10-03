Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5665F28FF
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 09:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiJCHKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 03:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiJCHK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 03:10:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962742A959
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 00:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED73AB80E69
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 07:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98ACDC4347C;
        Mon,  3 Oct 2022 07:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664781024;
        bh=1jNSqG9eqmdrTCogp9EQTIauINUXmDQ3JRXl2qhzkCU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KWm/P84YN6sXf2fquUOHnl36hQQW1WcEDyJ3NYuQqrX4lwXKRJEu2yO1z/gFc2kQK
         cr7RZQGf0m77OY8f8E5Q3JORR8V+sJJQrnEPKQ/ijnYvik1IjBblrOkay9FOmhuftO
         OvvXLVIJaQcagfpBE4HK8MXXhwVhDbZzg4AZOhqQ8WIAfeP78JQ/RbwfBc7cmbt9t9
         K3mK/jyKTCeX8NO5BZZNH2kgbYJDxiboY7li+ThwtsRy2vKZ09gmIzJKnEUhov7CP9
         IxT6W4kJ4ua0ExDlqfdNL7PZpd5ANNzJ/OnyqbPCApD/05OFJ9OKRcuU08SRsr2wjD
         jOTH92sn33S8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F426E49FA7;
        Mon,  3 Oct 2022 07:10:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/2] Add helper functions to parse netlink msg of
 ip_tunnel
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166478102451.21968.4001828325298157606.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 07:10:24 +0000
References: <20220929135203.235212-1-liujian56@huawei.com>
In-Reply-To: <20220929135203.235212-1-liujian56@huawei.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 29 Sep 2022 21:52:01 +0800 you wrote:
> Add helper functions to parse netlink msg of ip_tunnel
> 
> v1->v2: Move the implementation of the helper function to ip_tunnel_core.c
> v2->v3: Change EXPORT_SYMBOL to EXPORT_SYMBOL_GPL
> 
> Liu Jian (2):
>   net: Add helper function to parse netlink msg of ip_tunnel_encap
>   net: Add helper function to parse netlink msg of ip_tunnel_parm
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] net: Add helper function to parse netlink msg of ip_tunnel_encap
    https://git.kernel.org/netdev/net-next/c/537dd2d9fb9f
  - [net-next,v3,2/2] net: Add helper function to parse netlink msg of ip_tunnel_parm
    https://git.kernel.org/netdev/net-next/c/b86fca800a6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


