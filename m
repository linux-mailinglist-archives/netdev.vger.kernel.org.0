Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86EE2730AB
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbgIURMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:12:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48092 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbgIURMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 13:12:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kKPMe-00Fcfc-Al; Mon, 21 Sep 2020 19:12:32 +0200
Date:   Mon, 21 Sep 2020 19:12:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        cphealy@gmail.com, jiri@nvidia.com
Subject: Re: [PATCH net-next 0/2] Devlink regions for SJA1105 DSA driver
Message-ID: <20200921171232.GF3717417@lunn.ch>
References: <20200921162741.4081710-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921162741.4081710-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 07:27:39PM +0300, Vladimir Oltean wrote:
> This series exposes the SJA1105 static config as a devlink region. This
> can be used for debugging, for example with the sja1105_dump user space
> program that I have derived from Andrew Lunn's mv88e6xxx_dump:
> 
> https://github.com/vladimiroltean/mv88e6xxx_dump/tree/sja1105

Maybe i should rename the project dsa_dump?

      Andrew
