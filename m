Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D5F41FC34
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 15:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhJBNVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 09:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232821AbhJBNVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 09:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 92F8161A10;
        Sat,  2 Oct 2021 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633180806;
        bh=Kh8sIkZTL0dvVF1Er9/KSgy3PTvckQZ8r9h6ocEYwwk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QSd1pV5rqX7buOFirKSh5WiyRQU+RbmhhQZ1Jj5PhDwSeqQbpAgzdWIqiHUtUCMOw
         OtDG7n6gDrDfuvS0CdmR+B3LwKK17lciK4RjktjDraGtNGOdmAlZQZyN6gRXuOM6/b
         kRNNLD+aq55EruYpX2laXAZ5WOKlaXola0PNnG9lvfPLvm73/SWsOq8x9PXNb4dn2o
         R3jco7P6+bd55jB/3bSjWExeMTlS9p7FF9kagyfehfXEh99MreKtGuyQF1S9Oxkzh6
         Jy01i4+QxrQmbB453KNiFA6p8Y/cwG4ZWkLX4GyT4v79bEC5gSOZMwHG3XJ2RHHlgr
         8eKC+NRsJps0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 861F860BE1;
        Sat,  2 Oct 2021 13:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH] powerpc/fsl/dts: Fix phy-connection-type for fm1mac3
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163318080654.29287.10123144597951673487.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Oct 2021 13:20:06 +0000
References: <20211002090409.3833-1-pali@kernel.org>
In-Reply-To: <20211002090409.3833-1-pali@kernel.org>
To:     =?utf-8?b?UGFsaSBSb2jDoXIgPHBhbGlAa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     mpe@ellerman.id.au, linux@armlinux.org.uk, andrew@lunn.ch,
        kabel@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat,  2 Oct 2021 11:04:09 +0200 you wrote:
> Property phy-connection-type contains invalid value "sgmii-2500" per scheme
> defined in file ethernet-controller.yaml.
> 
> Correct phy-connection-type value should be "2500base-x".
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Fixes: 84e0f1c13806 ("powerpc/mpc85xx: Add MDIO bus muxing support to the board device tree(s)")
> Acked-by: Scott Wood <oss@buserror.net>
> 
> [...]

Here is the summary with links:
  - [RESEND] powerpc/fsl/dts: Fix phy-connection-type for fm1mac3
    https://git.kernel.org/netdev/net/c/eed183abc0d3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


