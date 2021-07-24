Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8B33D494F
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 21:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhGXSTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 14:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhGXSTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Jul 2021 14:19:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BF5E060E96;
        Sat, 24 Jul 2021 19:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627153204;
        bh=X0lu+ZJRFVPZGNnN7P9adSLeFWJ5P9htf4aao/xW3xs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iZQnUyvsQTYi4h7ucyZOFwmEz79E4FBy/tEH+EeXIfAMmdZiR2C9qpYj+Z8fyETax
         d2LTBAUV5R4hLy+vmeLy+prylY1jLsLnFMIFsthtg8cW+bOjsUS22xIuufTBSz5mdf
         Ai5jGRUSH8NLiUGtmuliMwPbmOy0ve2CivmEwFzKm4ZyJMX9z/QFqmHD4gfDr6ZLj1
         APZtQtmabcz5XsNUQj9towSxnJbuP1NnWUnujDsa+QpQGmPw/9D6HOfJWownGixj/8
         vMOOMRjzcdExfxjggnwA/6922FPxEMP7RW7qzd9DunQRZ2bh8ha5TlhjwtnCuMpLAO
         JSG0qDm4Drshg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B44F360972;
        Sat, 24 Jul 2021 19:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnxt_en: Add missing periodic PHC overflow check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162715320473.905.17069334820032867634.git-patchwork-notify@kernel.org>
Date:   Sat, 24 Jul 2021 19:00:04 +0000
References: <1627077228-887-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1627077228-887-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com, richardcochran@gmail.com,
        pavan.chebbi@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Jul 2021 17:53:48 -0400 you wrote:
> We use the timecounter APIs for the 48-bit PHC and packet timestamps.
> We must periodically update the timecounter at roughly half the
> overflow interval.  The overflow interval is about 78 hours, so
> update it every 19 hours (1/4 interval) for some extra margins.
> 
> Fixes: 390862f45c85 ("bnxt_en: Get the full 48-bit hardware timestamp periodically")
> Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> 
> [...]

Here is the summary with links:
  - [net] bnxt_en: Add missing periodic PHC overflow check
    https://git.kernel.org/netdev/net/c/89bc7f456cd4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


