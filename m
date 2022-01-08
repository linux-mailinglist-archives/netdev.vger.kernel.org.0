Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D253C488107
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 04:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbiAHDKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 22:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiAHDKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 22:10:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F2FC061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 19:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 855D262068
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 03:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5904C36AF3;
        Sat,  8 Jan 2022 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641611410;
        bh=mtzDcIKzdoaFaF2tdA+TCErS/NXMvf6b0om/d6nibkk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ic0VWEGJ0m451u3AajrVXwN698OIQlRrSJycBABBWm2hrJI8Ks8PSCqWGrk3ppblq
         vpzob7oZWG0RR9NYkqpcGmCFPEqMTwCOVFon6vzeDwW8rmovkb5pS/Jsm/lh+9kf/D
         /cV7rgwpUVPzw8K4qoUoXxp6O6ObecaCdrOWQnUwiqIGgdHwvh3axLzfTZHZrpAs3O
         gyfmgfLQK5aoY7aJVrKfRzSMNmD6gYMguGE9tjBsBsM44IXweUvuscCZAzYHFbTAqk
         Cc0WclWSUAnmFK/rx1ZSUblUM+Zymw0nh135TZnYzwlfhZRGNF/+Y3ESGIQex+Qkrf
         /y1uDWtIXQVhQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CDFABF7940D;
        Sat,  8 Jan 2022 03:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] mptcp: Refactoring for one selftest and csum
 validation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164161141083.29029.14717183824415630024.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Jan 2022 03:10:10 +0000
References: <20220107192524.445137-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220107192524.445137-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  7 Jan 2022 11:25:21 -0800 you wrote:
> A few more patches from the MPTCP tree for 5.17, with some refactoring
> changes.
> 
> Patch 1 changes the MPTCP join self tests to depend more on events
> rather than delays, so the script runs faster and has more consistent
> results.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] selftests: mptcp: more stable join tests-cases
    https://git.kernel.org/netdev/net-next/c/327b9a94e2a8
  - [net-next,2/3] mptcp: change the parameter of __mptcp_make_csum
    https://git.kernel.org/netdev/net-next/c/c312ee219100
  - [net-next,3/3] mptcp: reuse __mptcp_make_csum in validate_data_csum
    https://git.kernel.org/netdev/net-next/c/8401e87f5a36

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


