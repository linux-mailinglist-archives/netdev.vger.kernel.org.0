Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6084823AE17
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgHCU3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:29:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41006 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbgHCU3W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 16:29:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k2h5E-0086dX-8J; Mon, 03 Aug 2020 22:29:20 +0200
Date:   Mon, 3 Aug 2020 22:29:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 5/5] net: dsa: loop: Set correct number of ports
Message-ID: <20200803202920.GC1919070@lunn.ch>
References: <20200803200354.45062-1-f.fainelli@gmail.com>
 <20200803200354.45062-6-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803200354.45062-6-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 01:03:54PM -0700, Florian Fainelli wrote:
> We only support DSA_LOOP_NUM_PORTS in the switch, do not tell the DSA
> core to allocate up to DSA_MAX_PORTS which is nearly the double (6 vs.
> 11).
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
