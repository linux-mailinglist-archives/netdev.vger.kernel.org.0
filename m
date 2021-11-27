Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98DA45F7AF
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 01:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344471AbhK0Az2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 19:55:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38018 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344122AbhK0Ax1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 19:53:27 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1142B8299A
        for <netdev@vger.kernel.org>; Sat, 27 Nov 2021 00:50:12 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 196CE601FC;
        Sat, 27 Nov 2021 00:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637974211;
        bh=v8BOn7EPv3xrqT4+YqYoa4aVCb5AluDB5tNqp1286cE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X0qeK9kERWhhQzgiD/PBi3Vp/QahRo2qmWaX2Kzkw1q0p6DKR52RLCkK1TuZgEQ91
         iA0YYKA2b6l/bDDwj8KklPw6gNWcLi37rvXrRfpLyZZNZQEaYcVmeVWg/RQgokCRkx
         5xXBNoCpnOoljA2np78oqp+AEZZVfJ6sgk15SKWhym/yDCVCh1tIat0DKBYFmGiLDj
         xIKLiuioEtv1WGfioRwASgjbRoBLtMR3l4mSF0O+1tgcLs9VWCRY6Wn0kZb658WXXP
         oqgsMFaMCKrU7pRgp8IwzI70Xy8YQlyZ2iG40sGU9q5ZJvP957rowAMce8VuOn+ZsK
         7TJdZdZ9Itg1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0B58D60BC9;
        Sat, 27 Nov 2021 00:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] bridge: use __set_bit in __br_vlan_set_default_pvid
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163797421104.20298.2423972399369533865.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Nov 2021 00:50:11 +0000
References: <4e35f415226765e79c2a11d2c96fbf3061c486e2.1637782773.git.lucien.xin@gmail.com>
In-Reply-To: <4e35f415226765e79c2a11d2c96fbf3061c486e2.1637782773.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        nikolay@nvidia.com, christophe.jaillet@wanadoo.fr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 14:39:33 -0500 you wrote:
> The same optimization as the one in commit cc0be1ad686f ("net:
> bridge: Slightly optimize 'find_portno()'") is needed for the
> 'changed' bitmap in __br_vlan_set_default_pvid().
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/bridge/br_vlan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] bridge: use __set_bit in __br_vlan_set_default_pvid
    https://git.kernel.org/netdev/net-next/c/442b03c32ca1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


