Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5C03450CD
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhCVUaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231547AbhCVUaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2418161993;
        Mon, 22 Mar 2021 20:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616445009;
        bh=Kd59WqoMfhURm746obU8uvfLVKLDMfw4jM1djgJI+1o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KsR85Rjput80mhXCO9wVq3c9x2T2Acr8PH7GWSI5jaPGTEIaopp8wIKJmLIb7aSsb
         VOJod8YYWWfnAb2JnrshbRqywV/Eyp6Q5mPpjmaNFgJxEKgCcQ/xXPfWJWfrsi95Gf
         +UO8HldnrTMvIPMHCR5kJu18iYOAXt1iZz4u4TBxlG7i3r2eEuDLFSs24lHMkweu2g
         MuZC3i64KC5HZ785M8nY//lGD4bhrJhUcgM/5kVQhvj0ZvAU3voZ4mESLGc14eIkYu
         uMbRn+rTLzeOpclKZFEjRE57WH73obIQp9f6Z8XaZNeoMSGbRVYYTiKq4PcEa2JP/6
         Se7RmcZWwDJeA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 16ACF60A70;
        Mon, 22 Mar 2021 20:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: move the ptype_all and ptype_base declarations
 to include/linux/netdevice.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644500908.31591.13877278145980499716.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:30:09 +0000
References: <20210322113148.3789438-1-olteanv@gmail.com>
In-Reply-To: <20210322113148.3789438-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 13:31:48 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> ptype_all and ptype_base are declared in net/core/dev.c as non-static,
> because they are used by net-procfs.c too. However, a "make W=1" build
> complains that there was no previous declaration of ptype_all and
> ptype_base in a header file, so this way of declaring things constitutes
> a violation of coding style.
> 
> [...]

Here is the summary with links:
  - [net-next] net: move the ptype_all and ptype_base declarations to include/linux/netdevice.h
    https://git.kernel.org/netdev/net-next/c/744b83766322

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


