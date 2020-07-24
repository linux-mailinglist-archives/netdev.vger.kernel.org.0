Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F4022C878
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 16:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgGXOwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 10:52:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53802 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgGXOwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 10:52:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jyz3T-006gnV-B2; Fri, 24 Jul 2020 16:52:11 +0200
Date:   Fri, 24 Jul 2020 16:52:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] net: dsa: mv88e6xxx: port mtu support
Message-ID: <20200724145211.GB1594328@lunn.ch>
References: <20200723232122.5384-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723232122.5384-1-chris.packham@alliedtelesis.co.nz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 11:21:19AM +1200, Chris Packham wrote:
> This series connects up the mv88e6xxx switches to the dsa infrastructure for
> configuring the port MTU. The first patch is also a bug fix which might be a
> candiatate for stable.
> 
> I've rebased this series on top of net-next/master to pick up Andrew's change
> for the gigabit switches.

Hi Chris

Please put in the subject line "PATCH net-next v2", so it is clear
which tree this is for.

https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#q-how-do-i-indicate-which-tree-net-vs-net-next-my-patch-should-be-in

Thanks
	Andrew
