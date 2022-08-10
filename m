Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D1C58EC46
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 14:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbiHJMuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 08:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiHJMuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 08:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69867642D0;
        Wed, 10 Aug 2022 05:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 127FFB81C67;
        Wed, 10 Aug 2022 12:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2DA2C43150;
        Wed, 10 Aug 2022 12:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660135815;
        bh=1qiUnoUSyKKBV9aQr4Qt4D6aoMvaZ6bBov/zzS1KWvw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uYv7FwbBKLJifX1IMbpILoaEUgRicZ9pUcS9Lw/eQjF4la461hLeiyhDQqSVW1zwX
         wE+gvlx/DI6OM6Xb2UChhQSB59hS1B+CFU7+j8eSB7fjT1ss8huYQ9y36ETYnHj9aC
         SlgEMBoAkJv4ZEsEWvIfIfrdjnb0Wm1uSdZDMKIaGtj63qbZOlEh53fP/rjXPDPyrk
         PrkhSziPuqKNA/6QSvUPKlh8tLhllvyj8v/RVOq/hUisUVukHhLx59dfg0sT3Qjras
         yA1ZOiCMllKOC2ouPHhMtr7rthts+kj0nmVmJoLv+5nYJozKjDecm9ak7jNNYv6gtE
         bSgkNrq3wnDdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E063C43141;
        Wed, 10 Aug 2022 12:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] macsec: Fix traffic counters/statistics
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166013581544.3703.15289396381446018748.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Aug 2022 12:50:15 +0000
References: <20220808223823.GA109769@clayyagelx.ad.selinc.com>
In-Reply-To: <20220808223823.GA109769@clayyagelx.ad.selinc.com>
To:     Clayton Yager <Clayton_Yager@selinc.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, clayton_yager@selinc.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 8 Aug 2022 15:38:23 -0700 you wrote:
> OutOctetsProtected, OutOctetsEncrypted, InOctetsValidated, and
> InOctetsDecrypted were incrementing by the total number of octets in frames
> instead of by the number of octets of User Data in frames.
> 
> The Controlled Port statistics ifOutOctets and ifInOctets were incrementing
> by the total number of octets instead of the number of octets of the MSDUs
> plus octets of the destination and source MAC addresses.
> 
> [...]

Here is the summary with links:
  - [net] macsec: Fix traffic counters/statistics
    https://git.kernel.org/netdev/net/c/91ec9bd57f35

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


