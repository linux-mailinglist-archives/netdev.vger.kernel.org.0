Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8FD9C0B8
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 00:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbfHXW3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 18:29:51 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54018 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbfHXW3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 18:29:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KgLGmqz/luWIy9zKj3FDN98xWu56ty660JouMxtEr68=; b=Lwxe6oqB/J9UPt424/kBrbn6f
        SKDIiSicjpF8GzMD6CyBoa8Z23ad8kLubvU8o8Va6gLlwjLwLg32z9xoVeF2qgML4y4pmfkcKSHlY
        uxPbCmKhzMwkiEQDbsroSju3YhkIbI+4vlZ09xw14duzOah/tq98unBJNCVkH+r4//SpZmZgZZRHx
        tmAo4/1SxpqWafF0U87szm5FubgzEboKB0AAli2Uq965QUgWawiJFPIYCYYfKOX8uPjKfsgn1E4BT
        II7R/U0IAKpRdKG5ELlc6ruS6h7FQ05BizbINS5UfZSmX/gJPZ0IoHvbA6dCqu3npqszxny9K6OAm
        sK0R50Esg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:54162)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i1eXS-0005VI-Kg; Sat, 24 Aug 2019 23:29:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i1eXP-0002yX-7f; Sat, 24 Aug 2019 23:29:35 +0100
Date:   Sat, 24 Aug 2019 23:29:35 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 0/3] net: dsa: mt7530: Convert to PHYLINK and
 add support for port 5
Message-ID: <20190824222935.GG13294@shell.armlinux.org.uk>
References: <20190821144547.15113-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190821144547.15113-1-opensource@vdorst.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 04:45:44PM +0200, René van Dorst wrote:
> 1. net: dsa: mt7530: Convert to PHYLINK API
>    This patch converts mt7530 to PHYLINK API.
> 2. dt-bindings: net: dsa: mt7530: Add support for port 5
> 3. net: dsa: mt7530: Add support for port 5
>    These 2 patches adding support for port 5 of the switch.
> 
> v1->v2:
>  * Mostly phylink improvements after review.
> rfc -> v1:
>  * Mostly phylink improvements after review.
>  * Drop phy isolation patches. Adds no value for now.
> René van Dorst (3):
>   net: dsa: mt7530: Convert to PHYLINK API
>   dt-bindings: net: dsa: mt7530: Add support for port 5
>   net: dsa: mt7530: Add support for port 5
> 
>  .../devicetree/bindings/net/dsa/mt7530.txt    | 218 ++++++++++
>  drivers/net/dsa/mt7530.c                      | 371 +++++++++++++++---
>  drivers/net/dsa/mt7530.h                      |  61 ++-
>  3 files changed, 577 insertions(+), 73 deletions(-)

Having looked through this set of patches, I don't see anything
from the phylink point of view that concerns me.  So, for the
series from the phylink perspective:

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

I did notice a dev_info() in patch 3 that you may like to consider
whether they should be printed at info level or debug level.  You
may keep my ack on the patch when fixing that.

I haven't considered whether the patch passes davem's style
requirements for networking code; what I spotted did look like
the declarations were upside-down christmas tree.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
