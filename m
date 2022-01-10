Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C43488DA9
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237666AbiAJBAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbiAJBAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526D0C06173F;
        Sun,  9 Jan 2022 17:00:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E073061042;
        Mon, 10 Jan 2022 01:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20AFDC36AE3;
        Mon, 10 Jan 2022 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776409;
        bh=iOIfAqVkgml1lX6oMXE7USc/dEvwwudMzPWrQjP7u3k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WNlMM9BctELe2LwCTPc67v2ZTWgT3XasjeaAZktTnzYqfL9hSI+zF16yVh+vYIgo8
         FXiYUjW49GMYIZU6sF2PEDNb2DGDYyrIgIC0sOzNh4EZCztAueAkG81U5N6oUNCLPC
         d5GSuF+E9F7z3Bi5fzWMdBGjnbOSoa9ro7QG5KTu22fJyibED06BRpU5FOQKLcz/7+
         R6WAi/JuFrKjuUWMAab5GV7PTavFvZkU67kRIQoEqn0XIqxH3mvk2HN7Ug6T/LagQ9
         vmGtSwWogsOkVRoiaS25MG3kvDieY+WKM00IY5khlEKWP8tgDFSVrPJxIy6ceUtyqn
         6ce6Mq8+Gt/Vw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07981F6078F;
        Mon, 10 Jan 2022 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mcs7830: handle usb read errors properly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177640902.18208.15482694955918570197.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:09 +0000
References: <20220106225716.7425-1-paskripkin@gmail.com>
In-Reply-To: <20220106225716.7425-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, tanghui20@huawei.com,
        andrew@lunn.ch, oneukum@suse.com, arnd@arndb.de,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+003c0a286b9af5412510@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  7 Jan 2022 01:57:16 +0300 you wrote:
> Syzbot reported uninit value in mcs7830_bind(). The problem was in
> missing validation check for bytes read via usbnet_read_cmd().
> 
> usbnet_read_cmd() internally calls usb_control_msg(), that returns
> number of bytes read. Code should validate that requested number of bytes
> was actually read.
> 
> [...]

Here is the summary with links:
  - net: mcs7830: handle usb read errors properly
    https://git.kernel.org/netdev/net/c/d668769eb9c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


