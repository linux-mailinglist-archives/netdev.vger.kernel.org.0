Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8968030546E
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbhA0HWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:22:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S316685AbhA0Al6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 19:41:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 98C9864D87;
        Tue, 26 Jan 2021 23:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611703811;
        bh=mDTBlFU6fVg+Nh50FH7seP1JqCtR+8tw4tJrfozLvbs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SVbwjYR2qZvlbgJQ3KuZY610baKFz/P6VMU27O5Eu0YWyrYKYjZbklrQeQc6A+DDQ
         VJDEsOa/SQeQsstLYvho2DiyQwYrCQoTaKBSCg5lsUNw6QujUVOAdhUQuGICMUIWYN
         byOsO9S1yZyfhF62tWLXFrNELaQu0w1nO5GBEW7X+23y2Y8T5O1pxMrg5oaXT4B0k7
         wqBWkLzTCdqAYZtD55IZOpcK1QvLHiEC/k6X9jE+ofE0S/nTiFroArlGn7ivrWfyZD
         V0F6ffKoxDrHvyvTQArxHIBMHuxTKoG7CICfWm7Opwzaohl24SEnJIdMzyn7l4Jo8G
         UZ9mCv77y3dmg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 906FE652DA;
        Tue, 26 Jan 2021 23:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-2021-01-26
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161170381158.29376.15758127946848067690.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jan 2021 23:30:11 +0000
References: <20210126092202.6A367C433CA@smtp.codeaurora.org>
In-Reply-To: <20210126092202.6A367C433CA@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Tue, 26 Jan 2021 09:22:02 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-2021-01-26
    https://git.kernel.org/netdev/net/c/db22ce68a9c9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


