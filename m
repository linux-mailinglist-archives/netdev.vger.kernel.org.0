Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D006C6DB85A
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 04:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjDHCuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 22:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDHCuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 22:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C02C678;
        Fri,  7 Apr 2023 19:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35F7165479;
        Sat,  8 Apr 2023 02:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BD5AC433A4;
        Sat,  8 Apr 2023 02:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680922218;
        bh=3RDjDw6r/ebF6dAYn94qoplvfr6f+RUhOBEcUT+geB4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tk538u3ABFz7FiR8KUwCvhz+u3uRUX5mCQ8YGa4paZGAhGO5MMQL8THUXfcN2hCAt
         AjCPpTH/o/fYLEgJ7f5yRffmItIVRRVXrvWMIkzFL3ZJcecEXUMlvqEq4cMlBiTEr4
         xe9UvItr7WcTxid1Lv7JrRPp+j9R5cOi+t6GBflF3VoU4oIIO26i1JZKLsremfEqSa
         6LucSAbrOP6PBgzPZtME7oiSiwVn1QP4DM6C5DhcnGAhUp+ftAU5qxn0lgH8zWrOPp
         hQbLROxsL4d8HV+mb3yEAhyFVQwUso0YrY0eHAHHeOraYMCefIGEZ06SHIbynj9hrA
         n/3MHRUgS2h1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38940C4167B;
        Sat,  8 Apr 2023 02:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: openvswitch: fix race on port output
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168092221822.13259.3368137613613874573.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Apr 2023 02:50:18 +0000
References: <ZC0pBXBAgh7c76CA@kernel-bug-kernel-bug>
In-Reply-To: <ZC0pBXBAgh7c76CA@kernel-bug-kernel-bug>
To:     Felix Huettner <felix.huettner@mail.schwarz>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, pshelar@ovn.org, davem@davemloft.net,
        luca.czesla@mail.schwarz
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 5 Apr 2023 07:53:41 +0000 you wrote:
> assume the following setup on a single machine:
> 1. An openvswitch instance with one bridge and default flows
> 2. two network namespaces "server" and "client"
> 3. two ovs interfaces "server" and "client" on the bridge
> 4. for each ovs interface a veth pair with a matching name and 32 rx and
>    tx queues
> 5. move the ends of the veth pairs to the respective network namespaces
> 6. assign ip addresses to each of the veth ends in the namespaces (needs
>    to be the same subnet)
> 7. start some http server on the server network namespace
> 8. test if a client in the client namespace can reach the http server
> 
> [...]

Here is the summary with links:
  - [net,v3] net: openvswitch: fix race on port output
    https://git.kernel.org/netdev/net/c/066b86787fa3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


