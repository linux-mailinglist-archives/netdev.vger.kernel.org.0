Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B7B35782F
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhDGXEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:04:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39158 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhDGXEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 19:04:05 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUHDF-00FOoi-IS; Thu, 08 Apr 2021 01:03:53 +0200
Date:   Thu, 8 Apr 2021 01:03:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, kuba@kernel.org
Subject: Re: [PATCH net-next v4 07/16] net: phy: marvell10g: support all rate
 matching modes
Message-ID: <YG46WWN9HWpxyl6i@lunn.ch>
References: <20210407202254.29417-1-kabel@kernel.org>
 <20210407202254.29417-8-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210407202254.29417-8-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 10:22:45PM +0200, Marek Behún wrote:
> Add support for all rate matching modes for 88X3310 (currently only
> 10gbase-r is supported, but xaui and rxaui can also be used).
> 
> Add support for rate matching for 88E2110 (on 88E2110 the MACTYPE
> register is at a different place).
> 
> Currently rate matching mode is selected by strapping pins (by setting
> the MACTYPE register). There is work in progress to enable this driver
> to deduce the best MACTYPE from the knowledge of which interface modes
> are supported by the host, but this work is not finished yet.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
