Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C494A6AF8
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244537AbiBBEkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244493AbiBBEkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 23:40:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B90AC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 20:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED89E616EF
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 04:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57C79C340E4;
        Wed,  2 Feb 2022 04:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643776810;
        bh=xrmoBeHjDvkokHEQB5Ln31iKhIPkYngg7cHzwJ5/q2Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N41rHkqbSVtOGr3fCS7dwCXYOPIqTjL+E223j8Y7Ku/bRYxuORqRdOp+t74Dvb6h9
         cdQM6DMTto0WgBOeSvPj/3b1TqWGm0KZD0dH+c4zDiDNzyNKwE0REKOhPnDChYaJ5s
         An00NOefA7qplPg1p7+LjURCjieA+R8h7C0U3xBSlY81IJAGuj/ECLwbh74ANos5ve
         b7Gu9wvMDBWBnNeQ8VmUq7N8xwbXjO+9cUsRQoRnlIGRYILxY4OnOmhzFxNfUIT5Qe
         7wOF8lOg4Jke92AApJ2KAwJhWRcExvcXgUtvNJOUjLPLxTxNOfotJQcVvwRzdznDAy
         CRFNscY83hlDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43B1BE5D09D;
        Wed,  2 Feb 2022 04:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: support L1.2 control on RTL8168h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164377681027.17347.7644803926910668400.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 04:40:10 +0000
References: <4784d5ce-38ac-046a-cbfa-5fdd9773f820@gmail.com>
In-Reply-To: <4784d5ce-38ac-046a-cbfa-5fdd9773f820@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 31 Jan 2022 19:37:22 +0100 you wrote:
> According to Realtek RTL8168h supports the same L1.2 control as RTL8125.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net-next] r8169: support L1.2 control on RTL8168h
    https://git.kernel.org/netdev/net-next/c/68650b4e6c13

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


