Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC914A5703
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 06:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbiBAFkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 00:40:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45028 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbiBAFkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 00:40:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A52A9B82D03
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 05:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A69CC340F3;
        Tue,  1 Feb 2022 05:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643694009;
        bh=XnGTSkC9suwhkfJ7CVES2RwQ+hIHiNktl0vwwi/DXoo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OAi9em0H5z7sXVjswHbNPegl0BywSGqGRM0P8VzvSBpew87FdIk6QypWB8wlgVeB+
         61RkVrvQb9XfMTnImS1jylaVYEBt3eXjkWPJaAJdsSki1P8VUQLwUdJaD/Csq4471M
         hXcQvz0mh1YZp6O++McXII6YU1UQynlgF4uy02rdhBrGBhJy+ZLpc0TD6dxdsgQeXo
         8MfOSx1i6W3DxWvBlBmntAGsmssGfO3CC9/s0dFYiZ2K4ezhFe9qmfNF/ZYYqkC9Ke
         lj9UI0SFIq4/ltZrAzbkclrubIZBcZa3cJa3sZOJTgvoSlvXzBTHvtGPZJsd4HMxGJ
         BVxPnDn8EumbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A6A3E6BAC6;
        Tue,  1 Feb 2022 05:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] qed: use msleep() in qed_mcp_cmd() and add
 qed_mcp_cmd_nosleep() for udelay.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164369400930.8547.10295274627670749781.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Feb 2022 05:40:09 +0000
References: <20220131005235.1647881-1-vbhavaraju@marvell.com>
In-Reply-To: <20220131005235.1647881-1-vbhavaraju@marvell.com>
To:     Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, palok@marvell.com,
        aelior@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 30 Jan 2022 16:52:35 -0800 you wrote:
> Change qed_mcp_cmd() to use msleep() (by setting QED_MB_FLAG_CAN_SLEEP
> flag) and add new nosleep() version of the api. These api are used to
> issue cmds to management fw and the change affects how driver
> behaves while waiting for a response/resource.
> 
> All sleepable callers of the existing api now use msleep() version. For
> non-sleepable callers, the new nosleep() version is explicitly used.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] qed: use msleep() in qed_mcp_cmd() and add qed_mcp_cmd_nosleep() for udelay.
    https://git.kernel.org/netdev/net-next/c/ef10bd49df23

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


