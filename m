Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2841C287CB9
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbgJHUAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbgJHUAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 16:00:05 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602187205;
        bh=BoMuwIWp9CUUPOaNF8Mx5CCkfQgRzA6X9E339IgD0s4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TYipnh2fLXzGCz8wf8rb9kKF6v5H6fWGDAn7KeCjlBjGAHuJP+hFFrSMdLEmCr0UU
         JH9REnVu12DgoUvbRNDhyj0mxWNU7DepZc9xNTMZVdwXtNuK8Lq0f1J/Z9VvFhkFkl
         3YF/IH2XF39nH/qJfGdDncgD3AzLNL3JmF6HIRxg=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2020-10-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160218720512.8125.14062083531509587455.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Oct 2020 20:00:05 +0000
References: <20201008103935.43636-1-johannes@sipsolutions.net>
In-Reply-To: <20201008103935.43636-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Thu,  8 Oct 2020 12:39:34 +0200 you wrote:
> Hi Dave,
> 
> Not sure you were still planning to send anything to Linus,
> but even if not this single fix seemed appropriate for net.
> Seems to be a long-standing issue.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2020-10-08
    https://git.kernel.org/netdev/net/c/a9e54cb3d5eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


