Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6D146636A
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357802AbhLBMXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357809AbhLBMXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:23:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7600AC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 04:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D905B82347
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3954C00446;
        Thu,  2 Dec 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638447610;
        bh=q98llyDxwDX4NRK7sFR1/skFyWHWoIV1mvldqRSvsTk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vFRzvN8ijgbUbW6oJ3k4BkbIgnIwssr1YsoHOv89KirAwBXQlluwoSMnZibydSU2P
         G7YIRRi9jXdrbS9W99STXl3RcIfkcNuGl86saY/LDoAIjpO4rHN8Fe7iIVxKak4PaS
         TA0T7w02ijY6aPewuoajXSgWXwjhD/P2uxD7MwEh/VX47iGGyM73Whqo/lt5nRZWV9
         2g9QO85OWVwa1O8/Y6cr523cB3Pe79QFAqZCVZyS9We4B9OBkVXhWd9D2GuNK1ZfhB
         Tn856MC2VTaANTRmUSgqbjFtTLycyuNyLX6Fy936fgdghi51MNO4bkwR0PShju1rmt
         b7xJvlttNxlKQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AF1EE609EF;
        Thu,  2 Dec 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mctp: Don't let RTM_DELROUTE delete local routes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844761071.9736.8474116494330736070.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:20:10 +0000
References: <20211201080742.429664-1-matt@codeconstruct.com.au>
In-Reply-To: <20211201080742.429664-1-matt@codeconstruct.com.au>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        jk@codeconstruct.com.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  1 Dec 2021 16:07:42 +0800 you wrote:
> We need to test against the existing route type, not
> the rtm_type in the netlink request.
> 
> Fixes: 83f0a0b7285b ("mctp: Specify route types, require rtm_type in RTM_*ROUTE messages")
> Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
> ---
>  net/mctp/route.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net] mctp: Don't let RTM_DELROUTE delete local routes
    https://git.kernel.org/netdev/net/c/76d001603c50

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


