Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B58337B27
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 18:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhCKRl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 12:41:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52380 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhCKRlt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 12:41:49 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKPJc-00AOPZ-Fp; Thu, 11 Mar 2021 18:41:40 +0100
Date:   Thu, 11 Mar 2021 18:41:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next,v2 1/3] net: dsa: mt7530: setup core clock even
 in TRGMII mode
Message-ID: <YEpWVAnYLkytpIWB@lunn.ch>
References: <20210311020954.842341-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311020954.842341-1-ilya.lipnitskiy@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 06:09:52PM -0800, Ilya Lipnitskiy wrote:
> A recent change to MIPS ralink reset logic made it so mt7530 actually
> resets the switch on platforms such as mt7621 (where bit 2 is the reset
> line for the switch). That exposed an issue where the switch would not
> function properly in TRGMII mode after a reset.
> 
> Reconfigure core clock in TRGMII mode to fix the issue.
> 
> Tested on Ubiquiti ER-X (MT7621) with TRGMII mode enabled.

Please don't submit the same patch to net and net-next.  Anything
which is accepted into net, will get merged into net-next about a week
later. If your other two patches depend on this patch, you need to
wait for the merge to happen, then submit them.

	  Andrew
