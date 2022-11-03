Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D064B6187C7
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 19:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiKCSkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 14:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKCSkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 14:40:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993BEBC1D
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 11:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 516ADB8277B
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 18:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3AABC433D7;
        Thu,  3 Nov 2022 18:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667500842;
        bh=pPLcPkzqYrGgKRcfNnIdI535or8bg1MRPKwemDB3+1k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QZxwdQ5PH5nSy0nv2pLxj+ooac6mEzvAabVudhHJK20mT8zptm8TwpHljmFFgO9no
         7HMy4zbxRg9iMig8ht+bSQRHDLznmMu8oBXlsmIso8ho+ExAaNW3OO1nxU4gjoR1Qb
         x0Qz8kmshujASum8yCyN1qynPAJPppiXwZ6gTwr0cpPImXQBecvWctq6t3wf6aSwAw
         1d0NxnQblMkQH5LQmVYx0jSarEieQYGJW6yt7QeueVHzjmDzxkrmD2OHGKED0Ic/gZ
         aUDHZnSgqtbAsso4hSiWf88gU7kRTmaLCAo6rquZ2UV6h0sUP6bNEloZ2zqEjcAglX
         5FHr6hY1D8i6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBCF1E270EA;
        Thu,  3 Nov 2022 18:40:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] json: do not escape single quotes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166750084283.9047.12808093486442622541.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 18:40:42 +0000
References: <068673c301bfc5c5d48e06301a2086285a199731.1667497007.git.aclaudi@redhat.com>
In-Reply-To: <068673c301bfc5c5d48e06301a2086285a199731.1667497007.git.aclaudi@redhat.com>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Thu,  3 Nov 2022 18:39:25 +0100 you wrote:
> ECMA-404 standard does not include single quote character among the json
> escape sequences. This means single quotes does not need to be escaped.
> 
> Indeed the single quote escape produces an invalid json output:
> 
> $ ip link add "john's" type dummy
> $ ip link show "john's"
> 9: john's: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether c6:8e:53:f6:a3:4b brd ff:ff:ff:ff:ff:ff
> $ ip -j link | jq .
> parse error: Invalid escape at line 1, column 765
> 
> [...]

Here is the summary with links:
  - [iproute2] json: do not escape single quotes
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=49c63bc775d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


