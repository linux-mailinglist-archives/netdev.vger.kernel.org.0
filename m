Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E464F6E2AF1
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 22:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjDNUKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 16:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjDNUKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 16:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8643E5B8E
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 13:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70AD164A03
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 20:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3E4CC4339B;
        Fri, 14 Apr 2023 20:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681503018;
        bh=s96Rc5FbsR6oqte+2N0oRJWAaoCJJ1GItoiSXoBTlqs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B498WlR+Y3b9PodjEnqlKToJArDQXpb/u8ewsb+tZRhOTXgwNIzj+OQIe1GkE4SxQ
         cJH8O3X/KGX472BNXMHclllpiTwnjC+bE/42NkG/838d26uM2Mg6UPnZ/3b8L9QCza
         fXW4GvnuQfoQNaL85aWdlOqfGF1l+BthlJwj4eg7mx5RVK6u7P7TWNXCqPQ1XncXlj
         ECht5HpeO4zhyJMDeyIeGtepMDuD0g/aA00YQeuiiBlpUwT6hNcM/uRmoEdyPHX/br
         9u9fftT3FUekPIk//S8MHCBkJ3x8tSR8JJyToDyqdgssDamtKNsJYgwORSm5nXAi9y
         3YBm6JVDaFpWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9EB2E29F3B;
        Fri, 14 Apr 2023 20:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] iptunnel: detect protocol mismatch on tunnel change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168150301875.15322.4144586123529636419.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Apr 2023 20:10:18 +0000
References: <20230410233509.7616-1-stephen@networkplumber.org>
In-Reply-To: <20230410233509.7616-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, bluca@debian.org, dsahern@kernel.org,
        imer@imer.cc
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

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Mon, 10 Apr 2023 16:35:09 -0700 you wrote:
> If attempt is made to change an IPv6 tunnel by using IPv4
> parameters, a stack overflow would happen and garbage request
> would be passed to kernel.
> 
> Example:
> ip tunnel add gre1 mode ip6gre local 2001:db8::1 remote 2001:db8::2 ttl 255
> ip tunnel change gre1 mode gre local 192.168.0.0 remote 192.168.0.1 ttl 255
> 
> [...]

Here is the summary with links:
  - [iproute2] iptunnel: detect protocol mismatch on tunnel change
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=8cc2eac60d5f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


