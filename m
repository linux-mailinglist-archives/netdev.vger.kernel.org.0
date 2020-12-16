Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7BF2DC735
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388810AbgLPTdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:33:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388789AbgLPTdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:33:12 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608146407;
        bh=NzsWV+sstLWeOUpPdP4hdpEl0vduuD2SXll3ZDiy5JQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qtibT3e5tVjmzndlbyENxp9eSQQ29h+la4VUEnz9N6Ku1TyOW3X/OvkH2kCWK3Ui5
         diNBKAZRto1DhTW1lxMZESkrmliQ438pZLLz1fdx4lxhKxBy/bYh8Qk4JgTwYVIj7/
         /5EBU5fOrXEmQGbS6OiNGAGE7Sq0aA/7Vw8es/nIy4ZwLEYUBFJlkZ/R1exXwqDLoJ
         YQUVjrNz1Ob8F28H7BAWBMIxttpn1eqJiw0vnmS/zwbaLjxmWQ/KHDxYhzr1OS17aR
         MKzzhbqB8wAyIQnddve7K49hcpfUn4e2ciEXHJj1B8PBYjEUGLUf9sriKi55q2/xbG
         bjHmQtjFzLL7Q==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethtool: fix string set id check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160814640700.4483.15306341559580435176.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Dec 2020 19:20:07 +0000
References: <b54ed5c5fd972a59afea3e1badfb36d86df68799.1607952208.git.mkubecek@suse.cz>
In-Reply-To: <b54ed5c5fd972a59afea3e1badfb36d86df68799.1607952208.git.mkubecek@suse.cz>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 14 Dec 2020 14:25:01 +0100 (CET) you wrote:
> Syzbot reported a shift of a u32 by more than 31 in strset_parse_request()
> which is undefined behavior. This is caused by range check of string set id
> using variable ret (which is always 0 at this point) instead of id (string
> set id from request).
> 
> Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")
> Reported-by: syzbot+96523fb438937cd01220@syzkaller.appspotmail.com
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> 
> [...]

Here is the summary with links:
  - [net] ethtool: fix string set id check
    https://git.kernel.org/netdev/net/c/efb796f5571f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


