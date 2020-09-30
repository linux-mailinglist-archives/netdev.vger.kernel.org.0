Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C141327EACE
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 16:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgI3OWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 10:22:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726680AbgI3OWF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 10:22:05 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNczc-00GuV1-2V; Wed, 30 Sep 2020 16:22:04 +0200
Date:   Wed, 30 Sep 2020 16:22:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 3/3] net: atlantic: implement media detect
 feature via phy tunables
Message-ID: <20200930142204.GK3996795@lunn.ch>
References: <20200929161307.542-1-irusskikh@marvell.com>
 <20200929161307.542-4-irusskikh@marvell.com>
 <20200929171815.GD3996795@lunn.ch>
 <b43fb357-3fd1-c1a5-e2ff-894eb11c2bbb@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b43fb357-3fd1-c1a5-e2ff-894eb11c2bbb@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The problem here is that FW interface only allows us to switch this mode on or
> off. We can't control the interval value for this device.
> Thus, we only can enable it, or disable. Basically ignoring the interval value.

Hi Igor

Since this is your own PHY, not some magical black box, i assume you
actually know what value it is using? It probably even lists it in the
data sheet.

So just hard code that value in the driver. That has got to be better
than saying the incorrect value of 1ms.

   Andrew
