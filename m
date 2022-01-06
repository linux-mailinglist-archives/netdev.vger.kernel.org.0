Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28579486587
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239746AbiAFNuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:50:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56178 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239719AbiAFNuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 08:50:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DB8361C16;
        Thu,  6 Jan 2022 13:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E32E0C36AF3;
        Thu,  6 Jan 2022 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641477009;
        bh=xXCkLiQRvcLtcwQnqeQGnbErIHJb2qOUr3F3LiGUgZA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hXHNk4mxtbOyueeO0+wRS/REaOCtmy3u2orqFlGLn7ur3RxsL2DLOxeJENStWXPdE
         hxxOm8uoqyvzkEEptvC4ONz4nmKj/oEQ4hOLg7uFSE9NOJ7+qZtbbQKWlfG2HHkGB9
         i8fSEZSzcKU6jQaElZSXtmrwcvEXKu3WMEMf7VO4hplOBz6dKYan9aAfcC6au8itHl
         NQPxSxAgZa6rlqed7BzTO6BoO4rrWKUMFZtrsfpYFM9/9CD+GTYf041pnmPC4zcbad
         cTNESK7AkrM8WhE/YVPOYaSNLYU28uyewY9ZCi7tKB8K+eHjGOhpR2RL8xKSKg27Xf
         tumjQuVkeoZuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CC129F79403;
        Thu,  6 Jan 2022 13:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: ibmveth: use default_groups in kobj_type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147700982.9137.17250987780109904845.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 13:50:09 +0000
References: <20220105184101.2859410-1-gregkh@linuxfoundation.org>
In-Reply-To: <20220105184101.2859410-1-gregkh@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, cforno12@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  5 Jan 2022 19:41:01 +0100 you wrote:
> There are currently 2 ways to create a set of sysfs files for a
> kobj_type, through the default_attrs field, and the default_groups
> field.  Move the ibmveth sysfs code to use default_groups
> field which has been the preferred way since aa30f47cf666 ("kobject: Add
> support for default attribute groups to kobj_type") so that we can soon
> get rid of the obsolete default_attrs field.
> 
> [...]

Here is the summary with links:
  - ethernet: ibmveth: use default_groups in kobj_type
    https://git.kernel.org/netdev/net-next/c/c288bc0db2d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


