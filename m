Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C6260539A
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 01:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbiJSXCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 19:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiJSXBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 19:01:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558E41D374B;
        Wed, 19 Oct 2022 16:01:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B30BD619DA;
        Wed, 19 Oct 2022 23:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DBBDC433D7;
        Wed, 19 Oct 2022 23:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666220418;
        bh=Y9/uyJrfFT/bU5U9KFpV563J4cOo3twBZ/7HU8N47GQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZxbaxTEei1Zf4Pno82HdQ7QjoleFJ0nSVmQMgIlSsNWXLOImiEzZZbacXRfXpO1dy
         DYnkMqFwwtoA/H1j93i40apZ7zlQY2He2/W39fGdBWzePVgMaIpEvqlZa7QCe13HtO
         r6Zb0yJNwZxCrcNw8QioniY/Zohf3rctuq2BOEsuWtKI5rdvCHj4Ia2oUqXwLN38dy
         ecy7I3FQyz2Aex/Fp5l6eJPIGXmvgr7ADZsyazO2/fKiYKslR0e4Ej9zsSUOkIW7Lj
         G5tEsBMuYW/zEJ+htLAJqpOHy/y7BsewKm8g86vs/w6jVAo9SuRNMoWoO+bJ0aljnf
         cSi9EJhlC7jgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE3C6E4D007;
        Wed, 19 Oct 2022 23:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: rpfilter/fib: Set ->flowic_uid correctly
 for user namespaces.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166622041796.8151.14904401756676019532.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 23:00:17 +0000
References: <20221019065225.1006344-2-pablo@netfilter.org>
In-Reply-To: <20221019065225.1006344-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 19 Oct 2022 08:52:24 +0200 you wrote:
> From: Guillaume Nault <gnault@redhat.com>
> 
> Currently netfilter's rpfilter and fib modules implicitely initialise
> ->flowic_uid with 0. This is normally the root UID. However, this isn't
> the case in user namespaces, where user ID 0 is mapped to a different
> kernel UID. By initialising ->flowic_uid with sock_net_uid(), we get
> the root UID of the user namespace, thus keeping the same behaviour
> whether or not we're running in a user namepspace.
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: rpfilter/fib: Set ->flowic_uid correctly for user namespaces.
    https://git.kernel.org/netdev/net/c/1fcc064b305a
  - [net,2/2] netfilter: nf_tables: relax NFTA_SET_ELEM_KEY_END set flags requirements
    https://git.kernel.org/netdev/net/c/96df8360dbb4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


