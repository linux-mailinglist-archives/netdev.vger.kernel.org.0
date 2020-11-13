Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637332B2585
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgKMUaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgKMUaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 15:30:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605299405;
        bh=UWgIB04OJw7DnbIqhDTHv21mich6V9zV5vM9QFEYVII=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L9hZEh9H19yhjqC1mcrwkV9nE5fpCYsXqjlg1KgUkT0tTbO2pqWJ9lNTZpH7G419K
         HrXAscQEBjFrKLzVNLqW4FwjX5YU17j6hKr9Gz51gaB1CcZVqqjYNT4geCd/L2NRXC
         ifSezc2TvwvRu5ZGpjq2TqpCSb7PTW65xiWorpEE=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211-next 2020-11-13
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160529940583.16653.15043484760036086957.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Nov 2020 20:30:05 +0000
References: <20201113101148.25268-1-johannes@sipsolutions.net>
In-Reply-To: <20201113101148.25268-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Fri, 13 Nov 2020 11:11:47 +0100 you wrote:
> Hi Jakub,
> 
> And here's another set of patches, this one for -next. Nothing
> much stands out, perhaps apart from the WDS removal, but that
> was old and pretty much dead code when we turned it off, so it
> won't be missed.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211-next 2020-11-13
    https://git.kernel.org/netdev/net-next/c/f8fd36b95ee4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


