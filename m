Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0943138B9B3
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 00:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhETWvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 18:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232022AbhETWvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 18:51:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 80825613AE;
        Thu, 20 May 2021 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621551011;
        bh=4n0PcuduYHajRHSW49fRgqymQt+G8zdf0b7qAbPcecw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KSSGI9avqu9m9Ne/IAFmNzxkQxadnFNcxE74DZ3j0gsI90nB+kBrdwuDn65JD2KMm
         yJLsGXZCOAo0HIV5ndQkCwUletSt/5zTZ43A7wz0v+xdDy9Ct9rqj9mXaBCpNdaIr8
         eYuFckls4HA86lF4ehcw0Nu39MNssj/oq6j0+OXRS5n0BKV2zLUsLSr+z3vBbuMucK
         Yh4SMnorso3m9EK0UwWfcyjRP/j5T+poKo/EvSCNohvoI4nI0NmlDqa8W8NwCe2BUY
         0r7K/ONcmoWr5I+ej2SWGc9WrPTvJ7/r6BXs4b6LcDLU8WJdr9ZHE0dCnFaTeTxWnw
         5SNIIYq9XZ72g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 75A3260A56;
        Thu, 20 May 2021 22:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next resend] ibmvnic: remove default label from
 to_string switch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162155101147.27401.5665625357028273375.git-patchwork-notify@kernel.org>
Date:   Thu, 20 May 2021 22:50:11 +0000
References: <20210520065034.5912-1-msuchanek@suse.de>
In-Reply-To: <20210520065034.5912-1-msuchanek@suse.de>
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     netdev@vger.kernel.org, lijunp213@gmail.com, drt@linux.ibm.com,
        sukadev@linux.ibm.com, tlfalcon@linux.ibm.com, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, davem@davemloft.net,
        kuba@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 20 May 2021 08:50:34 +0200 you wrote:
> This way the compiler warns when a new value is added to the enum but
> not to the string translation like:
> 
> drivers/net/ethernet/ibm/ibmvnic.c: In function 'adapter_state_to_string':
> drivers/net/ethernet/ibm/ibmvnic.c:832:2: warning: enumeration value 'VNIC_FOOBAR' not handled in switch [-Wswitch]
>   switch (state) {
>   ^~~~~~
> drivers/net/ethernet/ibm/ibmvnic.c: In function 'reset_reason_to_string':
> drivers/net/ethernet/ibm/ibmvnic.c:1935:2: warning: enumeration value 'VNIC_RESET_FOOBAR' not handled in switch [-Wswitch]
>   switch (reason) {
>   ^~~~~~
> 
> [...]

Here is the summary with links:
  - [v2,net-next,resend] ibmvnic: remove default label from to_string switch
    https://git.kernel.org/netdev/net-next/c/07b5dc1d515a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


