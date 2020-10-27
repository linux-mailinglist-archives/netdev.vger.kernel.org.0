Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4E929C6DC
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 19:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1827443AbgJ0SYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 14:24:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48058 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1827299AbgJ0SYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 14:24:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXTdS-003qce-1h; Tue, 27 Oct 2020 19:23:54 +0100
Date:   Tue, 27 Oct 2020 19:23:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Subject: Re: [PATCH v2 2/2] net: ftgmac100: add handling of mdio/phy nodes
 for ast2400/2500
Message-ID: <20201027182354.GE904240@lunn.ch>
References: <20201027144924.22183-1-i.mikhaylov@yadro.com>
 <20201027144924.22183-3-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027144924.22183-3-i.mikhaylov@yadro.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 05:49:24PM +0300, Ivan Mikhaylov wrote:
> phy-handle can't be handled well for ast2400/2500 which has an embedded
> MDIO controller. Add ftgmac100_mdio_setup for ast2400/2500 and initialize
> PHYs from mdio child node with of_mdiobus_register.
> 
> Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>

Please also update the binding documentation to indicate an MDIO node
can be used.

    Andrew
