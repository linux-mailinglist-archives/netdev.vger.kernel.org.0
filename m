Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF9B50B6FB
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 14:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447356AbiDVMNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 08:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447380AbiDVMNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 08:13:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6693F31DC0;
        Fri, 22 Apr 2022 05:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B193ACE294A;
        Fri, 22 Apr 2022 12:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6C11C385AF;
        Fri, 22 Apr 2022 12:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650629411;
        bh=APf6jpXDGLxUKrbqLvbwJKYkxkT1guioJa+IJ2L+G9A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qFf9pDF6O2aKZekydt5IMEiOdRH93m+x7li7xLdVUvBD1AgBjcUF0o3CshJss9e9Q
         27+UhZ8k1QyxkAqPiCR7/4rLNJJY2uLt35BtPqQlrizSB4uH1xrG3qmyDuVC/M5jm0
         j3e0Mu4E3D9lFto+s9pO77m22WhBd9cJEPr2TiyJj0aA6HQgw/zZk8LS0CK2cZH7i1
         6NiHoCwqFNL9D1E79l1n8iIXdYCAFTXZEbLmP1NvPXhXRTjt3QG/6ZCtxZwXLNs/5d
         d/85uSebmFBfG8TEYKigRqWQgf20a2QyTyakIgCJQy8VETRNgQu9D7suU+XSy3vqPk
         5wzF/SIu4Cr3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9983CE8DD61;
        Fri, 22 Apr 2022 12:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: Add missing of_node_put() in
 dsa_port_link_register_of
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165062941162.4368.17163300316112678882.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 12:10:11 +0000
References: <20220420110413.17828-1-linmq006@gmail.com>
In-Reply-To: <20220420110413.17828-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 20 Apr 2022 19:04:08 +0800 you wrote:
> The device_node pointer is returned by of_parse_phandle()  with refcount
> incremented. We should use of_node_put() on it when done.
> of_node_put() will check for NULL value.
> 
> Fixes: a20f997010c4 ("net: dsa: Don't instantiate phylink for CPU/DSA ports unless needed")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: dsa: Add missing of_node_put() in dsa_port_link_register_of
    https://git.kernel.org/netdev/net/c/fc06b2867f4c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


