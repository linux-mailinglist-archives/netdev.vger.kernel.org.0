Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C59C40482A
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 12:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbhIIKBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 06:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233436AbhIIKBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 06:01:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0BA25611F0;
        Thu,  9 Sep 2021 10:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631181607;
        bh=uW6G+55Xr23Mn765SCoyw7yb+5iRR5Cli85TZvd9pnw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F4iLPDwYUcGqpPTLOK5juS3qwtbeTNG2bCgwVMb+gLUq/h/MF2H5osl3eFQTxmG98
         cX+Gx2D+hHHNNRbLA2tvT9FWC7IHeHHA71Wnmr6QjlfijEz1MHWgePXfr8WAtW75rH
         m/YNUZatcBA0A5ilyVOJGyIJ+S7vAQ5UyLDSN2HF7+P/KmFuKdRWP1F6A9pIbMkazc
         9DieQpPwp6YLq64mKwVI2Pn0YgdEpan1IwnzyxE2Qpw48igBw1QuAd2zXguKP/Za6g
         2DEENIjIHs9KdB/SPwIZCToAeO+fmDfap9WOmTFoBuRCZU+11RuxLYlNgVuVeLm9rq
         wqJ0gAeWiRRmg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 04FF7609CC;
        Thu,  9 Sep 2021 10:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] ibmvnic: check failover_pending in login response
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163118160701.750.18276348181152037298.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Sep 2021 10:00:07 +0000
References: <20210908165820.145225-1-sukadev@linux.ibm.com>
In-Reply-To: <20210908165820.145225-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, brking@linux.ibm.com, drt@linux.ibm.com,
        ricklind@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  8 Sep 2021 09:58:20 -0700 you wrote:
> If a failover occurs before a login response is received, the login
> response buffer maybe undefined. Check that there was no failover
> before accessing the login response buffer.
> 
> Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [v3,net] ibmvnic: check failover_pending in login response
    https://git.kernel.org/netdev/net/c/273c29e944bd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


