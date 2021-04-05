Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4D3354883
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 00:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242775AbhDEWKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 18:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242678AbhDEWKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 18:10:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C699A613DC;
        Mon,  5 Apr 2021 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617660609;
        bh=JNJYD9b52dFWU2LT48z84lhgV/FbvuYQdrZmTYOkicQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BpOirhVigPLeoNDVJAtJwnd39gosS74Jb7lMxdOwsu0ZG9iDa3hEzhgtVQZnhJvJ/
         qDsudyMt9VFYceWUY9nWdka5OTtvb9RuRsmgZMaRMTASv64TnHEtVwWqf5omgPz+sQ
         k/Yl0+Ld00YDni2wSJ+uhuumjyCLGuqvK9t4M/pdjVYQZF/GrOhr93l4CqwufZAwYI
         YAZHP9XtdihUf9txPa8o86ZO07WOzPH+NTmz+aqvb4cfx0TlHToe8XBcP7Pnn1YGPX
         DNA3RKj4/TYaGYUcxlszOEoxWwsKJllxwtf1kKLqfcLQlsOL4z2QVPYsoaCRN67Ud+
         RxwdgVJybARnw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BED2C60A19;
        Mon,  5 Apr 2021 22:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: smsc911x: skip acpi_device_id table when !CONFIG_ACPI
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161766060977.24414.13288647159413382781.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 22:10:09 +0000
References: <20210405181548.52501-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210405181548.52501-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     steve.glendinning@shawell.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  5 Apr 2021 20:15:48 +0200 you wrote:
> The driver can match via multiple methods.  Its acpi_device_id table is
> referenced via ACPI_PTR() so it will be unused for !CONFIG_ACPI builds:
> 
>   drivers/net/ethernet/smsc/smsc911x.c:2652:36: warning:
>     ‘smsc911x_acpi_match’ defined but not used [-Wunused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> [...]

Here is the summary with links:
  - net: smsc911x: skip acpi_device_id table when !CONFIG_ACPI
    https://git.kernel.org/netdev/net-next/c/cc0626c2aaed

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


