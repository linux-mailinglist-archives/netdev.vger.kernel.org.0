Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4AF2C7444
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388732AbgK1Vto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54496 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733250AbgK1SNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 13:13:43 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kj3Eb-009Gkz-T7; Sat, 28 Nov 2020 17:38:05 +0100
Date:   Sat, 28 Nov 2020 17:38:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, olteanv@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201128163805.GB2191767@lunn.ch>
References: <20201119144508.29468-3-tobias@waldekranz.com>
 <20201120003009.GW1804098@lunn.ch>
 <5e2d23da-7107-e45e-0ab3-72269d7b6b24@gmail.com>
 <20201120133050.GF1804098@lunn.ch>
 <87v9dr925a.fsf@waldekranz.com>
 <20201126225753.GP2075216@lunn.ch>
 <87r1of88dp.fsf@waldekranz.com>
 <20201127162818.GT2073444@lunn.ch>
 <87lfem8k2b.fsf@waldekranz.com>
 <6480e69b-beb2-d3cd-6bf9-75e3b81e5606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6480e69b-beb2-d3cd-6bf9-75e3b81e5606@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > OK I think I finally see what you are saying. Sorry it took me this
> > long. I do not mean to be difficult, I just want to understand.

Not a problem. This is a bit different to normal, the complexity of
the stack means you need to handle this different to most drivers. If
you have done any deeply embedded stuff, RTOS, allocating everything
up front is normal, it eliminates a whole class of problems.

> > 
> > How about this:
> > 
> > - Add a `lags_max` field to `struct dsa_switch` to let each driver
> >   define the maximum number supported by the hardware.

This is all reasonable. I just wonder what that number is for the
mv88e6xx case, especially for D in DSA. I guess LAGs are global in
scope across a set of switches. So it does not matter if there is one
switch or lots of switches, the lags_max stays the same.

      Andrew
