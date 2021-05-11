Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7ED37B298
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhEKXeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhEKXeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 19:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9A5AD616EA;
        Tue, 11 May 2021 23:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620775989;
        bh=mPsbuoU1qI42gtjm/aOYexYfJtRysvHEwGHhkKcwni8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JRMJfokqzAniGDf99U3Rn+x2XPTem1YIliOe7Pk8f30jqva6A4QUtTvmKmpMFIfuV
         TGrPqX8Cgvwew4d/mJMzfC5CfW7XImmr/9St0o7ire8zIlKkWtLzJUDDyt6qZsZfQ9
         p5gnGO7zE1vjgHy6kvhd1l/rQRRSxH7zsCO322/T9oZIsx0fisvFAx1F3rMfOAAYUG
         AaTDISfVdQhkJPBHFo6lsfa6YxcaIDkYkYG/2TQRKfy9e+zjhBnnrem6KkVHW4m1t4
         yGIXLybNl24EyLp5M38igw4WCcMLAnVofgTbRrx62xcIS6oAL4/dX8cMiimuPSeFll
         TlE3Wj46rnMOA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8C7BE60A48;
        Tue, 11 May 2021 23:33:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net] ionic: fix ptp support config breakage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162077598957.17752.14804279276679451090.git-patchwork-notify@kernel.org>
Date:   Tue, 11 May 2021 23:33:09 +0000
References: <20210511181132.25851-1-snelson@pensando.io>
In-Reply-To: <20210511181132.25851-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, rdunlap@infradead.org, allenbh@pensando.io
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue, 11 May 2021 11:11:32 -0700 you wrote:
> When IONIC=y and PTP_1588_CLOCK=m were set in the .config file
> the driver link failed with undefined references.
> 
> We add the dependancy
> 	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
> to clear this up.
> 
> [...]

Here is the summary with links:
  - [v4,net] ionic: fix ptp support config breakage
    https://git.kernel.org/bpf/bpf/c/bcbda3fc6162

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


