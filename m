Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969F76EADA3
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 17:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbjDUPAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 11:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbjDUPAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 11:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2184F9EED;
        Fri, 21 Apr 2023 08:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4ACB650BC;
        Fri, 21 Apr 2023 15:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17633C4339B;
        Fri, 21 Apr 2023 15:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682089221;
        bh=/cWaE1pQxEUcwfGgb6LlmygrqcjlcV26je4aHRc2g5k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ISb/gNpv6n8HUy+TC2LqkfDifERoD/sYBPtexS72micOFiDj/2UuCf/KKPdHnlb8c
         nMFEydCZNLW0jotUtnTtid1lgJpDbI8+qvRjqIZ8LArK2/3WAiP6zVAcTJdPh6mlNb
         9DSvZU5xP+ZNDQt/5rbKkB3XFRTm7kdXPIfXNZJFbGzhKk2nBUvtssw9sO/3GgeXH8
         frrOxxU4wv/0rUIbrixx8TPw1HoqU5DNAUMoY+ggpMx2eF3+Sl3Fki/8+0gF/usH/5
         fgrpLN1sO9B+v81c9i+7ZsMH/jzJqX2V3sijVB7B9uFgjmDI72XohaV6pGQMMLysId
         VFHBv6zCi+qDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F33CFC561EE;
        Fri, 21 Apr 2023 15:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: conntrack: restore IPS_CONFIRMED out of
 nf_conntrack_hash_check_insert()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168208922099.15667.687754732559934974.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 15:00:20 +0000
References: <20230421105700.325438-2-pablo@netfilter.org>
In-Reply-To: <20230421105700.325438-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 21 Apr 2023 12:56:59 +0200 you wrote:
> e6d57e9ff0ae ("netfilter: conntrack: fix rmmod double-free race")
> consolidates IPS_CONFIRMED bit set in nf_conntrack_hash_check_insert().
> However, this breaks ctnetlink:
> 
>  # conntrack -I -p tcp --timeout 123 --src 1.2.3.4 --dst 5.6.7.8 --state ESTABLISHED --sport 1 --dport 4 -u SEEN_REPLY
>  conntrack v1.4.6 (conntrack-tools): Operation failed: Device or resource busy
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: conntrack: restore IPS_CONFIRMED out of nf_conntrack_hash_check_insert()
    https://git.kernel.org/netdev/net/c/2cdaa3eefed8
  - [net,2/2] netfilter: conntrack: fix wrong ct->timeout value
    https://git.kernel.org/netdev/net/c/73db1b8f2bb6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


