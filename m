Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E286C320C
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjCUMuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCUMuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16664460A7;
        Tue, 21 Mar 2023 05:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7A7361B8E;
        Tue, 21 Mar 2023 12:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00D67C4339B;
        Tue, 21 Mar 2023 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679403017;
        bh=7Skp9QCN26Hhox6jLfXK+RsgIj49Xpohq6Wn0JqFfWw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L2RUWaThbbZcGr5EPPxghcsAIRd8hD2TuDTaCDSTzxhrUq0ZTNRiBT/f+Bqyvk2hD
         E+KMbvAbAus0UQeUJ5b4ollO8DMowX4e+Fxlwl8GDAASQsNCDeVBbS9UJ4dbdeINod
         NMyTYrwuPQxH0ciNh2ZHTag4jq5PPTRzcDgRFoMXOwrcvf0RG9QU4IbEIHlyz/QHFq
         4IkUt6AILC/EfnQ+8clmc+HB7q84KNsQ1ujqMJpeM6/U0PDaBZcnpBTdON4ge3LGWN
         16ANZBNbf4zS7wjdusXNLAxzc1H6o7jxwLrW8w0hC5pOOeSaTUNfD3dGXgUv2iQfDj
         rqJuHHgrD9FEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7950E66C98;
        Tue, 21 Mar 2023 12:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: geneve: accept every ethertype
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167940301687.28985.7534980662162087325.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Mar 2023 12:50:16 +0000
References: <20230319220954.21834-1-josef@miegl.cz>
In-Reply-To: <20230319220954.21834-1-josef@miegl.cz>
To:     Josef Miegl <josef@miegl.cz>
Cc:     eyal.birger@gmail.com, pshelar@ovn.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 19 Mar 2023 23:09:54 +0100 you wrote:
> The Geneve encapsulation, as defined in RFC 8926, has a Protocol Type
> field, which states the Ethertype of the payload appearing after the
> Geneve header.
> 
> Commit 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
> introduced a new IFLA_GENEVE_INNER_PROTO_INHERIT flag that allowed the
> use of other Ethertypes than Ethernet. However, it did not get rid of a
> restriction that prohibits receiving payloads other than Ethernet,
> instead the commit white-listed additional Ethertypes, IPv4 and IPv6.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: geneve: accept every ethertype
    https://git.kernel.org/netdev/net-next/c/251d5a2813f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


