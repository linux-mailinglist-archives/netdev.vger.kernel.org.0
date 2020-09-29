Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66B827D418
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgI2REQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:04:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33998 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgI2REQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 13:04:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNJ2z-00GmNZ-8D; Tue, 29 Sep 2020 19:04:13 +0200
Date:   Tue, 29 Sep 2020 19:04:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 0/3] net: atlantic: phy tunables from mac driver
Message-ID: <20200929170413.GA3996795@lunn.ch>
References: <20200929161307.542-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929161307.542-1-irusskikh@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 07:13:04PM +0300, Igor Russkikh wrote:
> This series implements phy tunables settings via MAC driver callbacks.
> 
> AQC 10G devices use integrated MAC+PHY solution, where PHY is fully controlled
> by MAC firmware. Therefore, it is not possible to implement separate phy driver
> for these.
> 
> We use ethtool ops callbacks to implement downshift and EDPC tunables.

Hi Michal

Do you have any code to implement tunables via netlink?

This code is defining new ethtool calls. It seems like now would be a
good time to plumb in extack, so the driver can report back the valid
range of a tunable when given an unsupported value.

      Andrew
