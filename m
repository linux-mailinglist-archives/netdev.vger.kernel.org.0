Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1244055DD75
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243381AbiF1KUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243557AbiF1KUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653B1B4C
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 03:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D098618EE
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 10:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C482C341CB;
        Tue, 28 Jun 2022 10:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656411613;
        bh=oixSZZBuvVNSI3IO9AwNx3QKbDuW0oAjopcWeP7pxdg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PTgBBHiommmrVP6VmV8Da60FfYX47mp8yJ4jM6yrPcve8tH4q+ohtcBTAIcecVJDn
         n3CGl4Z7xF6nG10I62B0sS0Vnstu63xGNnEU+fVaJBy5fyNGAjbGcwNl746RkJecK+
         hRZxoGI/TSvJsYhgM5QzsXHPJlbj/5poP9X1Wk8yUPF3u7GAnBjs73pKwixVaBLQcS
         S6govD55CJbO1h4c4aiqjTAGa6Rj/73Sw9zgaDMwnYJls4G4lRaeU1t+6HvFvP+bvM
         GiiaWzl6vpu/IJauzzg/98eqKVjSEmmUqnjb7okBbcSkTXTgheYkVJckqQ85X6PQVH
         ZJbH/HyimdqoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4ED90E49BBC;
        Tue, 28 Jun 2022 10:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 resend] ipv6/addrconf: fix timing bug in tempaddr
 regen
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165641161331.8568.270478184823480963.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 10:20:13 +0000
References: <20220623181103.7033-1-CFSworks@gmail.com>
In-Reply-To: <20220623181103.7033-1-CFSworks@gmail.com>
To:     Sam Edwards <cfsworks@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, CFSworks@gmail.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 23 Jun 2022 12:11:04 -0600 you wrote:
> The addrconf_verify_rtnl() function uses a big if/elseif/elseif/... block
> to categorize each address by what type of attention it needs.  An
> about-to-expire (RFC 4941) temporary address is one such category, but the
> previous elseif branch catches addresses that have already run out their
> prefered_lft.  This means that if addrconf_verify_rtnl() fails to run in
> the necessary time window (i.e. REGEN_ADVANCE time units before the end of
> the prefered_lft), the temporary address will never be regenerated, and no
> temporary addresses will be available until each one's valid_lft runs out
> and manage_tempaddrs() begins anew.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,resend] ipv6/addrconf: fix timing bug in tempaddr regen
    https://git.kernel.org/netdev/net-next/c/778964f2fdf0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


