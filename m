Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DB1252F4A
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 15:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730152AbgHZNFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 09:05:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52356 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730163AbgHZNEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 09:04:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kAv6X-00BwXk-DJ; Wed, 26 Aug 2020 15:04:41 +0200
Date:   Wed, 26 Aug 2020 15:04:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        oleksandr.mazur@plvision.eu, serhiy.boiko@plvision.eu,
        serhiy.pshyk@plvision.eu, volodymyr.mytnyk@plvision.eu,
        taras.chornyi@plvision.eu, andrii.savka@plvision.eu,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, mickeyr@marvell.com
Subject: Re: [net-next v5 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200826130441.GR2403519@lunn.ch>
References: <20200825122013.2844-1-vadym.kochan@plvision.eu>
 <20200825122013.2844-2-vadym.kochan@plvision.eu>
 <20200825.172003.1417643181819895272.davem@davemloft.net>
 <20200826081744.GA2729@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826081744.GA2729@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> There is a limitation on the DMA range. Current device can't handle
> whole ZONE_DMA range, so there is a "backup" mechanism which copies the
> entire packet if the mapping was failed or if the packet's mapped
> address is out of this range, this is done on both rx and tx directions.

If you use the DMA API correct, it should hide all this, and do the
bounce buffers for you. But i'm no DMA expert...

       Andrew
