Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CD033E18A
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhCPWkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231373AbhCPWkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B16FE64F2A;
        Tue, 16 Mar 2021 22:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615934407;
        bh=QSzk3G322LUh5p89T8EueVOrcDmdR+ub1eogbrm6IrQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YJBfrn1gAmf1+OWPKcvbGImmTsF/LlxcWDAEkUm1MFUxOKh6R+TBPdqemaCSmOJ7h
         F1XvhRWcaDzIotsvzW6pmWoEXDyDFLOjrAt2Ew97ZPNNsar/QxY2M2UC4qRQ1ddG1j
         xwVPZMi0qAT4aBuXa9vyfhX/CD5KVX8KrgZm7+8QTdrpLJmsIn8m+7pMld/QQJmm43
         KQXXskoZSYVD1CMV+DA8UrMHaBETJ4mF5u+OlEjBr0BEIzq5O/tKR00L+wnANh0OzY
         1DMyvt+jgnoCJJOYGp+93v51d3Ow5Z9iw/cQBDmnEiKimkQO+inLA+LZrXpzAeNl6O
         gFTJ7ZuUkJOHw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9EBDF60A45;
        Tue, 16 Mar 2021 22:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: act_api: fix miss set post_ct for ovs after do
 conntrack in act_ct
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593440764.11342.9275568671553426380.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 22:40:07 +0000
References: <1615883634-11064-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1615883634-11064-1-git-send-email-wenxu@ucloud.cn>
To:     wenxu <wenxu@ucloud.cn>
Cc:     kuba@kernel.org, mleitner@redhat.com, netdev@vger.kernel.org,
        jhs@mojatatu.com, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 16 Mar 2021 16:33:54 +0800 you wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> When openvswitch conntrack offload with act_ct action. The first rule
> do conntrack in the act_ct in tc subsystem. And miss the next rule in
> the tc and fallback to the ovs datapath but miss set post_ct flag
> which will lead the ct_state_key with -trk flag.
> 
> [...]

Here is the summary with links:
  - [net] net/sched: act_api: fix miss set post_ct for ovs after do conntrack in act_ct
    https://git.kernel.org/netdev/net/c/d29334c15d33

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


