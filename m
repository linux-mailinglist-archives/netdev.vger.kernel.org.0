Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1202C2B2AD4
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 03:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgKNCaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 21:30:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgKNCaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 21:30:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605321006;
        bh=PZlfffNiZWFp/pyvzD7L2zhygg8KGfjS3jtECL+YjcY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fIJrULIWrgiIRQ58LcO6cDma/C3dlZK35Wj1vYsYmBIlgGqV8HoZXrU7VOIG67np/
         L8e5YM0TK5463uttvRIVmifv+Xbly7KtAvjmlzXhvYxhPvbJ9NDLCB5qjPJbTeCjn6
         J2q1niOtuQdyETXDE1VC+hXRkfmHaDfrRNlk2KMI=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: mscc: Add PTP support for 2 more VSC PHYs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160532100626.25955.13794645605609047033.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Nov 2020 02:30:06 +0000
References: <20201112092250.914079-1-steen.hegelund@microchip.com>
In-Reply-To: <20201112092250.914079-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, atenart@kernel.org,
        Bryan.Whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        John.Haechten@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 12 Nov 2020 10:22:50 +0100 you wrote:
> Add VSC8572 and VSC8574 in the PTP configuration
> as they also support PTP.
> 
> The relevant datasheets can be found here:
>   - VSC8572: https://www.microchip.com/wwwproducts/en/VSC8572
>   - VSC8574: https://www.microchip.com/wwwproducts/en/VSC8574
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: mscc: Add PTP support for 2 more VSC PHYs
    https://git.kernel.org/netdev/net-next/c/774626fa440e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


