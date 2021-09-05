Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9E6400FA0
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 14:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237807AbhIEMVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 08:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhIEMVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 08:21:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 85C6660EE6;
        Sun,  5 Sep 2021 12:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630844405;
        bh=J2BkBNWVOV76htMzrfOMi0F8o1cYpoPckQ+wf6P4loA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VDRUMfZ30vmVdoWf6jEwbeP035iGFmglsltqaYrBisc09pttxkjSKN3/fOKIRr3u8
         JA0q8UL+b5T2i9EpQfX1lPdELIapAklK8DyCAF15cLOXn+jkzT9Nysg8Z2eU65JTdM
         U38MVX9M2SxVz0OLAosc8oW1UPsm4M1v7aiNgiGI/AGOH91zmWzjPRDth4pxhU1S26
         P+kGn49jOZqDrMBMuqsSM1RGRKVE3ySetgQUAvuQlrD3M17bvvcnzoTTJs1FSysDo9
         vT85q2OF+AIRVSQhgA8BRPZdOVaKKFGipps10Ye6Y7zFmAeH21HYuXhdyXOTs9WJKr
         oa0iPjWIynWDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7A12260A54;
        Sun,  5 Sep 2021 12:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 1/1] bonding: complain about missing route only once for
 A/B ARP probes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163084440549.8315.17060474915496279544.git-patchwork-notify@kernel.org>
Date:   Sun, 05 Sep 2021 12:20:05 +0000
References: <20210904063129.3969050-1-decot+git@google.com>
In-Reply-To: <20210904063129.3969050-1-decot+git@google.com>
To:     David Decotigny <decot+git@google.com>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, maheshb@google.com,
        ddecotig@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  3 Sep 2021 23:31:29 -0700 you wrote:
> From: David Decotigny <ddecotig@google.com>
> 
> On configs where there is no confirgured direct route to the target of
> the ARP probes, these probes are still sent and may be replied to
> properly, so no need to repeatedly complain about the missing route.
> 
> 
> [...]

Here is the summary with links:
  - [v1,1/1] bonding: complain about missing route only once for A/B ARP probes
    https://git.kernel.org/netdev/net/c/0a4fd8df07dd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


