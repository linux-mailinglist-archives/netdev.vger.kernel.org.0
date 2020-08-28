Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F37D255283
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 03:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgH1BXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 21:23:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57250 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgH1BXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 21:23:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kBT6a-00CDTY-W4; Fri, 28 Aug 2020 03:23:00 +0200
Date:   Fri, 28 Aug 2020 03:23:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, opensource@vdorst.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        frank-w@public-files.de, dqfext@gmail.com
Subject: Re: [PATCH] net: dsa: mt7530: fix advertising unsupported
Message-ID: <20200828012300.GA2867734@lunn.ch>
References: <20200827091547.21870-1-landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827091547.21870-1-landen.chao@mediatek.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 05:15:47PM +0800, Landen Chao wrote:
> 1000baseT_Half
> 
> Remove 1000baseT_Half to advertise correct hardware capability in
> phylink_validate() callback function.
> 
> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> Signed-off-by: Landen Chao <landen.chao@mediatek.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
