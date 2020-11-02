Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B662A328B
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 19:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgKBSKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 13:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgKBSKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 13:10:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604340605;
        bh=8znbpjIa4ApYjgL8U0qo74Iq/dyVXHBLyVj0W5JTlnk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ApWZ2b1/p2UML1bZ2UO5GIgIjVzIW/5kQVhkwvA4GB4nTuVGiVMg48gGO3546Kk8L
         q5r3rHuygV3+T3VHdYx3cui79bVlNvLrQjQ94fqjyN1wYh4Qn9W2rXp/EXpDmxA9Ab
         BgOznJ9eoLYoL2m6c1H1bPYxqtTApx33Yy1LVBK8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2020-10-30
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160434060520.11072.18431876955184494274.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Nov 2020 18:10:05 +0000
References: <20201030094349.20847-1-johannes@sipsolutions.net>
In-Reply-To: <20201030094349.20847-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Fri, 30 Oct 2020 10:43:48 +0100 you wrote:
> Hi Jakub,
> 
> Here's a first set of fixes, in particular the nl80211 eapol one
> has people waiting for it.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2020-10-30
    https://git.kernel.org/netdev/net/c/04a55c944f15

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


