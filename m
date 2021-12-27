Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F083347FE03
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 16:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhL0PAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 10:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhL0PAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 10:00:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB86C06173E;
        Mon, 27 Dec 2021 07:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0D6161040;
        Mon, 27 Dec 2021 15:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5343BC36AEB;
        Mon, 27 Dec 2021 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640617210;
        bh=l0pwH5RoAOLYnf89yuclXw0HClkZpGcRlN8zyua9Ewg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MOAss8yx8339h0NJFroSaHQi6t5boRLbwwhSkleOm8vN4IDl8Sj3cM8FdbjXqKnNU
         qTUVGHzeSG9uh6xnawSFuZfK2CmQu3Q1towVO/j5rwYBr+tPA2rhKLX/2Hx9s/gRrn
         v6yGpHtqBFNhCwsJ6Cdt0r/MP7KJ7zCdczTHtJjykqAqPFRDSEVPT8cHK8QjBjsFee
         u5y3G4rFsZSBxSFSLIuPnOBBBIY6zTXYAplZi+v1Y1B3xJPsoL5VcJF/LQ0burOcqE
         qSkLQG1jCg0t/KN1uUw8x1egipJbsb3afohYVB9cq3QK46JNWYvXkK0JiwPv2KiC68
         V866e5y5rSh/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B3BDC395E6;
        Mon, 27 Dec 2021 15:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: usb: pegasus: Do not drop long Ethernet frames
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164061721023.30887.10543849248134029481.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Dec 2021 15:00:10 +0000
References: <20211226221208.2583-1-ott@mirix.org>
In-Reply-To: <20211226221208.2583-1-ott@mirix.org>
To:     Matthias-Christian Ott <ott@mirix.org>
Cc:     petkan@nucleusys.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 26 Dec 2021 23:12:08 +0100 you wrote:
> The D-Link DSB-650TX (2001:4002) is unable to receive Ethernet frames
> that are longer than 1518 octets, for example, Ethernet frames that
> contain 802.1Q VLAN tags.
> 
> The frames are sent to the pegasus driver via USB but the driver
> discards them because they have the Long_pkt field set to 1 in the
> received status report. The function read_bulk_callback of the pegasus
> driver treats such received "packets" (in the terminology of the
> hardware) as errors but the field simply does just indicate that the
> Ethernet frame (MAC destination to FCS) is longer than 1518 octets.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: usb: pegasus: Do not drop long Ethernet frames
    https://git.kernel.org/netdev/net/c/ca506fca461b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


