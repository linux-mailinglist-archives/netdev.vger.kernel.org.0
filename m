Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CC64614EF
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 13:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346896AbhK2MZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 07:25:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60804 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244428AbhK2MX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 07:23:27 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE74B61370
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 12:20:09 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 60CFC60187;
        Mon, 29 Nov 2021 12:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638188409;
        bh=jvSCA87X3SfodARnORdzCVtSqWPR0kOLylmNCWE5mZw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h4LC7VzEhgkbV9zJnUN5to6bForByyjplzQeBfcSuPCM0PdtnaAzKl+XhghwNGE2T
         A261wRYoli9osLRmMAQZboftiWhlsLkYuSpZEt2K0HEc89nTWXrxLsZi5i3ksHpmn7
         suD6kIpO9q8hPTjUJqh0ZaCmcSqlsRC7n8lc6Zp8GLFaDFu23Sc9n6YpSbSKdGJh+R
         PBB/HPzJaQnPz9ZngtuhIo9IyEgL7ZVkzgiBS3c3nIVgUeeDkVZiy+MUHRlqxsdRUg
         hEZ4WL04XLXX1GPSPN/Nx3zGK7EJ15pSmZexqV5kVajvoPxbT3ynGQCaLacoyj2kFf
         2gN0KJyhRtzuA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5055360A45;
        Mon, 29 Nov 2021 12:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: dsa: realtek-smi: fix indirect reg access for
 ports>3
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163818840932.20614.12189170591435786006.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 12:20:09 +0000
References: <20211126201355.5791-1-luizluca@gmail.com>
In-Reply-To: <20211126201355.5791-1-luizluca@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, alsi@bang-olufsen.dk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 26 Nov 2021 17:13:55 -0300 you wrote:
> From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> 
> This switch family can have up to 8 UTP ports {0..7}. However,
> INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK was using 2 bits instead of 3,
> dropping the most significant bit during indirect register reads and
> writes. Reading or writing ports 4, 5, 6, and 7 registers was actually
> manipulating, respectively, ports 0, 1, 2, and 3 registers.
> 
> [...]

Here is the summary with links:
  - [net,v3] net: dsa: realtek-smi: fix indirect reg access for ports>3
    https://git.kernel.org/netdev/net/c/1e89ad864d03

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


