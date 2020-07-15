Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E64221179
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgGOPrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:47:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37056 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbgGOPrB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 11:47:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jvjcX-005GKw-I0; Wed, 15 Jul 2020 17:46:57 +0200
Date:   Wed, 15 Jul 2020 17:46:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 01/10] net: atlantic: media detect
Message-ID: <20200715154657.GT1078057@lunn.ch>
References: <20200713114233.436-1-irusskikh@marvell.com>
 <20200713114233.436-2-irusskikh@marvell.com>
 <20200713142500.GB1078057@lunn.ch>
 <f4870c58-14ff-cb30-c793-f577b02336c1@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4870c58-14ff-cb30-c793-f577b02336c1@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> Unfortunately I can't verify this on standalone PHY, but some models similar
> to what in AQC107 in theory should.
> 
> Whats your opinion then? Add this feature with phy tunable with ability to
> handle in netdev driver?

Hi Igor

Can you point to some section of the PHY datasheet? I could not find
anything which fit the vague description you have of this feature in
your patch. Maybe Heiner or I can implement and verify the PHY driver
using this feature.

Since this feature can be implemented directly in the PHY driver, and
indirectly via the MAC in firmware, it would be good to have a uniform
interface to do this. So please do add a PHY tunable via MAC driver.

Does the MAC also have the ability to configure PHY downshift? You
could implement that tunable as well.

	  Andrew
