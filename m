Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4BF2A0F5C
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgJ3UWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:22:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55430 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgJ3UWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 16:22:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYauN-004PUq-Ho; Fri, 30 Oct 2020 21:21:59 +0100
Date:   Fri, 30 Oct 2020 21:21:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Subject: Re: [PATCH v3 3/3] dt-bindings: net: ftgmac100: describe phy-handle
 and MDIO
Message-ID: <20201030202159.GG1042051@lunn.ch>
References: <20201030133707.12099-1-i.mikhaylov@yadro.com>
 <20201030133707.12099-4-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030133707.12099-4-i.mikhaylov@yadro.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 04:37:07PM +0300, Ivan Mikhaylov wrote:
> Add the phy-handle and MDIO description and add the example with
> PHY and MDIO nodes.
> 
> Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
