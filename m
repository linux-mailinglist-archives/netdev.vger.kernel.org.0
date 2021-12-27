Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC15147FC9D
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 13:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbhL0MaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 07:30:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34824 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbhL0MaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 07:30:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7543860FFC;
        Mon, 27 Dec 2021 12:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0583C36AEA;
        Mon, 27 Dec 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640608208;
        bh=u0+rdfVjjj4qPxcnxw7949gOgyIRPbV6hY910bYH9w4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aXEbfkmnkBRYqXXR+e4IpBqtXiOVYi22b/pYXbULdS+vO212pJUvDVrBdsLDPL9nK
         gDjVBcAg/0zn320TSrhdwBkEaniJ0KCIGdfBcs2MAFpDCCbuY7DbzkrZyc6GVbNDjB
         ZmrAneXt9tsWvq5M5FOi04/tMUfnMd47aVoDfXzu5MpPBS3O862cgzkUQ21fz/90iT
         oTDh7GBGLLtWN184zTyK01BeNnhS4HUuccyG9DxO4Ya9F68iDUwH6MLJv/M08y83i8
         BxjDLMSDUR6eO+p8rkhAQQ1Pqt67pAreR2wY3DYSx3f0B4bv2MO04ha9v5mq9bkQ6/
         H3rTyzcLEfYBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B80FDC395E0;
        Mon, 27 Dec 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ip6_vti: initialize __ip6_tnl_parm struct in
 vti6_siocdevprivate
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164060820874.30571.5186520288717788634.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Dec 2021 12:30:08 +0000
References: <20211223173316.779982-1-wizhao@redhat.com>
In-Reply-To: <20211223173316.779982-1-wizhao@redhat.com>
To:     William Zhao <wizhao@redhat.com>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Dec 2021 12:33:16 -0500 you wrote:
> The "__ip6_tnl_parm" struct was left uninitialized causing an invalid
> load of random data when the "__ip6_tnl_parm" struct was used elsewhere.
> As an example, in the function "ip6_tnl_xmit_ctl()", it tries to access
> the "collect_md" member. With "__ip6_tnl_parm" being uninitialized and
> containing random data, the UBSAN detected that "collect_md" held a
> non-boolean value.
> 
> [...]

Here is the summary with links:
  - ip6_vti: initialize __ip6_tnl_parm struct in vti6_siocdevprivate
    https://git.kernel.org/netdev/net/c/c1833c3964d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


