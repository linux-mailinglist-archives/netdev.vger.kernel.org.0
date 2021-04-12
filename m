Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A22635C9F8
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 17:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242985AbhDLPdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 11:33:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45724 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242174AbhDLPc6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 11:32:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lVyYD-00GHY6-EN; Mon, 12 Apr 2021 17:32:33 +0200
Date:   Mon, 12 Apr 2021 17:32:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Message-ID: <YHRoEfGi3/l3K6iF@lunn.ch>
References: <20210412121430.20898-1-pali@kernel.org>
 <YHRH2zWsYkv/yjYz@lunn.ch>
 <20210412133447.fyqkavrs5r5wbino@pali>
 <YHRcu+dNKE7xC8EG@lunn.ch>
 <20210412150152.pbz5zt7mu3aefbrx@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412150152.pbz5zt7mu3aefbrx@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Anyway, now I'm looking at phy/marvell.c driver again and it supports
> only 88E6341 and 88E6390 families from whole 88E63xxx range.
> 
> So do we need to define for now table for more than
> MV88E6XXX_FAMILY_6341 and MV88E6XXX_FAMILY_6390 entries?

Probably not. I've no idea if the 6393 has an ID, so to be safe you
should add that. Assuming it has a family of its own.

       Andrew
