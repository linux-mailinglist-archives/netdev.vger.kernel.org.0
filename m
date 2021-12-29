Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6399A48173B
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 23:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhL2WUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 17:20:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53114 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbhL2WUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 17:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53D70B81840
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 22:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16FF6C36AEC;
        Wed, 29 Dec 2021 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640816410;
        bh=O236eeEC9IJf8prtFTujbnAiZZ8X1hAZAjA/PkUFx8o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Aw03CNrXJhT3kAAvpL78w/Y0+hq2U2vd5/PBCDzLhEXq9/JDw5b1OoaFUz6p3pDeg
         noXfkRPY6XO448oXF2l/LvInLHsUZVVqEzPY0MDtY2DiFnZfHt/hgF0u+TNecT8PpF
         xg2VDLHfREVuOf8q0qGOhRA9TIu3M/OShGUfNO3MVf0tI1OoVeIQnW0CnrZcrXbC6m
         tpklojRG0ie1L5rzPH04gVsvbeK3e7tY0g/wx0PqArlQgGifeye29E6e8wb37dTx1H
         /EDYa9DZ4HDbCa2uagDkP6Q1G7b9ZLxTw6gM8He6dpvPUL9NGPGLLnsKZ9f8D5zwqd
         e7FPLOSAJpMjQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3706C395DD;
        Wed, 29 Dec 2021 22:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: raw: check passed optlen before reading
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164081640999.5072.6647582003986973453.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Dec 2021 22:20:09 +0000
References: <20211229200947.2862255-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20211229200947.2862255-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tamird@gmail.com, willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Dec 2021 15:09:47 -0500 you wrote:
> From: Tamir Duberstein <tamird@gmail.com>
> 
> Add a check that the user-provided option is at least as long as the
> number of bytes we intend to read. Before this patch we would blindly
> read sizeof(int) bytes even in cases where the user passed
> optlen<sizeof(int), which would potentially read garbage or fault.
> 
> [...]

Here is the summary with links:
  - [net] ipv6: raw: check passed optlen before reading
    https://git.kernel.org/netdev/net/c/fb7bc9204095

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


