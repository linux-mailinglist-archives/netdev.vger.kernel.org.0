Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD991392163
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 22:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbhEZUVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 16:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234229AbhEZUVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 16:21:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 30022613BF;
        Wed, 26 May 2021 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622060410;
        bh=DeSSeW4lF6fMZK3eDx/SLzRPUyvCMK0QsJ0zCvGqkkY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UAM6ta+ExI2Ifb+I4Z8gO0cJUdAeVEPPFUIOmmaRaOU0NA76ORuLmBuh0YrkAcnQd
         A10Bv1Y6aFceHvTjSfc8oA69aP1zkkxVbw+ywjuWI6GWNuV4w1eJeHgnKZQxz9HPbi
         i9N6X143Be29eiBisoIqoI5swe+o+PoI6qHWJ5f7wfipKF7yqIQqvd//DXxEez0C7d
         JynSVRN/874AGJGa2onbzkOnkbMy6cSbb9nJ9skc7u+K5yaH+eVNYn4M3lBn5qeXpC
         yGOB7T4+8uRjzUlYAQ/fScCI4R53PpwlUhnaI0KyBsHvPnIaKyCmrmziU03IAaOI7I
         Kk7YxIvn+cySA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2471860BE2;
        Wed, 26 May 2021 20:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] nfc: st-nci: remove unnecessary labels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162206041014.2669.15973794167549257940.git-patchwork-notify@kernel.org>
Date:   Wed, 26 May 2021 20:20:10 +0000
References: <20210526011624.11204-1-samirweng1979@163.com>
In-Reply-To: <20210526011624.11204-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wengjianfeng@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 26 May 2021 09:16:24 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> Some labels are only used once, so we delete them and use the
> return statement instead of the goto statement.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> 
> [...]

Here is the summary with links:
  - [v2] nfc: st-nci: remove unnecessary labels
    https://git.kernel.org/netdev/net-next/c/c7a551b2e44a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


