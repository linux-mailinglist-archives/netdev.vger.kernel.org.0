Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D9E9D296
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 17:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732039AbfHZPUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 11:20:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59980 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbfHZPUw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 11:20:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pVr8isVMGMV2La/IFWaYhXHHZpptINHiK/g9S7qKdZk=; b=PNmpfnhfJwIIBQhahGGYSTFE6Y
        mP5RwWMmg1Qd92oadU45y4vmIGw2nm1JFG6g/a7H4vDP1AM+sm5rYShA8awZO9evm5kx7ZAf0ij3Q
        GJzSIXHRDQBzwM+yzhTpKgf3OQVzyP33A0FBAnYU9aiXwPPkXuWUwF5XwCUl/x8JjuGs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2Gna-0004Xl-IU; Mon, 26 Aug 2019 17:20:50 +0200
Date:   Mon, 26 Aug 2019 17:20:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v4 2/6] net: dsa: mv88e6xxx: update code
 operating on hidden registers
Message-ID: <20190826152050.GB2168@lunn.ch>
References: <20190826122109.20660-1-marek.behun@nic.cz>
 <20190826122109.20660-3-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190826122109.20660-3-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 02:21:05PM +0200, Marek Behún wrote:
> This patch moves the functions operating on the hidden debug registers
> into it's own file, port_hidden.c. The functions prefix is renamed from
> mv88e6390_hidden_ to mv88e6xxx_port_hidden_, to be consistent with the
> rest of this driver. The macros are prefixed with MV88E6XXX_ prefix, and
> are changed not to use the BIT() macro nor bit shifts, since the rest of
> the port.h file does not use it.
> 
> We also add the support for setting the Block Address field when
> operating hidden registers. Marvell's mdio examples for SERDES settings
> on Topaz use Block Address 0x7 when reading/writing hidden registers,
> and although the specification says that block must be set to 0xf, those
> settings are reachable only with Block Address 0x7.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
