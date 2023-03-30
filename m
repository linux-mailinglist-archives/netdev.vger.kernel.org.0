Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F110F6D0A8D
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbjC3QA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbjC3QAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:00:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8467EC3
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DD5ECCE2AFD
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 16:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EBCCBC433D2;
        Thu, 30 Mar 2023 16:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680192019;
        bh=3E+t+qd8rGkFbKhsd3MDXkzigFXLFpLCuas4AqwhRws=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JWR5o+YikgqkkR0dKDy13Spx+lQDN8GBKxCwLCxSM9qqxlQonr/vWbrYNJVbMJSvF
         FQ1E4enUWaSmuq0dKNi4Zs1RKmzsK4RPBZ4ndUDpbTxb56e5m6MXPxuIKrbmSw+CYs
         okt+cCdWI1y8Jiz2/Z1/0MllkdzCkRh5iMqkIx3Y+QaWQAB9jpTMOlnLBdHrK1Ojku
         oNltiuI04/8YbdBp/2yqMbpGG6/9xECyY1wAkUWJaMnCuGR57TGVMUAvhWirKGOUQS
         A9Xrv0rm1dOhCNYAmcXuQth1T4X2cB7W7qbRl0If+OC11wqdR005BjGFjuiCd92P/q
         77ppFVB7ZIYHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D068BE2A037;
        Thu, 30 Mar 2023 16:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/2] ip: Support IP address protocol
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168019201884.15770.16440073183438285696.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 16:00:18 +0000
References: <cover.1679933258.git.petrm@nvidia.com>
In-Reply-To: <cover.1679933258.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Mon, 27 Mar 2023 18:12:04 +0200 you wrote:
> IPv4 and IPv6 addresses can be assigned a protocol value that indicates the
> provenance of the IP address. The attribute is modeled after ip route
> protocols, and essentially allows the administrator or userspace stack to
> tag addresses in some way that makes sense to the actor in question.
> Support for this feature was merged with commit 47f0bd503210 ("net: Add new
> protocol attribute to IP addresses"), for kernel 5.18.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/2] ip: Support IP address protocol
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=bdb8d8549ed9
  - [iproute2-next,2/2] man: man8: Add man page coverage for "ip address add ... proto"
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=1fbb61058d34

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


