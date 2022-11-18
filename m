Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231E662F47A
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241773AbiKRMUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241827AbiKRMUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:20:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A1697AB3;
        Fri, 18 Nov 2022 04:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21143624D1;
        Fri, 18 Nov 2022 12:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 854CAC43140;
        Fri, 18 Nov 2022 12:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668774017;
        bh=4mMFGrAjpFviiTCrvhLTP7wYPP3btZaB0UfDh8F6uZ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=otIzx8zu2cY+DUNVifiyC/ApK8T7FemoBofvDKkWGaUXG+j1Avn8SY6VMobLa5zZE
         /efpt/OTe5zwSiTXYuc8PLbre8aD/D6hYJKbVRZSep5FWDCBeXyJyKyE1rEmJ4Ynzt
         kLKqR2ITvSqgeX2sPSX1kwK6Y6XCL0IH3Rgn0r1jKGyRZSpEoJgLV6lRZO1Rl70/mO
         /A+sq211l5RIpZHgj0b3RT/1zUCk2XggFzwmzb57esGFxokK4uKGIsK9P2czARTDLb
         o9deZ+YfsvGzILJPLsSq9WAC6hmBPRsUqphC7/Z6fa3jhM8w2cfTFSl+nf0BLD+IZ8
         bX/TYQfqEZA5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71DA4E29F44;
        Fri, 18 Nov 2022 12:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3] rxrpc: Fix oops and missing config conditionals
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166877401746.25544.9755255190243368737.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 12:20:17 +0000
References: <166858659236.2154965.18023032361364343888.stgit@warthog.procyon.org.uk>
In-Reply-To: <166858659236.2154965.18023032361364343888.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
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
by David Howells <dhowells@redhat.com>:

On Wed, 16 Nov 2022 08:16:32 +0000 you wrote:
> The patches that were pulled into net-next previously[1] had some issues
> that this patchset fixes:
> 
>  (1) Fix missing IPV6 config conditionals.
> 
>  (2) Fix an oops caused by calling udpv6_sendmsg() directly on an AF_INET
>      socket.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] rxrpc: Fix missing IPV6 #ifdef
    https://git.kernel.org/netdev/net-next/c/41cf3a9156ba
  - [net-next,2/3] rxrpc: Fix oops from calling udpv6_sendmsg() on AF_INET socket
    https://git.kernel.org/netdev/net-next/c/6423ac2eb31e
  - [net-next,3/3] rxrpc: Fix network address validation
    https://git.kernel.org/netdev/net-next/c/66f6fd278c67

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


