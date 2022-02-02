Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610D24A6B0F
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244600AbiBBEuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:50:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41762 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiBBEuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 23:50:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CCD8B83009
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 04:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4C67C340EC;
        Wed,  2 Feb 2022 04:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643777409;
        bh=YUGqJcXGOr7/xJDGTmzpu4Xo+5FAf7313XBgeg76Wwg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kFQZXgIY9TS4fb72Fc1INt1MsTJ7nKtGlYrplLJlHwNnnloSVnPZ1MhdjVeSqKnFe
         xeZiLMOyrwUBIOHCpH5P49sf60KvCABO3tI2+jsFRH/W2VT1cPtDA6TFoff0R5JYZ6
         resdRgtROun3RTL05Wgh/JsvAG6Lgy9lmMQLCvecWgiOoPo28/JjJXKE8V9z7A3Joz
         QtaNW1S/GnBJ7h9cXxsb9yBbyjJJDqD4Di4mW4oEhZHJNR5xOB3HsPYQJicbzieyZM
         O6KxACI2cbzzxnn68+azksCZ64wQrDHkCkungg72Nj3jYVMKBEqrKVEUuZuaYsEVD/
         G0tkLVz4tmT9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BBA4BE5D091;
        Wed,  2 Feb 2022 04:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-01-31
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164377740976.22410.8031500159418958196.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 04:50:09 +0000
References: <20220201000522.505909-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220201000522.505909-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 31 Jan 2022 16:05:20 -0800 you wrote:
> This series contains updates to i40e driver only.
> 
> Jedrzej fixes a condition check which would cause an error when
> resetting bandwidth when DCB is active with one TC.
> 
> Karen resolves a null pointer dereference that could occur when removing
> the driver while VSI rings are being disabled.
> 
> [...]

Here is the summary with links:
  - [net,1/2] i40e: Fix reset bw limit when DCB enabled with 1 TC
    https://git.kernel.org/netdev/net/c/3d2504663c41
  - [net,2/2] i40e: Fix reset path while removing the driver
    https://git.kernel.org/netdev/net/c/6533e558c650

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


