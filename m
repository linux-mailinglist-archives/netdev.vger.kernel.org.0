Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6FD52E133
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344011AbiETAaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiETAaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:30:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3B5CEBBF;
        Thu, 19 May 2022 17:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 87421CE28C5;
        Fri, 20 May 2022 00:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE0B0C385B8;
        Fri, 20 May 2022 00:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653006612;
        bh=zrBLfoi6ZefDnvO/uCOFCwqiPT1EkKDL+CQeAwqyjZw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dwlfzx29f+vGz60f6WMdXVgL3BW1CWdo5Ai24Bv0GW6ju7N5ZLS4ffiXAgWQpp68s
         Vsc+hjMlWoEzCD5KJoUjAgaXze+s+wDbbNHPb4isvzMQESJahbGKGbxQo2mjMei1Kk
         QYn+qBz++iMr3R27zdHSQ1fVBxPqNjmlCMF6YkqWeOPzw7fRNzAaYJC/V7C+VrlHzw
         ARKLNkW/hcOiTJh8dulT6FTDtGb75ProBDTt/eYA7nPx7U89pr3axKPxlq5I0Rdj6i
         H6FdXDSXkk2Ms9dK6RWjuGbkGQ4Zznu8ZXvmVJ3S/9dh/IPpV5rQYCF0HKk8Ww/Qze
         VsOa+u6EFBM3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A551AF0389D;
        Fri, 20 May 2022 00:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/4] can: isotp: isotp_bind(): do not validate unused
 address information
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165300661267.32488.11022480105388538234.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 00:30:12 +0000
References: <20220519202308.1435903-2-mkl@pengutronix.de>
In-Reply-To: <20220519202308.1435903-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        socketcan@hartkopp.net
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Thu, 19 May 2022 22:23:05 +0200 you wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> With commit 2aa39889c463 ("can: isotp: isotp_bind(): return -EINVAL on
> incorrect CAN ID formatting") the bind() syscall returns -EINVAL when
> the given CAN ID needed to be sanitized. But in the case of an unconfirmed
> broadcast mode the rx CAN ID is not needed and may be uninitialized from
> the caller - which is ok.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] can: isotp: isotp_bind(): do not validate unused address information
    https://git.kernel.org/netdev/net-next/c/b76b163f46b6
  - [net-next,2/4] can: can-dev: move to netif_napi_add_weight()
    https://git.kernel.org/netdev/net-next/c/caf6b7f81e05
  - [net-next,3/4] can: can-dev: remove obsolete CAN LED support
    https://git.kernel.org/netdev/net-next/c/6c1e423a3c84
  - [net-next,4/4] can: mcp251xfd: silence clang's -Wunaligned-access warning
    https://git.kernel.org/netdev/net-next/c/1a6dd9996699

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


