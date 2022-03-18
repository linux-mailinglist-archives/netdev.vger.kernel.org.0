Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A794B4DE369
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241088AbiCRVVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241082AbiCRVVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:21:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9966321DF17;
        Fri, 18 Mar 2022 14:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4900BB825BD;
        Fri, 18 Mar 2022 21:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6F37C340ED;
        Fri, 18 Mar 2022 21:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647638413;
        bh=TZH/JANCACWHtiYrNaf1joq8Zk6JrtdKPyBGOm2vA2c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RhqAbFm8+I7qooEzX+9RvdEQDevPj9ncXPHRDrVMpw46JkTZwTQMb8QTDxxtg3NHv
         iXzYXlHfQCKbYw9m5fMl3sKbmSV0Vy1zkZN+q+5TZ8lKqlz7f8akzTvm8pb22hLk1O
         FZMD62h3vUn6tuLz2qB27wsl3hloktFinPIDfl9g1tCPxXqo1Tk9GIynltwrz6ykV/
         lO1VueQIVGcuZyiC/NSkCrdHomwltDbWvwxXY7WIjfpkf+rRT0qkHC5vC6gs9J2LLE
         AleLMjoNh0p6OleRVlx3kj9pM2ir3svpvAAqtSVgiC7eDS2+TxJq02QeAT/JPOPP+0
         8yAJB/TLR0cig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CDBA7F03841;
        Fri, 18 Mar 2022 21:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] ipv4: Handle TOS and scope properly for ICMP
 redirects and PMTU updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164763841283.20195.6859436420030223679.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 21:20:12 +0000
References: <cover.1647519748.git.gnault@redhat.com>
In-Reply-To: <cover.1647519748.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Mar 2022 13:45:05 +0100 you wrote:
> ICMPv4 PMTU and redirect handlers didn't properly initialise the
> struct flowi4 they used for route lookups:
> 
>   * ECN bits sometimes weren't cleared from ->flowi4_tos.
>   * The RTO_ONLINK flag wasn't taken into account for ->flowi4_scope.
> 
> In some special cases, this resulted in ICMP redirects and PMTU updates
> not being taken into account because fib_lookup() couldn't retrieve the
> correct route.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] ipv4: Fix route lookups when handling ICMP redirects and PMTU updates
    https://git.kernel.org/netdev/net/c/544b4dd568e3
  - [net,v2,2/2] selftest: net: Test IPv4 PMTU exceptions with DSCP and ECN
    https://git.kernel.org/netdev/net/c/ec730c3e1f0e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


