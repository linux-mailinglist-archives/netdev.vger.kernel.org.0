Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7E02D2CF4
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgLHOS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:18:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44326 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729461AbgLHOS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 09:18:27 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kmdoE-00ApIT-SQ; Tue, 08 Dec 2020 15:17:42 +0100
Date:   Tue, 8 Dec 2020 15:17:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH net-next] net: dsa: mt7530: support setting ageing time
Message-ID: <20201208141742.GJ2475764@lunn.ch>
References: <20201208070028.3177-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208070028.3177-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 03:00:28PM +0800, DENG Qingfang wrote:
> MT7530 has a global address age control register, so use it to set
> ageing time.
> 
> The applied timer is (AGE_CNT + 1) * (AGE_UNIT + 1) seconds
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
