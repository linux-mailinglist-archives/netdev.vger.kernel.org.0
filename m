Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F333475B79
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 16:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243714AbhLOPKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 10:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243550AbhLOPKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 10:10:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C68C06173E
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 544716195C
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 15:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE303C3460A;
        Wed, 15 Dec 2021 15:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639581012;
        bh=AaErzTsbc4hv0y1sNjy/pFEjPdK7fHCRTjvho4DU648=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=obAIdUA97AEMx9fDCeijK/h0yI8pVudRwiikizo+nVvQq0VfFqvg765MB96YTz5iI
         8RI98N+JeBa9bgEube17eXdPBB5ZM66oQwtPOnbme1E/yDPwAZGChXgQlrsQMvxsnh
         zNWi1Pm7jSA4PsZeEYYZqLr2JZ+1GMXGcx1+5ZQsQOwYUJtQ0iBBrqisR146GntUcP
         s/UsW0oC42A3dDrg7s3cAV0VJDj3VBJIHjTYyssbVYPU46/IeTm4BSqQQHG9pqzcDl
         bMKCA3J2HqHTXRqKfc6Tfc4c2z6LC0VknQvaJ83mSsKXaiWKN+OdGlFmyaLjRok1nI
         NXNjhten4mGSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9B57D60BC9;
        Wed, 15 Dec 2021 15:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethtool: always write dev in
 ethnl_parse_header_dev_get
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163958101263.23013.18243680978313600892.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 15:10:12 +0000
References: <20211214154725.451682-1-kuba@kernel.org>
In-Reply-To: <20211214154725.451682-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Dec 2021 07:47:25 -0800 you wrote:
> Commit 0976b888a150 ("ethtool: fix null-ptr-deref on ref tracker")
> made the write to req_info.dev conditional, but as Eric points out
> in a different follow up the structure is often allocated on the
> stack and not kzalloc()'d so seems safer to always write the dev,
> in case it's garbage on input.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] ethtool: always write dev in ethnl_parse_header_dev_get
    https://git.kernel.org/netdev/net-next/c/3bc14ea0d12a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


