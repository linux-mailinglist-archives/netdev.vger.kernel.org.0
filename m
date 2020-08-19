Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EDB249FB9
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 15:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHSNZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 09:25:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33360 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbgHSNQL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 09:16:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k8Nwc-00A5NA-IT; Wed, 19 Aug 2020 15:15:58 +0200
Date:   Wed, 19 Aug 2020 15:15:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 2/2] net: dsa: loop: Return VLAN table size
 through devlink
Message-ID: <20200819131558.GB2403519@lunn.ch>
References: <20200819043218.19285-1-f.fainelli@gmail.com>
 <20200819043218.19285-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819043218.19285-3-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 09:32:18PM -0700, Florian Fainelli wrote:
> We return the VLAN table size through devlink as a simple parameter, we
> do not support altering it at runtime:
> 
> devlink resource show mdio_bus/fixed-0:1f
> mdio_bus/fixed-0:1f:
>   name VTU size 4096 occ 0 unit entry dpipe_tables none
> 
> and after configure a bridge with VLAN filtering:
> 
> devlink resource show mdio_bus/fixed-0:1f
> mdio_bus/fixed-0:1f:
>   name VTU size 4096 occ 1 unit entry dpipe_tables none
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
