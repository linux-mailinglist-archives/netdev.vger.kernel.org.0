Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF7D36629C
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 01:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbhDTXus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 19:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233992AbhDTXup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 19:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C1DC161405;
        Tue, 20 Apr 2021 23:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618962612;
        bh=3I4pUI7rCMOG3Da0kV2d/f8WaZp3liBd8EYbJlzZkH4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VVLevUqaKSq4GkfwfDPCxI/tya9ps2hTExfMhLpXovX7eQaIS/1NnJFE8Cu0dz9of
         rC4+UKiCRFx1Jx5REW93YL/zRoIu7t9Q724RwJoWmJOovMED7VLLJkFphIowpecZWg
         Z8Pu7GNg+1JRaypp7ltb5DSlP2F3TPzMVrmlU35o+1vZqUH/7mj4xpWjJCXWd5vmXw
         hX3CDTzX9AYbVTMe3UXTk6gmw3bK63J2y4h/MGh89wZ/j3RjrT82HzVaosjgXeTGIO
         w9AUMbJfpVqtW1iZFwBou7h/+u3W+KGAYCHpubiXHEld0maySVaYdMosIQV/broHKC
         zWwKGC2anfjkw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BA04A60971;
        Tue, 20 Apr 2021 23:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211-next 2021-04-20
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896261275.30983.14370375251925432162.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Apr 2021 23:50:12 +0000
References: <20210420150031.24514-1-johannes@sipsolutions.net>
In-Reply-To: <20210420150031.24514-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Apr 2021 17:00:30 +0200 you wrote:
> Hi,
> 
> We have a bunch more things for next, now that we got another
> week "for free" ;-) Pretty much all over the map, see the tag
> description and shortlog below.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211-next 2021-04-20
    https://git.kernel.org/netdev/net-next/c/08322284c162

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


