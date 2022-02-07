Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBAA4ABEFD
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447816AbiBGNBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442706AbiBGMjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 07:39:21 -0500
X-Greylist: delayed 2993 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 04:30:10 PST
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF90C1DE9E0;
        Mon,  7 Feb 2022 04:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 287B561136;
        Mon,  7 Feb 2022 12:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EE75C340F1;
        Mon,  7 Feb 2022 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644237009;
        bh=TQttV9rtYzqhHfeNBQDxHl8A0+m6499YWV2geA1yai4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b/+fctSGj5ic+2tFBcfPVDEQx26Lcov/5B0JZ5aOKnfW5IS/9uxUXpvBohbBzVb3K
         RZBh1GqFn3fpcwqHsvmfgD89iB3NIHkPciC6fCO1lyRcB8+5rrdjHKehiV7STxlGm4
         XNM0APROX/eOBg9yA7xeqERMkfObLGA+acvvaSgNt3LAFW3FBMDr39RH+CdzhwITLf
         xDAPRnQBL4NvR0ACmQFajIeSlqNrvvJ93306Xl9mEtzWABeP+XJfbT77yoNbwTw9HU
         +vgQu7ahStVjp5BS0bCbyiETta7/Jvc8SDmVZVtNkULRoF8j9pxgtruRavP7bSfoXP
         8tTcfqeCYNjAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A4CDE5CF96;
        Mon,  7 Feb 2022 12:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: asix: add proper error handling of usb read
 errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164423700949.1174.9751271199804188333.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Feb 2022 12:30:09 +0000
References: <20220206180516.28439-1-paskripkin@gmail.com>
In-Reply-To: <20220206180516.28439-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch, oneukum@suse.com, robert.foss@collabora.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com,
        o.rempel@pengutronix.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  6 Feb 2022 21:05:16 +0300 you wrote:
> Syzbot once again hit uninit value in asix driver. The problem still the
> same -- asix_read_cmd() reads less bytes, than was requested by caller.
> 
> Since all read requests are performed via asix_read_cmd() let's catch
> usb related error there and add __must_check notation to be sure all
> callers actually check return value.
> 
> [...]

Here is the summary with links:
  - [net-next] net: asix: add proper error handling of usb read errors
    https://git.kernel.org/netdev/net-next/c/920a9fa27e78

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


