Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4B6355F63
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbhDFXXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:23:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232287AbhDFXXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:23:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTv22-00FCxY-TK; Wed, 07 Apr 2021 01:22:50 +0200
Date:   Wed, 7 Apr 2021 01:22:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v3 06/18] net: phy: marvell10g: add MACTYPE
 definitions for 88E21xx
Message-ID: <YGztSgRyIZXZZIOf@lunn.ch>
References: <20210406221107.1004-1-kabel@kernel.org>
 <20210406221107.1004-7-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210406221107.1004-7-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 12:10:55AM +0200, Marek Behún wrote:
> Add all MACTYPE definitions for 88E2110, 88E2180, 88E2111 and 88E2181.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
