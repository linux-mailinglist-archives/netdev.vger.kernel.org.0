Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3128F55CD34
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244871AbiF1FkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244825AbiF1FkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BEA13F01;
        Mon, 27 Jun 2022 22:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A20DCB81CA6;
        Tue, 28 Jun 2022 05:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31FC3C341D0;
        Tue, 28 Jun 2022 05:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656394815;
        bh=wYg95DEfcH0ElPKCDzBwX9DTkFfLdKl71XXLK5FZYOg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MHhjTKnQ80MOmq9CK+HGY9C35PfnxRDqbkRr2QHAfUeysF0Fgz+q2852bO/3k5ja8
         1666mxhCSz9SaKIScUcARdIysQabfdpPAoDA4xfWzloJXhAMDDGRaDoAQYIL4YNAJU
         S1PMYv60z7MdU/5lWF84aJ3vdg+QYPCHFknSPA2sGX/7F4J3CXvihp80LnXYb9nQZY
         PQJ7Zxj+lFp97wXqTyYLEpzVGafsNBJ1rsi6tWOfeGSXvh9Z0dlYT6GNH5MmpWsQfa
         +F196yzSQQXVEANtiKaEw9KWmt67f49rHUruMZFoFKOzKQlMSR7cNIIEvd3NMrZNY/
         fspQujHO7DmOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1581BE49FA2;
        Tue, 28 Jun 2022 05:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hinic: Use the bitmap API when applicable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165639481508.10558.14591530550875326234.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 05:40:15 +0000
References: <6ff7b7d21414240794a77dc2456914412718a145.1656260842.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <6ff7b7d21414240794a77dc2456914412718a145.1656260842.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 26 Jun 2022 18:27:45 +0200 you wrote:
> 'vlan_bitmap' is a bitmap and is used as such. So allocate it with
> devm_bitmap_zalloc() and its explicit bit size (i.e. VLAN_N_VID).
> 
> This avoids the need of the VLAN_BITMAP_SIZE macro which:
>    - needlessly has a 'nic_dev' parameter
>    - should be "long" (and not byte) aligned, so that the bitmap semantic
>      is respected
> 
> [...]

Here is the summary with links:
  - hinic: Use the bitmap API when applicable
    https://git.kernel.org/netdev/net-next/c/7c2c57263af4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


