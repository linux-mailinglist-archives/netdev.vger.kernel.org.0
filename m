Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EE125AB4F
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 14:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgIBMoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 08:44:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37980 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbgIBMoO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 08:44:14 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDS7W-00CtDO-3p; Wed, 02 Sep 2020 14:44:10 +0200
Date:   Wed, 2 Sep 2020 14:44:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dsa: bcm_sf2: recalculate switch clock
 rate based on ports
Message-ID: <20200902124410.GD3071395@lunn.ch>
References: <20200901225913.1587628-1-f.fainelli@gmail.com>
 <20200901225913.1587628-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901225913.1587628-4-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 03:59:13PM -0700, Florian Fainelli wrote:
> Whenever a port gets enabled/disabled, recalcultate the required switch
> clock rate to make sure it always gets set to the expected rate
> targeting our switch use case. This is only done for the BCM7445 switch
> as there is no clocking profile available for BCM7278.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
