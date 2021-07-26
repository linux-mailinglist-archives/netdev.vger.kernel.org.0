Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDEC3D587E
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 13:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbhGZKtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 06:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233162AbhGZKth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 06:49:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D046B60F38;
        Mon, 26 Jul 2021 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627299006;
        bh=YgaY8Zy4EkCDPYYrFE5ICceHsxBRph3E3/p/IhPI9CE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uocPAahTKszo93eaPuWAxtNh4hOq5CwyOMxfn9kJ3QUbrDY7huMpAPqScoM3nRnkh
         6B5g0rwFG5c3LyLoQbAun8d37wRlGMHp1z9CZfKQCWzR5uvKOve6uP+o3/CMZD8FA0
         XwRzXMXofeiFJxuANqplLDkzls3EkVAbW4plHsbbMFooDbj5ut0b979WIK7kjdH2U9
         ojsZ9Z1LewP7/t40732XlFAhB/XrcpD/pM6UalHl/S4m8YxvWNme2cir/jInF/eOYG
         btPU5eqblivwLG34fGycYsL55bv1TAsQpfV/OL+qIEyFuVauZR8OhlORPe6ndxv8UJ
         R7o+1F+qJPZyA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C681B60A5B;
        Mon, 26 Jul 2021 11:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: s3fwrn5: remove unnecessary label
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162729900680.28679.17222715468654750282.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Jul 2021 11:30:06 +0000
References: <20210726032917.30076-1-samirweng1979@163.com>
In-Reply-To: <20210726032917.30076-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     krzysztof.kozlowski@canonical.com, k.opasiak@samsung.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Jul 2021 11:29:17 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> Simplify the code by removing unnecessary label and returning directly.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  drivers/nfc/s3fwrn5/firmware.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

Here is the summary with links:
  - nfc: s3fwrn5: remove unnecessary label
    https://git.kernel.org/netdev/net-next/c/a0302ff5906a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


