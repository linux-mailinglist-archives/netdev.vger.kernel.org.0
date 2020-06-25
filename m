Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F325E20A780
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 23:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406342AbgFYVb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 17:31:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32834 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390931AbgFYVb5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 17:31:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1joZTI-002G7J-Qg; Thu, 25 Jun 2020 23:31:48 +0200
Date:   Thu, 25 Jun 2020 23:31:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Meir Lichtinger <meirl@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] ethtool: Add support for 100Gbps per lane
 link modes
Message-ID: <20200625213148.GB535869@lunn.ch>
References: <20200430234106.52732-1-saeedm@mellanox.com>
 <20200430234106.52732-2-saeedm@mellanox.com>
 <20200502150857.GC142589@lunn.ch>
 <e3b31d58-fc00-4387-56a0-d787e33e77ae@mellanox.com>
 <df18c2c0a9b160bfabe0e4ba7f251e789a9d7d7c.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df18c2c0a9b160bfabe0e4ba7f251e789a9d7d7c.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> we are going to update the commit message with:
> 
>     LR, ER and FR are defined as a single link mode because they are
>     using same technology and by design are fully interoperable.
>     EEPROM content indicates if the module is LR, ER, or FR, and the
>     user space ethtool decoder is planned to support decoding these    
>     modes in the EEPROM.
> 
> Please let me know it this answer your questions, so we can re-spin
> this patch.

Hi Saeed.

This looks good to me.

Thanks
	Andrew
