Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D1A47FE06
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 16:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237305AbhL0PAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 10:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbhL0PAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 10:00:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339B5C06173E;
        Mon, 27 Dec 2021 07:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFBCCB810B0;
        Mon, 27 Dec 2021 15:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A803AC36AF1;
        Mon, 27 Dec 2021 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640617210;
        bh=teF+V/qO2zEUo6M5IfSj7IUpU9fwyRaIGCGADtiDON8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UktYwPiUqjPDd7S9UNBWp33f1jRRQJJqlb7SoBi/hH3w4bt4lH+DusGnY94w0MO04
         WkD2L7dCvPTre5uLJ1JOwjg6gnXkm2MPoORLznhIV9nEvzd70M9AhafmAsgrWNPx9H
         OWpSYalmLrd1YQIAp+nbDHUOOSmhiZiEvI5KI2otSJYYnKNSG+xuhrSOTaRzfGZeeU
         5bj3cA0Rn8X1Q/x++9y1W0dFMpeNUT09LEWK8YFrmMbFShQKpK6uWG2iX6JIEwFzyr
         P1j6+EHpAhLgRuZKtW7VlxW5Ji6r85z4Y7dzmGCskSIuBwQQJ6mZrOmDxztjt84+T/
         o/D5SaaUky0Qg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93072C395DD;
        Mon, 27 Dec 2021 15:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net:Remove initialization of static variables to 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164061721059.30887.14818874179399068995.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Dec 2021 15:00:10 +0000
References: <20211227082201.186613-1-wenzhiwei@kylinos.cn>
In-Reply-To: <20211227082201.186613-1-wenzhiwei@kylinos.cn>
To:     Wen Zhiwei <wenzhiwei@kylinos.cn>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Dec 2021 16:22:01 +0800 you wrote:
> Delete the initialization of three static variables
> because it is meaningless.
> 
> Signed-off-by: Wen Zhiwei <wenzhiwei@kylinos.cn>
> ---
>  drivers/net/fddi/skfp/hwmtm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - net:Remove initialization of static variables to 0
    https://git.kernel.org/netdev/net-next/c/b4aadd207322

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


