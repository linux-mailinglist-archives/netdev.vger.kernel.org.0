Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C436355F82
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbhDFXdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:33:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36862 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232844AbhDFXdn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:33:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTvCP-00FD4D-RJ; Wed, 07 Apr 2021 01:33:33 +0200
Date:   Wed, 7 Apr 2021 01:33:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v3 07/18] net: phy: marvell10g: support all rate
 matching modes
Message-ID: <YGzvzfLYMWLHA6b6@lunn.ch>
References: <20210406221107.1004-1-kabel@kernel.org>
 <20210406221107.1004-8-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210406221107.1004-8-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 12:10:56AM +0200, Marek Behún wrote:
> Add support for all rate matching modes for 88X3310 (currently only
> 10gbase-r is supported, but xaui and rxaui can also be used).
> 
> Add support for rate matching for 88E2110 (on 88E2110 the MACTYPE
> register is at a different place).

What is not clear to me is how rate matching mode gets enabled. What
sets the mactype to one of these modes?

It probably just needs an explanation here in the commit message.

   Andrew
