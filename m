Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661E949E47C
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242296AbiA0OUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:20:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36576 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbiA0OUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:20:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C035E61CEC
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26473C340EB;
        Thu, 27 Jan 2022 14:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643293213;
        bh=nCsHdbCHIqIx+tTyqIvhUNuOSQLX2ZL3GR3/U74hFPc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rLNQIKxpJ3Ytexeho3dSe62YA9YfUJThVFO4u0tCY23VJcTsi7UKyvQDKKDH2bk9u
         o0l+zVaOwBPDKIRFw2M0B7qU1eEyoAaUueTjtvq+yuzbgpJkmLYZA0PdFSjJoCaBPu
         ne7hCSfRNUkosuvf/PxR2G/waRu9buq9gtn+++7rTfxMcqKf0H6H0O4ptbmz+UaxbS
         v9llgPAX3qPnACm481YHnT4Ww57ojvLaSqPrVuJ2ldZ/UmyuO0Yes1ucq9FVrETR1o
         7POuojCazbRr3G1PGqxlgHC1hbt8yCvJ4/cZ/kShU85ihzrKlD5eXPh5ot6lSE4ds1
         //IfgyZMChYZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 104B7E5D07E;
        Thu, 27 Jan 2022 14:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: enable ASPM L1.2 if system vendor flags it as
 safe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329321306.24382.13408707226416697144.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 14:20:13 +0000
References: <6885d6db-fbd8-a13a-3315-209ad9562c0e@gmail.com>
In-Reply-To: <6885d6db-fbd8-a13a-3315-209ad9562c0e@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org, hau@realtek.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Jan 2022 20:49:59 +0100 you wrote:
> On some systems there are compatibility issues with ASPM L1.2 and
> RTL8125, therefore this state is disabled per default. To allow for
> the L1.2 power saving on not affected systems, Realtek provides
> vendors that successfully tested ASPM L1.2 the option to flag this
> state as safe. According to Realtek this flag will be set first on
> certain Chromebox devices.
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: enable ASPM L1.2 if system vendor flags it as safe
    https://git.kernel.org/netdev/net-next/c/c217ab7a3961

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


