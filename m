Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E354317491
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhBJXlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:41:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233711AbhBJXkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 18:40:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B3BDC64EBB;
        Wed, 10 Feb 2021 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613000411;
        bh=6HZXK9JIlkf4RwRH1qhPHLrCTwKhdjTC+sjdaXO4/tE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Owf8UsTRg50naQONrweUIYj9b2HsdJvf7D475I0/AdXTkf0HGXT03XMmdoLiHJZ+c
         Pzsoh1X5dWqpUtwmnakc03aUd3r4SS9zChvr1MPamzDYWcSfWTUYP1KXszgRwCUove
         gA8DHMf4q7dZNEcqEkRZZYt7zbPWts/FsuvKKo+yaDsI1OnN+YhVx6G+DxJvYtDhU3
         CDZDKmZ3kFeyekV22GT6KfQGckg5uIYoH+qDhwg5Hv3bDM1viLcX/jo0joZjlEqObX
         Tzty0OeHUSU3RP18piJSMT6REeC1jRevtGFHjgdaLz8D/HePspZQIG6Ubs+Qz93wJv
         b4F0YPKDgQ0UA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9D358609D4;
        Wed, 10 Feb 2021 23:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v5] net/sched: cls_flower: Reject invalid ct_state flags
 rules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161300041163.23198.6818005176455852907.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Feb 2021 23:40:11 +0000
References: <1612852669-4165-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1612852669-4165-1-git-send-email-wenxu@ucloud.cn>
To:     wenxu <wenxu@ucloud.cn>
Cc:     jhs@mojatatu.com, mleitner@redhat.com, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  9 Feb 2021 14:37:49 +0800 you wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Reject the unsupported and invalid ct_state flags of cls flower rules.
> 
> Fixes: e0ace68af2ac ("net/sched: cls_flower: Add matching on conntrack info")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> 
> [...]

Here is the summary with links:
  - [net,v5] net/sched: cls_flower: Reject invalid ct_state flags rules
    https://git.kernel.org/netdev/net/c/1bcc51ac0731

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


