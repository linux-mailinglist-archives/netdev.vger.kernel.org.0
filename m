Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553523D8D5E
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 14:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbhG1MAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 08:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234647AbhG1MAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 08:00:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8CBB360FE3;
        Wed, 28 Jul 2021 12:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627473605;
        bh=s2AeNmx5QWKecNFIm9SnWG7B3e9EyGDGEwSbxaDBSyY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MukeN5LV3AueEKKlAIYwKc8FcR7eJNlaZ0j1ZLYxNJKTIXqSaqeQ7M1IV1hLltyxO
         VggCU2evGm3C2FWlcaUbsEI8ChvYRBTgtQL1ireB8kcPycrFYR+1gKlU+BPToewUZv
         QhLp0B6CwZ+Bk8W0SFec3T2uhOLquRO0Z2BmJ/WNg+rbjVokEyPT4SuL+kAwZnmOdm
         +zH/vRU90Qf3qFO6eO+y8PPwrAMFR52UVx53k9IBLZ8J8uU0G3BoefDY9kjiIhRvz7
         +P3Lk2g9vvW+A7+Oqj43BagyAdS5ruxvIdpfNrTKKPPjAWJ7YQ58gq8avf/erFPeQ6
         /DKa1OM33qgpw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 87AE060A6C;
        Wed, 28 Jul 2021 12:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower-ct: fix error return code in
 nfp_fl_ct_add_offload()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162747360555.13277.1381751380915089529.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Jul 2021 12:00:05 +0000
References: <20210728091631.2421865-1-yangyingliang@huawei.com>
In-Reply-To: <20210728091631.2421865-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        louis.peens@corigine.com, yinjun.zhang@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 28 Jul 2021 17:16:31 +0800 you wrote:
> If nfp_tunnel_add_ipv6_off() fails, it should return error code
> in nfp_fl_ct_add_offload().
> 
> Fixes: 5a2b93041646 ("nfp: flower-ct: compile match sections of flow_payload")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower-ct: fix error return code in nfp_fl_ct_add_offload()
    https://git.kernel.org/netdev/net-next/c/d80f6d6665a6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


