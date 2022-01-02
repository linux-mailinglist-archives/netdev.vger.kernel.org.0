Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCBA482BD8
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbiABQUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiABQUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D662EC061761;
        Sun,  2 Jan 2022 08:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60E0960F28;
        Sun,  2 Jan 2022 16:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C83E7C36AEF;
        Sun,  2 Jan 2022 16:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641140408;
        bh=OWPAcX5W9YO4VRgLlKi/wh9YuvxFOfDeRVi74HY2SRI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CsgIuFTgLO3VnRAT5rE6F2aogkuP6Gc6ATSE5Ph8HmOg6zcjvuIK9BXm4J7hkm9Z2
         wsi1mxcOv5LCotP3D4x0B5vJhKLgy3fjhHkHchkl9oL73rJ9Z7QK8gkTd45anGbsCa
         Pf6da9wjQrxiI98p2COEddW8H1n8F9zKTn2dNCJFhA2y/M3W7QGBZXMdBFmQCUgtxb
         orJvBDGeKS6VSICLrNZdOSjln090ZSmEu5CyipMB5LQ6YkVrw3KRiUGAM/gZjOfmt4
         tsTZE6Xoa823f0QTu2r0/yzEpE6K+/4ChlSMSv1TwiDwk53OXAgSA3SMH60XiII9Oa
         CZPUtLX/264iQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 991D7C395EA;
        Sun,  2 Jan 2022 16:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rndis_host: support Hytera digital radios
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164114040862.20715.16025079855839191884.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 16:20:08 +0000
References: <20220101172207.129863-1-thomas@toye.io>
In-Reply-To: <20220101172207.129863-1-thomas@toye.io>
To:     Thomas Toye <thomas@toye.io>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  1 Jan 2022 18:22:07 +0100 you wrote:
> Hytera makes a range of digital (DMR) radios. These radios can be
> programmed to a allow a computer to control them over Ethernet over USB,
> either using NCM or RNDIS.
> 
> This commit adds support for RNDIS for Hytera radios. I tested with a
> Hytera PD785 and a Hytera MD785G. When these radios are programmed to
> set up a Radio to PC Network using RNDIS, an USB interface will be added
> with class 2 (Communications), subclass 2 (Abstract Modem Control) and
> an interface protocol of 255 ("vendor specific" - lsusb even hints "MSFT
> RNDIS?").
> 
> [...]

Here is the summary with links:
  - rndis_host: support Hytera digital radios
    https://git.kernel.org/netdev/net/c/29262e1f773b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


