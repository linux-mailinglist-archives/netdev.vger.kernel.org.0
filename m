Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5FE44C324
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhKJOnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:43:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232192AbhKJOm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 09:42:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 77E0C61260;
        Wed, 10 Nov 2021 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636555208;
        bh=nZ16zG6uF4VnvpiWzkXDrm6212+kVMZIcL8Uo80U5fQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cxJqPRsUmURKGB4narVaY3LGYvOfd3XCP3z2xeZq65i33F8VpIZbiH7lHPVe5iHQn
         K13tCAjo75lghVsiYuDFDBWjBzS0i5fiOqmHcIKynhmtnGTBfn8t8GziwlVFF9O6Ok
         Y9iJzZJVGiSUy2+zSHcRJ819TZ+gxH+zJO8Ld9OBgkitprN09Ti/jxrVSka6ipbUx3
         CdWQJT85OmBOgmEBYAYJfv4ogdG9t4nb4m1EDTHC11PBU7LaxNLUZ7Ln/nP8p2fpea
         fQ2zyhlSR2XsPLzs4+1/2b9/wRAI1BOcTYlEc+cr5DODqcSd1cs9FEMeM//xT2PlqT
         jIKqLW4FKzOiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 696AC60AA3;
        Wed, 10 Nov 2021 14:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: forwarding: Fix packet matching in mirroring
 selftests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163655520842.19242.8878695229328744422.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 14:40:08 +0000
References: <401162bba655a1f925b929f6a7f19f6429fc044e.1636474515.git.petrm@nvidia.com>
In-Reply-To: <401162bba655a1f925b929f6a7f19f6429fc044e.1636474515.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 9 Nov 2021 17:17:34 +0100 you wrote:
> In commit 6de6e46d27ef ("cls_flower: Fix inability to match GRE/IPIP
> packets"), cls_flower was fixed to match an outer packet of a tunneled
> packet as would be expected, rather than dissecting to the inner packet and
> matching on that.
> 
> This fix uncovered several issues in packet matching in mirroring
> selftests:
> 
> [...]

Here is the summary with links:
  - [net] selftests: forwarding: Fix packet matching in mirroring selftests
    https://git.kernel.org/netdev/net/c/af0a51113cb7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


