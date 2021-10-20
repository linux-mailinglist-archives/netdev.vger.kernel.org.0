Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D72A43568B
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 01:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhJTXmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 19:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhJTXmW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 19:42:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4EAAD610A2;
        Wed, 20 Oct 2021 23:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634773207;
        bh=nB8DNct3SWr1Rcbgrh854yo39MSH7nmSF2rDAAqIaHk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U3/3mARWGJ0QBecjWvHfvmksMk4xgd3lR8LQOmxtkgEK4aeoY21uWWI0dpV77qrB/
         GOkYKG4945J59BIdGdct45DGvb7Ibbux4kMobUv6hkrnwbKkKjdy/9DAnAEIvFngv8
         QKp+3ZdlRpg/404PA1XJNl2+Boh9Zyw3llh3Dr2TBv0Xg5S4AHVXmRp0jTNVInOeUe
         YWrOkuH5JtnMdSyjDbx5uQvSysM7CJssqMK6ZVHGu4zzEfPLcNSFicb/jwas4Xphh1
         o9Y8cg7kQXiIF2MKrQstQvj5P4XNnRcXnlGb3Xrp4HAxP3hV7vA40YL3vI9bbYFJoI
         m+K6Kz4yrEmMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3C97D609D7;
        Wed, 20 Oct 2021 23:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] fq_codel: generalise ce_threshold marking for
 subset of traffic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163477320724.936.13193734528653690217.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 23:40:07 +0000
References: <20211019174709.69081-1-toke@redhat.com>
In-Reply-To: <20211019174709.69081-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 19 Oct 2021 19:47:09 +0200 you wrote:
> The commit in the Fixes tag expanded the ce_threshold feature of FQ-CoDel
> so it can be applied to a subset of the traffic, using the ECT(1) bit of
> the ECN field as the classifier. However, hard-coding ECT(1) as the only
> classifier for this feature seems limiting, so let's expand it to be more
> general.
> 
> To this end, change the parameter from a ce_threshold_ect1 boolean, to a
> one-byte selector/mask pair (ce_threshold_{selector,mask}) which is applied
> to the whole diffserv/ECN field in the IP header. This makes it possible to
> classify packets by any value in either the ECN field or the diffserv
> field. In particular, setting a selector of INET_ECN_ECT_1 and a mask of
> INET_ECN_MASK corresponds to the functionality before this patch, and a
> mask of ~INET_ECN_MASK allows using the selector as a straight-forward
> match against a diffserv code point:
> 
> [...]

Here is the summary with links:
  - [net-next,v2] fq_codel: generalise ce_threshold marking for subset of traffic
    https://git.kernel.org/netdev/net-next/c/dfcb63ce1de6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


