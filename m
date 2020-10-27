Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E72229C6E1
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 19:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1827469AbgJ0SYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 14:24:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48036 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1827191AbgJ0SWD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 14:22:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXTbU-003qb6-Ey; Tue, 27 Oct 2020 19:21:52 +0100
Date:   Tue, 27 Oct 2020 19:21:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Subject: Re: [PATCH v2 1/2] net: ftgmac100: move phy connect out from
 ftgmac100_setup_mdio
Message-ID: <20201027182152.GD904240@lunn.ch>
References: <20201027144924.22183-1-i.mikhaylov@yadro.com>
 <20201027144924.22183-2-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027144924.22183-2-i.mikhaylov@yadro.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 05:49:23PM +0300, Ivan Mikhaylov wrote:
> Split MDIO registration and PHY connect into ftgmac100_setup_mdio and
> ftgmac100_mii_probe.
> 
> Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
