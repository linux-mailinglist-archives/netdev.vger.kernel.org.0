Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5F93B7802
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 20:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbhF2Smk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 14:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235133AbhF2Smc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 14:42:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1A8C761DEE;
        Tue, 29 Jun 2021 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624992005;
        bh=vC2StG/wIgCajMn7oCwMdYto7uziqoYb2ktiw6yd3TI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XcRe/MZVFPFjprC0URPmj6fu5QNhTaorjKaR5CKO2oP76HnMBBmrK1FRra3LmP1pl
         LxjQCg6VXSubIjwZxv/fEynFXodQRQL3WYAmFJbBk+oLfN0m+YgTbi7n5DaR2s5teB
         yZYD9EynZVKzmdDo5MmbXXq+lLC8ZMl8KpnyEwAQbRts5X+FHSQi8e+BKjufuaYqV+
         HJtyVaG5qwM3dkWebuydzL9X0gQ9QDKrJKDGLQCvvTiYlot9JV+JQp3QpFUc7y90qQ
         e/9+ZwUrd45t86QWcpO0r+A8A7olSraGoelPdF+t216P9tgMK2eTx2Olxlix8REJH6
         b43RzaGylbD3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 15AA860ACA;
        Tue, 29 Jun 2021 18:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 1/2] utils: Fix BIT() to support up to 64 bits on
 all architectures
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162499200508.24074.10950679170977529083.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Jun 2021 18:40:05 +0000
References: <20210628232446.GA1443@cephalopod>
In-Reply-To: <20210628232446.GA1443@cephalopod>
To:     Ben Hutchings <ben.hutchings@mind.be>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2.git (refs/heads/main):

On Tue, 29 Jun 2021 01:24:46 +0200 you wrote:
> devlink and vdpa use BIT() together with 64-bit flag fields.  devlink
> is already using bit numbers greater than 31 and so does not work
> correctly on 32-bit architectures.
> 
> Fix this by making BIT() use uint64_t instead of unsigned long.
> 
> Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
> 
> [...]

Here is the summary with links:
  - [iproute2,1/2] utils: Fix BIT() to support up to 64 bits on all architectures
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=4ac0383a598d
  - [iproute2,2/2] devlink: Fix printf() type mismatches on 32-bit architectures
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=33cf9306c824

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


