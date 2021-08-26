Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4163F83EE
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 10:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240560AbhHZIux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 04:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229785AbhHZIuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 04:50:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D258460FD7;
        Thu, 26 Aug 2021 08:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629967805;
        bh=POZZ1UD83V2W9jx2eCwOQJ2I2npbT1zgL3/YAZr7kNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sUQl0DAuVAJJI0HNn/Xa1XqhdKXS8FDog00NQ/epaqXqT/WN73H74ZcwVoSz3sFGH
         b/idyLvFxISoQHqSvvyczk39ZGDobuRT+wt0DE0gw8g+GIfXxcc0uBdjX82HqAe4mp
         rbMOQei8BCB8xmOjJg9rdR1xEVlYPVuecm/AapN1M40FqzkGr6RkTR9UOQjTFTXdL3
         5Ynk7GBMpXX/uTUCEDfYixcPheItAaGyM0xH/m9kUNkWj9Uj1D11WWBKwj9TClM1ST
         0gXCyjfDhnScz2sF4eBWW0aWTOs7/i3KXCon0FYKlgFLv10wnzwDl4tBy1wh0mA0e8
         SKbsjETwzDlvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C6D2C609EA;
        Thu, 26 Aug 2021 08:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] can: usb: esd_usb2: esd_usb2_rx_event(): fix the
 interchange of the CAN RX and TX error counters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162996780580.25573.14539440124806038671.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 08:50:05 +0000
References: <20210826064456.1427513-2-mkl@pengutronix.de>
In-Reply-To: <20210826064456.1427513-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        stefan.maetje@esd.eu, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 26 Aug 2021 08:44:56 +0200 you wrote:
> From: Stefan Mätje <stefan.maetje@esd.eu>
> 
> This patch fixes the interchanged fetch of the CAN RX and TX error
> counters from the ESD_EV_CAN_ERROR_EXT message. The RX error counter
> is really in struct rx_msg::data[2] and the TX error counter is in
> struct rx_msg::data[3].
> 
> [...]

Here is the summary with links:
  - [net] can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters
    https://git.kernel.org/netdev/net/c/044012b52029

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


